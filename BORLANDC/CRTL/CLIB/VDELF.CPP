/*-----------------------------------------------------------------------*
 * filename - vdel.cpp
 * C++ vector_delete
 * Called internally by the compiler to deallocate arrays of classes
 * having destructors
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

#include <stdlib.h>
#include <stdarg.h>
#include <dos.h>

typedef void (near * destNNC)(void near*, int);
typedef void (near * destNFC)(void far*, int);
typedef void pascal (near * destNNP)(void near*, int);
typedef void pascal (near * destNFP)(void far*, int);
typedef void (far * destFNC)(void near*, int);
typedef void (far * destFFC)(void far*, int);
typedef void pascal (far * destFNP)(void near*, int);
typedef void pascal (far * destFFP)(void far*, int);

#pragma option -O-m                     // Temporary correction

void _vector_delete_(void far *ptr,     // address of array (always needed)
             size_t size,               // size of each object
             unsigned long count,       // how many objects
             unsigned mode,             // How to call
             ...
            )
/* This routine is used to destroy an array of class type.  If mode is 
   set, it deallocates the space for the array afterwards. Since the
   destructor for the class may be of either memory model, and take
   an argument of any memory model, we are forced to pass a mode parameter
   to tell us how to cast it.  Since we must pass a near pointer for near
   functions and a far pointer for far functions, we can't even know the
   argument type until runtime, so we have to use varargs to get at it.

   If the destructor pointer is NULL no destructors are called.

   The interpretation of the mode parameter is:
       far function    0x01
       pascal call     0x02
       far pointer     0x04
       deallocate      0x08
       stored count    0x10
       stored size     0x20
       huge vector     0x40
*/
{
    va_list ap;         // for access to parameters   
    destNNC np;         // near pointer version    
    destFNC fp;         // far pointer version    
    int destruct = 1;   // flag whether to call destructors
    
    if (!ptr)
        return;

    va_start(ap, mode);

    if (mode & 0x01)
        {
        fp = va_arg(ap, destFNC);
        if (!fp)
            destruct = 0;
        }
    else
        {
        np = va_arg(ap, destNNC);
        if (!np)
            destruct = 0;
        }

    if (mode & 0x20)            // if stored size
        size = *((unsigned far *) 
                ((char far *)ptr - sizeof(count) - sizeof(size)));
            
    if (mode & 0x10)            // if stored count
        count = *((unsigned long far *) ((char far *)ptr - sizeof(count)));

    if (destruct)
        {
        // get call type
        unsigned CallType = mode & 0x07;

        for( char huge *p = (char huge *) ptr + size * (count - 1);
             count-- > 0; p -= size )
            {
            switch (CallType) 
                {
                case 4: (*(destNFC) np)((void far  *) p, 2); break;
                case 5: (*(destFFC) fp)((void far  *) p, 2); break;
                case 6: (*(destNFP) np)((void far  *) p, 2); break;
                case 7: (*(destFFP) fp)((void far  *) p, 2); break;
                default: abort(); break;
                }
            }
        }
    
    if (mode & 0x08) 
        {
        unsigned Header;
        unsigned Overhead = 0;
       
        if (mode & 0x10)        // stored count
            Overhead = sizeof(count);

        if (mode & 0x20)        // stored size
            Overhead += sizeof(size);
        
        if (mode & 0x40)        // huge vector
            {
            Overhead += sizeof(Header);
            Header = *((char far *)ptr - Overhead);
            ptr = MK_FP(FP_SEG(ptr), Header);
            }
        else
            ptr = (char far *)ptr - Overhead;

        operator delete((void far *)ptr);
        }
}
