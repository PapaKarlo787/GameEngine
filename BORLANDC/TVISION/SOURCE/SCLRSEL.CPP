/*------------------------------------------------------------*/
/* filename -       sclrsel.cpp                               */
/*                                                            */
/* Registeration objects for the following classes:           */
/*                      TColorSelector                        */
/*                      TMonoSelector                         */
/*                      TColorDisplay                         */
/*                      TColorGroupList                       */
/*                      TColorItemList                        */
/*                      TColorDialog                          */
/*------------------------------------------------------------*/
                                                              
/*------------------------------------------------------------*/
/*                                                            */
/*    Turbo Vision -  Version 1.0                             */
/*                                                            */
/*                                                            */
/*    Copyright (c) 1991 by Borland International             */
/*    All Rights Reserved.                                    */
/*                                                            */
/*------------------------------------------------------------*/

#define Uses_TColorSelector
#define Uses_TMonoSelector
#define Uses_TColorDisplay
#define Uses_TColorGroupList
#define Uses_TColorItemList
#define Uses_TColorDialog
#define Uses_TStreamableClass
#include <tv.h>
__link( RView )
__link( RLabel )
__link( RButton )
__link( RListViewer )
__link( RDialog )

TStreamableClass RColorSelector( TColorSelector::name,
                                 TColorSelector::build,
                                 __DELTA(TColorSelector)      
                               );

TStreamableClass RMonoSelector( TMonoSelector::name,
                                TMonoSelector::build,
                                __DELTA(TMonoSelector)
                              );

TStreamableClass RColorDisplay( TColorDisplay::name,
                                TColorDisplay::build,
                                __DELTA(TColorDisplay)
                              );

TStreamableClass RColorGroupList( TColorGroupList::name,
                                  TColorGroupList::build,
                                  __DELTA(TColorGroupList)                          
                                );


TStreamableClass RColorItemList( TColorItemList::name,
                                 TColorItemList::build,
                                 __DELTA(TColorItemList)
                               );

TStreamableClass RColorDialog( TColorDialog::name,
                               TColorDialog::build,
                               __DELTA(TColorDialog)
                             );

