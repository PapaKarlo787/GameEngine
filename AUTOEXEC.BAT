@echo off
cls
keyrus
path=c:\nc;c:\nu;c:\util;c:\bp\bin;c:\ng;c:\borlandc\bin
reschar /i
rem  ―®€ͺ«ξη ₯¬ NTFS
cd ntfs
lh hdpmi32
lh ndos -lfn -cp:866 -mountall %1 %2 %3 %4 %5 %6
drvlist
cd ..
ng
nc
