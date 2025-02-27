// ObjectWindows - (C) Copyright 1991 by Borland International

#include <stdio.h>
#include <stdlib.h>
#include <dir.h>
#include <array.h>
#include <abstarry.h>
#include <string.h>
#include <owl.h>
#include <inputdia.h>
#include <filedial.h>
#include "steps.h"

class TMyApp : public TApplication
{
public:
  TMyApp(LPSTR AName, HANDLE hInstance, HANDLE hPrevInstance,
    LPSTR lpCmdLine, int nCmdShow)
    : TApplication(AName, hInstance, hPrevInstance, lpCmdLine, nCmdShow) {};
  virtual void InitMainWindow();
};

_CLASSDEF(TPoint)
class TPoint: public Object
{
public:
  int X, Y;
  TPoint(int AX, int AY) {X = AX, Y = AY;}
  virtual classType isA() const { return __firstUserClass; }
  virtual Pchar nameOf() const { return "TPoint"; }
  virtual hashValueType hashValue() const { return 0; } 
  virtual int isEqual(RCObject APoint) const
    { return X == ((RTPoint)APoint).X && Y == ((RTPoint)APoint).Y; }
  virtual void printOn(Rostream outputStream) const
    { outputStream << "(" << X << "," << Y << ")"; }
};

_CLASSDEF(TPointArray)
class TPointArray : public Array
{
public:
  TPointArray(int upper, int lower = 0, sizeType aDelta = 0)
    : Array(upper, lower, aDelta){};
  virtual classType isA() const { return __firstUserClass + 1; }
  virtual Pchar nameOf() const { return "TPointArray"; }
};

_CLASSDEF(TMyWindow)
class TMyWindow : public TWindow
{
public:
  HDC DragDC;
  BOOL ButtonDown;
  HPEN ThePen;
  int PenSize;
  PTPointArray Points;
  char FileName[MAXPATH];
  TMyWindow(PTWindowsObject AParent, LPSTR ATitle);
  ~TMyWindow();
  virtual BOOL CanClose();
  void SetPenSize(int NewSize);
  virtual void Paint(HDC DC, PAINTSTRUCT& PS);
  virtual void WMLButtonDown(RTMessage Msg)
    = [WM_FIRST + WM_LBUTTONDOWN];
  virtual void WMLButtonUp(RTMessage Msg)
    = [WM_FIRST + WM_LBUTTONUP];
  virtual void WMMouseMove(RTMessage Msg)
    = [WM_FIRST + WM_MOUSEMOVE];
  virtual void WMRButtonDown(RTMessage Msg)
    = [WM_FIRST + WM_RBUTTONDOWN];
  virtual void CMFileNew(RTMessage Msg)
    = [CM_FIRST + CM_FILENEW];
  virtual void CMFileOpen(RTMessage Msg)
    = [CM_FIRST + CM_FILEOPEN];
  virtual void CMFileSave(RTMessage Msg)
    = [CM_FIRST + CM_FILESAVE];
  virtual void CMFileSaveAs(RTMessage Msg)
    = [CM_FIRST + CM_FILESAVEAS];
  virtual void CMHelp(RTMessage Msg)
    = [CM_FIRST + CM_HELP];
};

TMyWindow::TMyWindow(PTWindowsObject AParent, LPSTR ATitle)
  : TWindow(AParent, ATitle)
{
  AssignMenu("COMMANDS");
  ButtonDown = FALSE;
  PenSize = 1;
  ThePen = CreatePen(PS_SOLID, PenSize, 0);
  Points = new TPointArray(50, 0, 50);
}

TMyWindow::~TMyWindow()
{
  delete Points;
  DeleteObject(ThePen);
}

void TMyWindow::SetPenSize(int NewSize)
{
  DeleteObject(ThePen);
  ThePen = CreatePen(PS_SOLID, NewSize, 0);
  PenSize = NewSize;
}

