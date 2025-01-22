/*------------------------------------------------------------------------
 * filename - suballoc.cpp
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

#if !defined(__DLL__)
struct far TSubAllocClientData
{
        void far *MemBlockPtr;
        int MemBlockCount;
};

extern "C"
{
        extern TSubAllocClientData far * far GetSubAllocClientData();
}

TSubAllocClientData SubAllocClientData;

TSubAllocClientData far * far GetSubAllocClientData()
{
    return &SubAllocClientData;
}
#endif // !__DLL__
