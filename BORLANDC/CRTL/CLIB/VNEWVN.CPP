/*-----------------------------------------------------------------------*
 * filename - vnewv.cpp
 * C++ VECTOR_NEW for virtual base classes.
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

typedef void (near * consvNNC)(void near*, int);
typedef void (near * consvNFC)(void far*, int);
typedef void pascal (near * consvNNP)(void near*, int);
typedef void pascal (near * consvNFP)(void far*, int);
typedef void (far * consvFNC)(void near*, int);
typedef void (far * consvFFC)(void far*, int);
typedef void pascal (far * consvFNP)(void near*, int);
typedef void pascal (far * consvFFP)(void far*, int);

#pragma argsused

void near * _vector_vnew_(void near *ptr, // address of array, 0 means allocate 
                 size_t size,             // size of each object
                 unsigned count,          // how many objects
                 unsigned mode,           // actual type of constructor
                 ...
                 )
/* This routine is used to initialize an array of class type.  If ptr is
   NULL, it allocates the space for the array first.  Since the constructor
   for the class may be of either memory model, and take an argument of any
   memory model, we are forced to pass a mode parameter to tell us how to
   cast it.  Since we must pass a near pointer for near functions and a
   far call for far functions, we can't even know the argument type until
   runtime, so we have to use varargs to get at it.  This version passes the
   second argument needed for a class with virtual bases.

   If the constructor pointer is NULL no constructors are called.

   The interpretation of the mode parameter is:
       far function    0x01
       pascal call     0x02
       far pointer     0x04
       deallocate      0x08
       stored count    0x10
       stored size     0x20
*/
{
#if defined(__LARGE__) || defined(__HUGE__) || defined(__COMPACT__)
    abort();
    return 0;
#else
    va_list ap;         // for access to parameters 
    consvNNC np;        // near pointer version 
    consvFNC fp;        // far pointer version 
    int construct = 1;  // flag whether to call constructors

    va_start(ap, mode);

    if (mode & 0x01)
        {
        fp = va_arg(ap, consvFNC);
        if (!fp)
            construct = 0;
        }
    else
        {
        np = va_arg(ap, consvNNC);
        if (!np)
            construct = 0;
        }

    if( ptr == 0 ) 
        {
        unsigned Overhead = 0;
        
        if (mode & 0x10)        // stored count
            Overhead = sizeof(count);

        if (mode & 0x20)        // stored size
            Overhead += sizeof(size);

        // check that additional bytes don't make it go over 64K
        unsigned long Length = size * count + Overhead;
        if (Length > 0xFFFF)
            return 0;

        ptr = operator new((unsigned)Length);

        if (!ptr) 
            return 0;
        
        // have ptr at either final location or count or count+size before

        if (mode & 0x20)    // if store size NOTE: count must also be true
            {
            *(unsigned *)ptr = size;
            ((unsigned *)ptr)++;
            }
        if (mode & 0x10)    // store count
            {
            *(unsigned *)ptr = count;
            ((unsigned *)ptr)++;
            }
        }   

    mode &= 0x07;   // strip out all flags except call type

    if (construct)
        {
        for( char *p = (char *) ptr;  count-- > 0;  p += size )
            switch (mode) 
                {
                case 0: np((void near *) p, 0); break;
                case 1: fp((void near *) p, 0); break;
                case 2: (*(consvNNP) np)((void near *) p, 0); break;
                case 3: (*(consvFNP) fp)((void near *) p, 0); break;
                default: abort(); break;
                }
        }
    return ptr;
#endif
}
