/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     stbpbfl.cpp                                              |*/
/*|                                                              |*/
/*|     Class streambuf                                          |*/
/*|          int streambuf::pbackfail( int )                     |*/
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
#include <iostream.h>

int streambuf::pbackfail(int)
{
    return EOF;
}


