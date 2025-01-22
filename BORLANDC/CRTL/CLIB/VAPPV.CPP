/*-----------------------------------------------------------------------*
 * filename - vappv.cpp
 * C++ VECTOR APPLY for virtual base classes
 * This is called internally by the compiler to copy
 * arrays of classes having assignment operators or ref constructors
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

#include <stdarg.h>
#include <stddef.h>

typedef void (near * appNNC)(void near*, int, void near*);
typedef void (near * appNFC)(void far*, int, void far*);
typedef void pascal (near * appNNP)(void near*, int, void near*);
typedef void pascal (near * appNFP)(void far*, int, void far*);
typedef void (far * appFNC)(void near*, int, void near*);
typedef void (far * appFFC)(void far*, int, void far*);
typedef void pascal (far * appFNP)(void near*, int, void near*);
typedef void pascal (far * appFFP)(void far*, int, void far*);

extern "C"
void  _vector_applyv_(void far * dest,  // address of destination array
                      void far * src,   // address of source array
                      size_t size,      // size of each object
                      unsigned count,   // number of objects
                      unsigned mode,    // type of function to call
                      ...
                     )

/* This routine is used to copy an array of class type.

   Since the routine used for the class may be of either memory model, and
   take arguments of any memory model, we are forced to pass a mode
   parameter to tell us how to cast it.  Since we must pass a near pointer
   for near functions and a far call for far functions, we can't even know
   the argument type until runtime, so we have to use varargs to get at it.
   We do assume that both source and destination have the same distance
   modifier, and the compiler enforces that.

   The interpretation of the mode parameter is:
        far function            0x01
        pascal call             0x02
        far pointer             0x04
*/
{
    va_list ap;         /* for access to parameters */
    appNNC np;          /* Near pointer version */
    appFNC fp;          /* Far pointer version */

    va_start(ap, mode);

    if (mode & 1)
        fp = va_arg(ap, appFNC);
    else
        np = va_arg(ap, appNNC);

    do {
        switch (mode) {
          case 0: np((void near *)dest, 0, (void near *)src); break;
          case 1: fp((void near *)dest, 0, (void near *)src); break;
          case 2: (*(appNNP) np)((void near *)dest, 0, (void near *)src); break;
          case 3: (*(appFNP) fp)((void near *)dest, 0, (void near *)src); break;
          case 4: (*(appNFC) np)((void far  *)dest, 0, (void far  *)src); break;
          case 5: (*(appFFC) fp)((void far  *)dest, 0, (void far  *)src); break;
          case 6: (*(appNFP) np)((void far  *)dest, 0, (void far  *)src); break;
          default:(*(appFFP) fp)((void far  *)dest, 0, (void far  *)src); break;
        }
        (char far *) dest += size;
        (char far *) src += size;
    } while (--count > 0);
}
