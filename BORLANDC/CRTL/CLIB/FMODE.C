/*------------------------------------------------------------------------*
 * filename - fmode.c
 *
 * function(s)
 *        none
 *-----------------------------------------------------------------------*/

/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     C/C++ Run Time Library - Version 4.0                     |*/
/*|                                                              |*/
/*|                                                              |*/
/*|     Copyright (c) 1987, 1991 by Borland International        |*/
/*|     All Rights Reserved.                                     |*/
/*|                                                              |*/
/*[]------------------------------------------------------------[]*/


#include <fcntl.h>

/*  Modal variables for low-level filing. */

        int     _fmode = O_TEXT;

        int     _notUmask = ~0;
