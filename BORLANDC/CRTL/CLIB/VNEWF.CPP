/*-----------------------------------------------------------------------*
 * filename - vnew.cpp
 * C++ VECTOR_NEW
 * Called internally by the compiler to allocate arrays of classes
 *  having constructors
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

typedef void (near * constNNC)(void near*);
typedef void (near * constNFC)(void far*);
typedef void pascal (near * constNNP)(void near*);
typedef void pascal (near * constNFP)(void far*);
typedef void (far * constFNC)(void near*);
typedef void (far * constFFC)(void far*);
typedef void pascal (far * constFNP)(void near*);
typedef void pascal (far * constFFP)(void far*);

#pragma option -O-m                     // Temporary correction

void far * _vector_new_(void far *ptr,  // address of array, 0 means allocate
        size_t size,                    // size of each object
        unsigned long count,            // how many objects
        unsigned mode,                  // actual type of constructor
        ...
        )
/* This routine is used to initialize an array of class type.  If ptr is
   NULL, it allocates the space for the array first.  Since the constructor
   for the class may be of either memory model, and take an argument of any
   memory model, we are forced to pass a mode parameter to tell us how to
   cast it.  Since we must pass a near pointer for near functions and a
   far call for far functions, we can't even know the argument type until
   runtime, so we have to use varargs to get at it.

   If the constructor pointer is NULL no constructors are called.
       
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
    constNNC np;        // near pointer version 
    constFNC fp;        // far pointer version 
    int construct = 1;  // flag whether to call constructors

    va_start(ap, mode);

    if (mode & 0x01)
        {
        fp = va_arg(ap, constFNC);
        if (!fp)
            construct = 0;
        }
    else
        {
        np = va_arg(ap, constNNC);
        if (!np)
            construct = 0;
        }

    if (ptr == 0)               // should we allocate it?
        {
        unsigned Header;
        unsigned Overhead = 0;
        unsigned PadFromZero;
        
        if (mode & 0x10)        // stored count
            Overhead = sizeof(count);

        if (mode & 0x20)        // stored size
            Overhead += sizeof(size);
        
        if (mode & 0x40)        // huge vector
            {
            Overhead += sizeof(Header);
            ptr = operator new((unsigned long)count * size + Overhead + size);
            if (!ptr) 
                return 0;
            PadFromZero = (unsigned) (65536L % size);
            Header = FP_OFF(ptr);
            while (PadFromZero < Overhead + Header)
                PadFromZero += size;
                       
            (char far *)ptr += PadFromZero - Header - Overhead;
            *(unsigned far *)ptr = Header;
            ((unsigned far *)ptr)++;
            }
        else
            {
            // check that additional bytes don't make it go over 64K
            unsigned long Length = size * count + Overhead;
            if (Length > 0xFFFF)
                return 0;

            ptr = operator new((unsigned)Length);
            if (!ptr) 
                return 0;
            }

        // have ptr at either final location or count or count+size before

        if (mode & 0x20)    // if store size NOTE: count must also be true
            {
            *(unsigned far *)ptr = size;
            ((unsigned far *)ptr)++;
            }
        if (mode & 0x10)    // store count
            {
            *(unsigned long far *)ptr = count;
            ((unsigned long far *)ptr)++;
            }
        }

    mode &= 0x07;   // strip out all flags except call type

    if (construct)
        {
        for( char huge *p = (char huge *) ptr;  count-- > 0;  p += size )
            switch (mode) 
                {
                case 4: (*(constNFC) np)((void far *) p); break;
                case 5: (*(constFFC) fp)((void far *) p); break;
                case 6: (*(constNFP) np)((void far *) p); break;
                case 7: (*(constFFP) fp)((void far *) p); break;
                default: abort(); break;
                }
        }
    return ptr;
}
