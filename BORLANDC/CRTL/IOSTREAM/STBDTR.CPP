/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     stbdtr.cpp                                               |*/
/*|                                                              |*/
/*|     Class streambuf                                          |*/
/*|          streambuf::~streambuf()                             |*/
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

streambuf::~streambuf()
{
    if( alloc_ )
        delete base_;
}


