// ObjectWindows - (C) Copyright 1991 by Borland International

#ifndef __INPUTDIA_H
#define __INPUTDIA_H

#ifndef __DIALOG_H
#include <dialog.h>
#endif

#pragma option -Vo-

_CLASSDEF(TInputDialog)

  /* TInputDialog */
class _EXPORT TInputDialog : public TDialog
{
public:
    LPSTR Prompt; 
    LPSTR Buffer;
    WORD BufferSize;

    TInputDialog(PTWindowsObject AParent, LPSTR ATitle,
              LPSTR APrompt, LPSTR ABuffer, WORD ABufferSize, 
              PTModule AModule = NULL);
    void TransferData(WORD Direction);

    static PTStreamable build();

protected:
    virtual void SetupWindow();
    TInputDialog(StreamableInit) : TDialog(streamableInit) {};
    virtual void write (Ropstream os);
    virtual Pvoid read (Ripstream is);

private:
    virtual const Pchar streamableName() const
        { return "TInputDialog"; }
};

inline Ripstream operator >> ( Ripstream is, RTInputDialog cl )
    { return is >> (RTStreamable )cl; }
inline Ripstream operator >> ( Ripstream is, RPTInputDialog cl )
    { return is >> (RPvoid)cl; }

inline Ropstream operator << ( Ropstream os, RTInputDialog cl )
    { return os << (RTStreamable )cl; }
inline Ropstream operator << ( Ropstream os, PTInputDialog cl )
    { return os << (PTStreamable )cl; }
    
#pragma option -Vo.

#endif