void TMyWindow::Paint(HDC DC, PAINTSTRUCT&)
{
  RArrayIterator PointIterator = (RArrayIterator)(Points->initIterator());
  BOOL First = TRUE;

  SelectObject(DC, ThePen);
  while ( int(PointIterator) != 0 )
  {
    RObject AnObject = PointIterator++;
    if ( AnObject != NOOBJECT )
    {
      if ( First )
      {
        MoveTo(DC, ((PTPoint)(&AnObject))->X, ((PTPoint)(&AnObject))->Y);
        First = FALSE;
      }
      else
        LineTo(DC, ((PTPoint)(&AnObject))->X, ((PTPoint)(&AnObject))->Y);
    }   
  }
  delete &PointIterator;
}

BOOL TMyWindow::CanClose()
{
  return MessageBox(HWindow, "Do you want to save?",
    "Drawing has changed", MB_YESNO | MB_ICONQUESTION) == IDNO;
}

void TMyWindow::WMLButtonDown(RTMessage Msg)
{
  Points->flush();
  InvalidateRect(HWindow, NULL, TRUE);
  if ( !ButtonDown )
  {
    ButtonDown = TRUE;
    SetCapture(HWindow);
    DragDC = GetDC(HWindow);
    SelectObject(DragDC, ThePen);
    MoveTo(DragDC, Msg.LP.Lo, Msg.LP.Hi);
    Points->add(* (new TPoint(Msg.LP.Lo, Msg.LP.Hi)));
  }
}

void TMyWindow::WMMouseMove(RTMessage Msg)
{
  if ( ButtonDown )
  {
    LineTo(DragDC, Msg.LP.Lo, Msg.LP.Hi);
    Points->add(* (new TPoint(Msg.LP.Lo, Msg.LP.Hi)));
  }
}

void TMyWindow::WMLButtonUp(RTMessage)
{
  if ( ButtonDown )
  {
    ButtonDown = FALSE;
    ReleaseCapture();
    ReleaseDC(HWindow, DragDC);
  }
}

void TMyWindow::WMRButtonDown(RTMessage)
{
  char InputText[6];
  int NewPenSize;

  sprintf(InputText, "%d", PenSize);
  if ( GetApplication()->ExecDialog(new TInputDialog(this, "Line Thickness",
    "Input a new thickness:", InputText, sizeof InputText)) == IDOK )
  {
      NewPenSize = atoi(InputText);
      if ( NewPenSize < 0 )
        NewPenSize = 1;
      SetPenSize(NewPenSize);
  }
}

void TMyWindow::CMFileNew(RTMessage)
{ 
  Points->flush();
  InvalidateRect(HWindow, NULL, TRUE);
}

void TMyWindow::CMFileOpen(RTMessage)
{ 
  if ( GetApplication()->ExecDialog(new TFileDialog(this, SD_FILEOPEN,
    strcpy(FileName, "*.PTS"))) == IDOK )
     MessageBox(HWindow, FileName, "Open the file:", MB_OK);
}

void TMyWindow::CMFileSave(RTMessage)
{ 
  MessageBox(HWindow, "Feature not implemented", "File Save", MB_OK);
}

void TMyWindow::CMFileSaveAs(RTMessage)
{ 
  if ( GetApplication()->ExecDialog(new TFileDialog(this, SD_FILESAVE,
    FileName)) == IDOK )
      MessageBox(HWindow, FileName, "Save the file:", MB_OK);
}

void TMyWindow::CMHelp(RTMessage)
{ 
  PTWindow HelpWindow;
  
  HelpWindow = new TWindow(this, "Help System");
  HelpWindow->Attr.Style |= WS_POPUPWINDOW | WS_CAPTION;
  HelpWindow->Attr.X = 100;
  HelpWindow->Attr.Y = 100;
  HelpWindow->Attr.W = 300;
  HelpWindow->Attr.H = 300;
  GetApplication()->MakeWindow(HelpWindow);
}

void TMyApp::InitMainWindow()
{
  MainWindow = new TMyWindow(NULL, Name);
}

int PASCAL WinMain(HANDLE hInstance, HANDLE hPrevInstance,
  LPSTR lpCmdLine, int nCmdShow)
{
  TMyApp MyApp("Sample ObjectWindows Program", hInstance, hPrevInstance,
               lpCmdLine, nCmdShow);
  MyApp.Run();
  return MyApp.Status;
}
