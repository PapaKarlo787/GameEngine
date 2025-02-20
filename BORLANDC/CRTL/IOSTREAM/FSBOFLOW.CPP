/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     fsboflow.cpp                                             |*/
/*|                                                              |*/
/*|     Class filebuf                                            |*/
/*|          int filebuf::overflow( int )                        |*/
/*|                                                              |*/
/*[]------------------------------------------------------------[]*/

/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     C/C++ Run Time Library - Version 4.0                     |*/
/*|                                                              |*/
/*|                                                              |*/
/*|     Copyright (c) 1990, 1991 by Borland International        |*/
/*|     All Rights Reserved.                                     |*/
/*|                                                              |*/
/*[]------------------------------------------------------------[]*/

#include <ioconfig.h>
#include "filesys.h"
#include <fstream.h>

// always flush

int filebuf::overflow(int c)
{
    if( ! opened  ||  (mode & (ios::in | ios::out)) == ios::in )
        return EOF;

    if( unbuffered()  ||  ! base() )
        {
        if( c != EOF )
            {
            char b = c;
            if( ::write(xfd, &b, 1) != 1 )
                return EOF;
            }
        }
    else
        {
        // now we know this is buffered and state is not bad
        int count = out_waiting();
        if( count )
            if( ::write(xfd, pbase(), count) != count )
                return EOF;

        // reset get and put areas
        int pb = (blen() > 8) ? 4 : 1;  // putback area size
        char *b = base();
        setp(b+pb, b+blen());
        setg(b, b+pb, b+pb);
        if( c != EOF )
            {
            sputc(c);
            gbump(1);       // pptr and gptr must be the same
            }
        }
    return 1;
}


