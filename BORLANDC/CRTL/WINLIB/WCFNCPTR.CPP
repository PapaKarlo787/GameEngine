/*------------------------------------------------------------------------
 * filename - wcfncptr.cpp
 *-----------------------------------------------------------------------*/

/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     C/C++ Run Time Library - Version 4.0                     |*/
/*|                                                              |*/
/*|                                                              |*/
/*|     Copyright (c) 1991 by Borland International              |*/
/*|     All Rights Reserved.                                     |*/
/*|                                                              |*/
/*[]------------------------------------------------------------[]*/

#include <windows.h>

WORD  (*__ReadBufFPtr)(char *Buffer, WORD Count) = 0;
void  (*__WriteBufFPtr)(char *Buffer, WORD Count)= 0;
