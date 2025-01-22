/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     fsbsync.cpp                                              |*/
/*|                                                              |*/
/*|     Class filebuf                                            |*/
/*|          int filebuf::sync()                                 |*/
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

int filebuf::sync()
{
    if( out_waiting() )
        {
        if( overflow(EOF) == EOF )
            return EOF;
        }
    else if( in_avail() )
        {
        last_seek = ::lseek(xfd, long(-in_avail()), L_cur);
        setg(eback(), gptr(), gptr());
        setp(gptr(), gptr());
        if( last_seek == long(OS_err) )
            return EOF;
        }
    return 0;
}


