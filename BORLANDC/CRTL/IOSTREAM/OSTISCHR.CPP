/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     ostischr.cpp                                             |*/
/*|                                                              |*/
/*|     Class ostream                                            |*/
/*|          ostream& ostream::operator<< ( signed char )        |*/
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

ostream _FAR & ostream::operator<< (signed char c)
{
    if( opfx() )
        {
        if( bp->sputc(c) == EOF )
            setstate(ios::badbit);
        }
    osfx();
    return *this;
}


