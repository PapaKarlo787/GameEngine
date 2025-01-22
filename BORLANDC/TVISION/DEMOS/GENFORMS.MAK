# /*------------------------------------------------------*/
# /*                                                      */
# /*   Turbo Vision 1.0                                   */
# /*   Turbo Vision Forms Demo                            */
# /*   Copyright (c) 1991 by Borland International        */
# /*                                                      */
# /*------------------------------------------------------*/
# /*                                                      */
# /*   This makefile generates two forms data files,      */
# /*   PHONENUM.TVF and PARTS.TVF. These can be loaded    */
# /*   and edited using TVFORMS.CPP.                      */
# /*   Type the following command on the command-line to  */
# /*   to generate the aforementioned data files:         */
# /*      make -fgenforms.mak                             */
# /*------------------------------------------------------*/

.autodepend
.swap

CC      = bcc
INCLUDE = ..\include;..\..\include
LIB     = ..\..\lib
MODEL   = l
TVLIB   = ..\lib\tv.lib
SRC     = genform.cpp
OBJS    = forms.obj datacoll.obj fields.obj listdlg.obj

.cpp.obj:
   $(CC) -c -m$(MODEL) -I$(INCLUDE) {$< }

all: phonenum.tvf parts.tvf

phonenum.tvf: $(SRC) $(OBJS) $(TVLIB)
   $(CC) -DPHONENUM -m$(MODEL) -I$(INCLUDE) -L$(LIB) @&&| 
$(SRC)
$(OBJS)
$(TVLIB)
|
   genform

parts.tvf: $(SRC) $(OBJS) $(TVLIB)
   $(CC) -DPARTS -m$(MODEL) -I$(INCLUDE) -L$(LIB) @&&| 
$(SRC)
$(OBJS)
$(TVLIB)
|
   genform
