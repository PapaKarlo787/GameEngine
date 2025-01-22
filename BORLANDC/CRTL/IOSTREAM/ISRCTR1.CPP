/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     isrctr1.cpp                                              |*/
/*|                                                              |*/
/*|     Class istrstream                                          |*/
/*|          istrstream::istrstream( char * )                    |*/
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

istrstream::istrstream(char* str) :
        strstreambase(str, 0, 0),
        istream(strstreambase::rdbuf())
{
}


