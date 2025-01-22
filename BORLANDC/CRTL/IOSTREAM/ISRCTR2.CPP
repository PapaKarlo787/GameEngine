/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     isrctr2.cpp                                              |*/
/*|                                                              |*/
/*|     Class itrstream                                          |*/
/*|          istrstream::istrstream( char *, int )               |*/
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
#include <strstrea.h>

istrstream::istrstream(char* str, int len) :
        strstreambase(str, len, 0),
        istream(strstreambase::rdbuf())
{
}


