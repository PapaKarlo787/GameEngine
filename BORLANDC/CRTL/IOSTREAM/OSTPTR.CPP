/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     ostptr.cpp                                               |*/
/*|                                                              |*/
/*|     Class ostream                                            |*/
/*|          ostream& ostream::operator<< (void* p)              |*/
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

// insert character representation of the value of the pointer
ostream _FAR & ostream::operator<< (void* p)
{
    long f = flags();
    setf((ios::hex | ios::showbase), (ios::basefield | ios::showbase));
    *this << (unsigned long)p;
    flags(f);
    return *this;
}


