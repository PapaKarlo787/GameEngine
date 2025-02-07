// ObjectWindows - (C) Copyright 1991 by Borland International

#ifndef __BGRPBOX_H
#define __BGRPBOX_H

#ifndef __GROUPBOX_H
#include <groupbox.h>
#endif

#pragma option -Vo-

_CLASSDEF(TBGroupBox)

/* --------------------------------------------------------
  TBGroupBox object
  -------------------------------------------------------- */
class _EXPORT TBGroupBox : public TGroupBox
{
public:
    TBGroupBox(PTWindowsObject AParent, int AnId, LPSTR AText, int X,
              int Y, int W, int H, PTModule AModule = NULL);
    TBGroupBox(PTWindowsObject AParent, int ResourceId,
	        PTModule AModule = NULL);

    static PTStreamable build();

protected:
    virtual LPSTR GetClassName()
	    {return "BORSHADE";}
    TBGroupBox(StreamableInit) : TGroupBox(streamableInit) {};

private:
    virtual const Pchar streamableName() const
        { return "TBGroupBox"; }
};

inline Ripstream operator >> ( Ripstream is, RTBGroupBox cl )
    { return is >> (RTStreamable )cl; }
inline Ripstream operator >> ( Ripstream is, RPTBGroupBox cl )
    { return is >> (RPvoid)cl; }

inline Ropstream operator << ( Ropstream os, RTBGroupBox cl )
    { return os << (RTStreamable )cl; }
inline Ropstream operator << ( Ropstream os, PTBGroupBox cl )
    { return os << (PTStreamable )cl; }
    
#pragma option -Vo.

#endif
