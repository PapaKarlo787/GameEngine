/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     iofsctr3.cpp                                             |*/
/*|                                                              |*/
/*|     Class fstream                                            |*/
/*|          fstream::fstream( int )                             |*/
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

fstream::fstream(int f) :
        fstreambase(f),
        iostream()
{
}


