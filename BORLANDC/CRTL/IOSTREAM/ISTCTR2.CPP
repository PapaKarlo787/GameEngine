/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     istctr2.cpp                                              |*/
/*|                                                              |*/
/*|     Class istream                                            |*/
/*|          istream::istream( streambuf * )                     |*/
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

istream::istream(streambuf* s)
{
    ios::init(s);
    gcount_ = 0;
}


