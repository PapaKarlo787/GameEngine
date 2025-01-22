rem
rem ObjectWindows - (C) Copyright 1991 by Borland International
rem
rem Build OWL
rem
cd source
rem
rem build static link libraries
rem
make -DMODEL=s
make -DMODEL=m
make -DMODEL=c
make -DMODEL=l
rem
rem build DLL
rem
make -DDLL
cd ..
