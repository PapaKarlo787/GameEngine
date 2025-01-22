/*-----------------------------------------------------------------------*
 * filename - pureerr.cpp
 * Error routine linked in when pure function called
 *-----------------------------------------------------------------------*/

/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     C/C++ Run Time Library - Version 4.0                     |*/
/*|                                                              |*/
/*|                                                              |*/
/*|     Copyright (c) 1990, 1991 by Borland International        |*/
/*|     All Rights Reserved.                                     |*/
/*|                                                              |*/
/*[]------------------------------------------------------------[]*/

/*
   A pointer to this routine is linked into virtual vectors whenever
   a virtual function has been declared pure.
*/

#include <stdlib.h>
#include <_io.h>

extern "C" void near _npure_error_()
{
        __ErrorMessage("Pure virtual function called");
        exit(EXIT_FAILURE);
}

extern "C" void far _fpure_error_()
{
        __ErrorMessage("Pure virtual function called");
        exit(EXIT_FAILURE);
}
