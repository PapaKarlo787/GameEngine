/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     iostctr1.cpp                                             |*/
/*|                                                              |*/
/*|     Class iostream                                           |*/
/*|          iostream::iostream( streambuf * )                   |*/
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

iostream::iostream(streambuf* s) :
        istream(),
        ostream()
{
    ios::init(s);
}


