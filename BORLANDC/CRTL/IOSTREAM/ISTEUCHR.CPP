/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     isteuchr.cpp                                             |*/
/*|                                                              |*/
/*|     Class istream                                            |*/
/*|          istream& istream::operator>> ( unsigned char& )     |*/
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

istream _FAR & istream::operator>> (unsigned char _FAR & c)
{
    if( ipfx0() )
        c = bp->in_avail() ? bp->sbumpc() : do_get();
    return *this;
}


