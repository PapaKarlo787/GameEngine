@echo off
rem �த������� ��⠭����

if -%1 == - goto end
if -%2 == -flop goto license
if -%1 == -flop if -%2 == -  ~ # flop r
if -%1 == -flop if -%2 == -e ~ # flop e
if -%1 == -flop if -%2 == -E ~ # flop e

cls
echo *****************************************************************************
echo.
if -%3 == -e goto e_message
if -%4 == -n echo ������ ��⠭���� ��⥬� �������� 1.3.
if -%4 == -u echo ��⠭���� ��⥬� �������� 1.3 (ᬥ�� ���ᨨ, ����������).
echo.
echo ��� ��⠭���� �᭮����� 䠩�� ����室�� ��� ॣ����樮��� ����� ���ᨨ 1.2.
echo ��� �롮� �������� ��࠭��� ���⮢ ����������� 㪠���� ⨯ �����������
echo (CGA, EGA, VGA). �᫨ �� �� ����� ⨯ ������, ��⠭���� �� �����.
echo.
echo ��� ��⠭���� ���⮢ � �ࠩ��஢ ���� ����������� 㪠���� ⨯ �ਭ��:
echo     9-������, ᮢ���⨬� � EPSON;
echo     24-������ ��� ���㩭�, ᮢ���⨬� � EPSON ��� IBM PROPRINTER;
echo     ������, ᮢ���⨬� � �� Laser Jet;
echo     ���㩭�, ᮢ���⨬� � HP Desk Jet.
echo ����� ��⠭����� ����� � �ࠩ���� ��� �ਭ�஢ ��᪮�쪨� ⨯��.
echo.
echo ����㯨�� � ��⠭����?
goto ask_start

:e_message
if -%4 == -n echo Installing LEXICON 1.3 for the first time.
if -%4 == -u echo Installing LEXICON 1.3 (a new version, additional files).
echo.
echo To install the main file, you'll need your serial number for version 1.2.   .
echo To choose a set of screen fonts, you'll need to know your videoadapter type
echo (CGA, EGA, VGA). If you don't know which type is yours, install all fonts.
echo.
echo To install fonts and printer drivers, you'll need to know your printer type:
echo     9-pin, EPSON compatible;
echo     24-pin/jet, EPSON / IBM PROPRINTER compatible;
echo     laser, �� Laser Jet compatible;
echo     jet, HP Desk Jet compatible.
echo You can install fonts and drivers for printers of more than one type.
echo.
echo Do you want to start installation?

:ask_start
echo.
if -%3 == -r ask "(��-1, ��室-ESC) -?",1
if -%3 == -e ask "(Yes-1, Exit-ESC) -?",1
if errorlevel 2 goto end

askspace 1000000
if errorlevel 1 goto no_memory

echo.
if -%3 == -e echo YES
if -%3 == -r echo ��
verify on
md temp13 > nul
if exist printer.lex del printer.lex

echo.
echo **************************************************
if -%3 == -r echo ��⠭�������� �᭮��� 䠩�� ��������� ?
if -%3 == -e echo Do you want to install the LEXICON main files ?
if -%3 == -r ask "(��-1, ���-0, ��室-ESC) -?",10
if -%3 == -e ask "(Yes-1, No-0, Exit-ESC) -?",10
if errorlevel 3 goto exit
if errorlevel 2 goto cga

if -%3 == -r echo ��. �����㥬 䠩��...
if -%3 == -e echo YES. Writing files...
copy %1\read.me > nul
copy %1\*.doc   > nul

cd temp13
%1\lexfiles\main
copy *.exe ..  > nul
copy h*.lex .. > nul
if not exist ..\keymacro.lex copy keymacro.lex .. > nul
del *.exe
del *.lex
cd..

:license
cls
echo ******************************************************
echo.
if -%3 == -r echo ��������, �믮���� ������ �����
if -%3 == -r echo ࠡ�祩 ��業������� ����� ��������� 1.3.
if -%3 == -r echo �ᯮ���� ��� ॣ����樮��� ����� ��� ���ᨨ 1.2.
if -%3 == -r echo ��� �த������� ������ ���� �������.
if -%3 == -e echo Please, perform the procedure of creating
if -%3 == -e echo the licensed working copy.
if -%3 == -e echo Use Your LEXICON 1.2 license number.
if -%3 == -e echo Press any key to continue.
pause > nul

:set_num
lexicon -~%%In$tall#D
if errorlevel 1 goto bad_num
if -%3 == -r echo ���� ����� �ࠢ����, LEXICON.EXE ��⠭�����.
if -%3 == -r echo ��� �த������� ������ ���� �������.
if -%3 == -e echo Serial number is true, LEXICON.EXE is installed.
if -%3 == -e echo Press any key to continue.
pause > nul
if -%2 == -flop goto end
goto cga

:bad_num
echo.
if -%3 == -r echo ����୮� ���祭��!
if -%3 == -e echo Sorry, wrong number!
echo.
if -%3 == -r ask "(�������-1, ��室-ESC) -?",1
if -%3 == -e ask "(Retry-1, Exit-ESC) -?",1
if errorlevel 2 goto exit
goto set_num

:cga
   cls
   echo **********************************************
   if -%3 == -r echo ��⠭�������� ��࠭�� ����� ��� CGA ?
   if -%3 == -e echo Do you want to install CGA screen fonts ?
   if -%3 == -r ask "(��-1, ���-0, ��室-ESC) -?",10
   if -%3 == -e ask "(Yes-1, No-0, Exit-ESC) -?",10
   if errorlevel 3 goto exit
   if errorlevel 2 goto ega
   if -%3 == -e echo ��⠭�������� ��࠭�� ����� CGA.
   if -%3 == -e echo Installiig CGA screen fonts.
   if exist cga?.sfn del cga?.sfn
   %1\lexfiles\fn_cga

:ega
   cls
                echo ***********************************************
   if -%3 == -r echo ��⠭�������� ��࠭�� ����� ��� EGA/HERCULES ?
   if -%3 == -e echo Do you want to install EGA/HERCULES screen fonts ?
   if -%3 == -r ask "(��-1, ���-0, ��室-ESC) -?",10
   if -%3 == -e ask "(Yes-1, No-0, Exit-ESC) -?",10
   if errorlevel 3 goto exit
   if errorlevel 2 goto vga
   if -%3 == -e echo ��⠭�������� ��࠭�� ����� EGA/HERCULES.
   if -%3 == -e echo Installing EGA/HERCULES screen fonts.
   if exist ega?.sfn del ega?.sfn
   %1\lexfiles\fn_ega

:vga
   cls
echo **********************************************
   if -%3 == -r echo ��⠭�������� ��࠭�� ����� ��� VGA/SVGA ?
   if -%3 == -e echo Do you want to install VGA/SVGA screen fonts ?
   if -%3 == -r ask "(��-1, ���-0, ��室-ESC) -?",10
   if -%3 == -e ask "(Yes-1, No-0, Exit-ESC) -?",10
   if errorlevel 3 goto exit
   if errorlevel 2 goto prn9
   if -%3 == -e echo ��⠭�������� ��࠭�� ����� VGA/SVGA.
   if -%3 == -e echo Installing VGA/SVGA screen fonts.
   if exist vga?.sfn del vga?.sfn
   %1\lexfiles\fn_vga

rem  ����� �ਭ�஢
:prn9
   cls
   echo ***********************************************************************
   if -%3 == -r echo ��⠭�������� ����� � �ࠩ���� 9-�������  �ਭ�஢ (1.3 M�)?
   if -%3 == -e echo Do you want to install fonts and drivers for 9-pin printers (1.3 Mb)?
   if -%3 == -r ask "(��-1, ���-0, ��室-ESC) -?",10
   if -%3 == -e ask "(Yes-1, No-0, Exit-ESC) -?",10
   if errorlevel 3 goto exit
   if errorlevel 2 goto prn24
   if -%3 == -r echo ��
   if -%3 == -e echo YES
   askspace 1300000
   if errorlevel 1 goto no_memory
   if -%2 == -\fonts\ goto set13_9

:d35_21
   echo *********************************************************************
   echo.
   if -%3 == -r echo   ��⠢�� ��� ������ 9/24 �������� 1.3 � ������ ���� �������.
   if -%3 == -e echo   Insert the FONTS 9/24 disk of LEXICON v.1.3 and press any key.
   pause > nul
   if exist %1pr_9.exe  goto set13_9
   echo 
   echo.
   if -%3 == -r echo   �� �� ���! ��������, ���� ��� ������ 9/24!
   if -%3 == -e echo   Sorry, wrong disk! Insert FONTS 9/24 disk, please!
   goto d35_21

:set13_9
   cd temp13
   %1%2pr_9
   copy *.* .. > nul
   del *.fn9
   del *.pdr
   cd ..
   if exist hm_?.fn9 del hm_?.fn9
   if exist lq9p.pdr del lq9p.pdr
   if exist dr*.f* goto prn24

rem ��⠭���� ���⮢ �������� 1.2
:d25_21
echo ******************************************************************************
   echo.
   if -%3 == -r echo ��⠢�� ��� ���⮢ ��������� 1.2 (5.25"-N2, 3.5"-N1), ������ ���� �������.
   if -%3 == -e echo Insert the FONTS disk of LEXICON 1.2 (5.25"-N2, 3.5"-N1), press any key.
   pause > nul
   if exist %1%2prn_9.exe goto set12_9
   echo 
   echo.
   if -%3 == -r echo   �� �� ���! ��������, ���� ��� ���⮢!
   if -%3 == -e echo   Sorry, wrong disk! Insert the FONTS disk, please!
   goto d25_21

:set12_9
   cd temp13
   %1%2prn_9
   %1%2prn_dr
   copy mq*.fn9 .. > nul
   copy dr*.fn9 .. > nul
   copy tw_4.fn9 .. > nul
   copy tw_5.fn9 .. > nul
   copy tw_8.fn9 .. > nul
   copy tw_9.fn9 .. > nul
   copy tw_a.fn9 .. > nul
   copy tw_b.fn9 .. > nul
   del *.f*
   del *.pdr
   cd ..

:prn24
   if not exist printer.lex copy lq9m.pdr printer.lex > nul
   cls
   echo ************************************************************************
   if -%3 == -r echo ��⠭�������� ����� � �ࠩ���� 24-������� �ਭ�஢ (1.4 ��)?
   if -%3 == -e echo Do you want to install fonts and drivers for 24-pin printers (1.4 Mb)?
   if -%3 == -r ask "(��-1, ���-0, ��室-ESC) -?",10
   if -%3 == -e ask "(Yes-1, No-0, Exit-ESC) -?",10
   if errorlevel 3 goto exit
   if errorlevel 2 goto pcx
   if -%3 == -r echo ��
   if -%3 == -e echo YES
   askspace 1400000
   if errorlevel 1 goto no_memory
   if exist %1%2pr_24.exe goto set13_24

:d35_22
   echo ******************************************************************
   echo.
   if -%3 == -r echo   ��⠢�� ��� ������ 9/24 �������� 1.3 � ������ ���� �������.
   if -%3 == -e echo   Insert the FONTS 9/24 disk of LEXICON v.1.3 and press any key.
   pause > nul
   if exist %1%2pr_24.exe  goto set13_24
   echo 
   echo.
   if -%3 == -r echo   �� �� ���! ��������, ���� ��� ������ 9/24!
   if -%3 == -e echo   Sorry, wrong disk! Insert disk FONTS 9/24, please!
   goto d35_22

:set13_24
   cd temp13
   %1%2pr_24
   copy *.* .. > nul
   del *.f*
   del *.pdr
   cd ..
   if exist hm_?.fn2 del hm_?.fn2
   if exist lq24p*.pdr del lq24p*.pdr
   if exist dr*.f* goto pcx

rem ��⠭���� ���⮢ �������� 1.2
:d25_22
echo ******************************************************************************
   echo.
   if -%3 == -r echo ��⠢�� ��� ���⮢ ��������� 1.2 (5.25"-N2, 3.5"-N1), ������ ���� �������.
   if -%3 == -e echo Insert the FONTS disk of LEXICON v.1.2 (5.25"-N2, 3.5"-N1), press any key.
   pause > nul
   if exist %1%2prn_24.exe goto set12_24
   echo 
   echo.
   if -%3 == -r echo   �� �� ���! ��������, ���� ��� ���⮢!
   if -%3 == -e echo   Sorry, wrong disk! Insert the FONTS disk, please!
   goto d25_22

:set12_24
   cd temp13
   %1%2prn_dr
   copy dr*.f* .. > nul
   del *.f*
   del *.pdr
   cd ..

:pcx
   if not exist printer.lex copy lq24m.pdr printer.lex > nul
   cls
   echo ***************************************************************
   if -%3 == -r echo ��⠭�������� ����� ����᪨� ���⨭�� (400 �)?
   if -%3 == -e echo Do you want to install set of graphic pictures (400 K)?
   if -%3 == -r ask "(��-1, ���-0, ��室-ESC) -?",10
   if -%3 == -e ask "(Yes-1, No-0, Exit-ESC) -?",10
   if errorlevel 3 goto exit
   if errorlevel 2 goto prnlj
   if -%3 == -r echo ��
   if -%3 == -e echo YES
   askspace 400000
   if errorlevel 1 goto no_memory
   if exist %1%2pcx.exe goto set_pcx

:d35_3
   echo ********************************************************
   echo.
   if -%3 == -r echo   ��⠢�� ��� ������� �������� 1.3 � ������ ���� �������.
   if -%3 == -e echo   Insert the PICTURES disk of LEXICON v.1.3 and press any key.
   pause > nul
   if exist %1%2pcx.exe  goto set_pcx
   echo 
   echo.
   if -%3 == -r echo   �� �� ���! ��������, ���� ��� ������� !
   if -%3 == -e echo   Sorry, wrong disk! Insert the PICTURES disk, please!
   goto d35_3

:set_pcx
   md pcx
   cd pcx
   %1%2pcx
   cd..

:prnlj
   cls
   echo *************************************************************************
   if -%3 == -r echo ��⠭�������� ����� � �ࠩ���� ������� �ਭ�஢ (400 ��)?
   if -%3 == -e echo Do you want to install fonts and drivers for Laser Jet printers (400 Kb)?
   if -%3 == -r ask "(��-1, ���-0, ��室-ESC) -?",10
   if -%3 == -e ask "(Yes-1, No-0, Exit-ESC) -?",10
   if errorlevel 3 goto exit
   if errorlevel 2 goto prndj
   if -%3 == -r echo ��
   if -%3 == -e echo YES
   askspace 400000
   if errorlevel 1 goto no_memory
   if exist %1%2pr_lj.exe goto set13_lj

:d35_4
   echo ********************************************************
   echo.
   if -%3 == -r echo   ��⠢�� ��� ������ LJ �������� 1.3 � ������ ���� �������.
   if -%3 == -e echo   Insert the FONTS LJ disk of LEXICON v.1.3 and press any key.
   pause > nul
   if exist %1%2pr_lj.exe  goto set13_lj
   echo 
   echo.
   if -%3 == -r echo   �� �� ���! ��������, ���� ��� ������ LJ!
   if -%3 == -e echo   Sorry, wrong disk! Insert the FONTS LJ disk, please!
   goto d35_4

:set13_lj
   md fonts_lj
   cd fonts_lj
   %1%2pr_lj
   copy load*.bat .. > nul
   copy *.pdr ..     > nul
   del load*.bat
   del *.pdr
   copy %1%2lj*.exe > nul
   cd ..

rem �᫨ ��� ������� ���⮢ ���ᨨ 1.2, ����� ����� �� �� 㤠�����.
if not exist *.bin goto prndj
cls
echo.
echo ******************************************************************************
echo.
if -%3 == -e goto ljtxt_e
echo     �������� �������� - ������� ������ �� �������� ��������� ������� !
echo.
echo � �裡 � 㢥��祭��� ����� ���⮢ �ࠩ���� ������� �ਭ�஢ ��������� 1.3
echo            ������� ������ � �������� ������� ����� ������� ������
echo (��� "�⥢�" �ࠩ���� ���ᨨ 1.2). ��� ⠪�� ����㧪� ��뢠�� LOAD.BAT
echo.
echo �� ��襬� �롮��  �ࠩ���� � ����� ���ᨨ 1.2 ����� ���� ��� 㤠����,
echo ��� ��⠢���� � ��⠫��� ���������, �⮡� ࠡ���� � ���� ��-��஬�.
echo.
echo ������� �०��� �ࠩ���� � ����� ?
goto askdelj

:ljtxt_e
echo     ATTENTION! PROCEDURE OF PRINTING ON LASER PRINTERS IS CHANGED!
echo.
echo Since number of fonts is now greater, the laser printer drivers of
echo LEXICON 1.3 require TO CHOOSE AND LOAD FONTS BEFORE STRARTING LEXICON
echo (like "net" drivers of version 1.2). To load fonts, run LOAD.BAT.
echo.
echo You can choose either to remove drivers and fonts of version 1.2 / to
echo retain them in LEXICON's directory so that you can work with them as before.
echo.
echo Do you want to remove old drivers and fonts ?

:askdelj
   if -%3 == -r ask "(��-1, ���-0) -?",10
   if -%3 == -e ask "(Yes-1, No-0) -?",10
   if errorlevel 2 goto prndj
   del *.bin
   del lj*.pdr
   del load_lj.bat

:prndj
   if not exist printer.lex copy 3ljm.pdr printer.lex > nul
   cls
   echo **********************************************************************
   if -%3 == -r echo ��⠭�������� ����� � �ࠩ���� �ਭ�஢ Desk Jet (2.5 M�)?
   if -%3 == -e echo Do you want to install fonts and drivers for Desk Jet printers (2.5 Mb)?
   if -%3 == -r ask "(��-1, ���-0, ��室-ESC) -?",10
   if -%3 == -e ask "(Yes-1, No-0, Exit-ESC) -?",10
   if errorlevel 3 goto exit
   if errorlevel 2 goto utils
   if -%3 == -r echo ��
   if -%3 == -e echo YES
   askspace 2500000
   if errorlevel 1 goto no_memory
   if exist %1%2pr_dj.exe goto set_dj

:d35_5
   echo ***************************************************************************
   echo.
   if -%3 == -r echo   ��⠢�� ��� ������ DJ / ������� �������� 1.3 � ������ ���� �������.
   if -%3 == -e echo   Insert the FONTS DJ / UTILS disk of LEXICON v.1.3 and press any key.
   pause > nul
   if exist %1%2pr_dj.exe  goto set_dj
   echo 
   echo.
   if -%3 == -r echo   �� �� ���! ��������, ���� ��� ������ DJ / �������!
   if -%3 == -e echo   Sorry, wrong disk! Insert the FONTS DJ / UTILS disk, please!
   goto d35_5

:set_dj
   %1%2pr_dj

:utils
if not exist printer.lex copy djm.pdr printer.lex > nul
cls
echo *******************************************************************
echo.
if -%3 == -e goto e_utils
echo  ��⠭�������� �������⥫�� 䠩�� � �⨫���?
echo  - 䠩�� ����㦠���� ����䥩��� ᮮ�饭�� ENGLISH.LIN � RUSSIAN.LIN;
echo  - �ࠩ���� ����������:
echo      EURORUS.KDR   - ��� ࠡ��� �� ����檮�, �࠭��᪮� �
echo                      ��㣨� �����ন������ ��� ��ய��᪨� �몠�;
echo      TYPIST.KDR    - ������ ���������� ����饩 ��設��;
echo      ISKRA.KDR     - �ࠩ��� ��� ���� ����� 1030.11;
echo      ES1841/2.KDR  - �ࠩ���� ��� ���� ��1841/2;
echo  - ���ப������ UNDO.MAC ��� ॠ����樨 �⪠� �� ��������� ����� XT;
echo  - �ணࠬ�� ��४���஢�� ⥪�⮢�� 䠩��� RUSCOD;
echo  - ��������� ⥪�⮢�� 䠩��� ��������� LEXVENT, LEXWPTF;
echo  - �ணࠬ�� ��� ���襭�� ����⢠ ���� �� �拉 9-������� �ਭ�஢.
goto ask_utils

:e_utils
echo  Do you want to install additional files and utilities?
echo  - loadable interface messages files ENGLISH.LIN and RUSSIAN.LIN;
echo  - keyboard drivers:
echo      EURORUS.KDR   - for Germany, French and other DOS supported
echo                      European languages;
echo      TYPIST.KDR    - the Russian typewriter keyboard emulator;
echo      ISKRA.KDR     - driver for the Russian PC "ISKRA 1030.11";
echo      ES1841/2.KDR  - drivers for the Russian PC "EC1841/2";
echo  - the macros file UNDO.MAC for UNDO operating on XT computers;
echo  - the RUSCOD utility for recoding text files;
echo  - the LEXICON text files converters LEXVENT, LEXWPTF;
echo  - the OKI utility for printout quality enhancement for some 9-pin printers.

:ask_utils
echo.
if -%3 == -r ask "(��-1, ���-0, ��室-ESC) -?",10
if -%3 == -e ask "(Yes-1, No-0, Exit-ESC) -?",10
if errorlevel 3 goto exit
if errorlevel 2 goto set_voc
if -%3 == -r echo ��
if -%3 == -e echo YES
askspace 160000
if errorlevel 1 goto no_memory
if exist %1%2utils.exe goto set_uti

:d35_51
   echo **************************************************************************
   echo.
   if -%3 == -r echo   ��⠢�� ��� ������ DJ / ������� �������� 1.3 � ������ ���� �������.
   if -%3 == -e echo   Insert the disk FONTS DJ / UTILS of LEXICON v.1.3 and press any key.
   pause > nul
   if exist %1%2utils.exe  goto set_uti
   echo 
   echo.
   if -%3 == -r echo   �� �� ���! ��������, ���� ��� ������ DJ / ������� !
   if -%3 == -e echo   Sorry, wrong disk! Insert the FONTS DJ / UTILS disk, please!
   goto d35_51

:set_uti
   cd temp13
   %1%2utils
   copy . .. > nul
   cd ..
   echo Y | del temp13\*.* > nul

:set_voc
   if exist lex-rus.voc goto prosa
   cls
   echo *******************************************************************
   if -%3 == -r echo  ��⠭�������� ��⥬� �஢�ન �ࠢ���ᠭ�� ���᪨� ᫮� ?
   if -%3 == -e echo  Do you need the Russian Spelling-Checker ?
   if -%3 == -r ask "(��-1, ���-0, ��室-ESC) -?",10
   if -%3 == -e ask "(Yes-1, No-0, Exit-ESC) -?",10
   if errorlevel 3 goto exit
   if errorlevel 2 goto prosa
   if -%3 == -r echo ��
   if -%3 == -e echo YES
   askspace 1100000
   if errorlevel 1 goto no_memory
   echo.

:d2_1
   echo **********************************************************
   echo.
   if -%3 == -r echo ��⠢�� ��� 1 �������� �������� 1.2, ������ ���� �������.
   if -%3 == -e echo Insert disk 1 of LEXICON v. 1.2 and press any key.
   pause > nul
   if exist %1\lexfiles\rusvoc1.bin goto rusvoc1
   echo 
   echo.
   if -%3 == -r echo   �� �� ���! ��������, ���� ��� 1 �������� 1.2!
   if -%3 == -e echo   Sorry, wrong disk! Insert disk 1 of LEXICON 1.2, please!
   goto d2_1

:rusvoc1
   copy/b %1\lexfiles\rusvoc1.bin > nul

:d2_2
   echo *****************************************************************************
   echo.
   if -%3 == -r echo ��⠢�� ��� 3(5.25") ��� ��� 2(3.5") �������� 1.2, ������ ���� �������.
   if -%3 == -e echo Insert disk 3(5.25"), for 3.5" - disk 2 of LEXICON v.1.2, press any key.
   pause > nul
   if exist %1rusvoc2.bin goto create_voc
   echo 
   echo.
   if -%3 == -r echo �� �� ���! ��������, ���� ��� 3(5.25") ��� ��� 2(3.5") �������� 1.2!
   if -%3 == -e echo Sorry, wrong disk! Insert disk 3(5.25"), for 3.5" - disk 2 of LEXICON 1.2, please!
   goto d2_2

:create_voc
   echo.
   if -%3 == -r echo ������� 䠩��...
   if -%3 == -e echo Writing files...
rem �����⥭��� 䠩�� ��娢�
   copy/b rusvoc1.bin + %1rusvoc2.bin rusvoc.exe > nul
   rusvoc.exe
   del rusvoc*.* > nul

:prosa
if not exist prosa\*.* goto ask_ps
cd prosa
goto d35_52

:ask_ps
   echo ****************************************************************
   echo.
   if -%3 == -r echo ��⠭����� � �����⠫�� PROSA ����� �����, �।�����祭��
   if -%3 == -r echo ��� �ணࠬ��஢���� �ࠩ��஢ � ����䨪�樨 ���⮢ ��������� ?
   if -%3 == -e echo Do you want to install to the PROSA subdirectory the PROSA package
   if -%3 == -e echo aimed for programming printer drivers and modifying fonts ?
   if -%3 == -r ask "(��-1, ��室-ESC) -?",1
   if -%3 == -e ask "(Yes-1, Exit-ESC) -?",1
   if errorlevel 2 goto exit
   if -%3 == -r echo ��
   if -%3 == -e echo YES
   askspace 770000
   if errorlevel 1 goto no_memory

:d1_ps
   echo ***************************************************************************
   echo.
   if -%3 == -r echo   ��⠭���� ��� 1 ����� ����� (�������� 1.2) � ������ ���� �������.
   if -%3 == -e echo   Insert disk 1 of the PROSA package and press any key.   if -%3 == -e echo   Insert PROSA's disk 1 (v. 1.2 kit) and press any key.
   pause > nul
   if exist %1ps_tools.exe  goto set_ps
   echo 
   echo.
   if -%3 == -r echo   �� �� ���! ��������, ���� ��� 1 �����!
   if -%3 == -e echo   Sorry, wrong disk! Insert PROSA's disk 1, please!
   goto d1_ps

:set_ps
   if -%3 == -r echo ��⠭���� ����� ����� ����.
   if -%3 == -e echo PROSA's installation in progress.
   md prosa
   cd prosa
   md tools
   md fonts
   md work
   md examples
   md examples\fonts
   md examples\drivers
   echo.
   if -%3 == -r echo ������� �⨫���.
   if -%3 == -e echo Writing utilities.
   cd tools
   %1ps_tools
   cd ..
   if exist %1ps_exmpl.exe goto d2_ps

:disk2_5
   cls
   echo  ****************************************************************************
   echo.
   if -%3 == -r echo   ��⠢�� ��� 2 ����� ����� (�������� ���ᨨ 1.2) � ������ ���� �������.
   if -%3 == -e echo   Insert PROSA's disk 2 (LEXICON 1.2 kit) and press any key.
   pause > nul
   if exist %1ps_exmpl.exe  goto d2_ps
   echo 
   echo.
   if -%3 == -r echo   �� �� ���! ��������, ���� ��� 2 ����� !
   if -%3 == -e echo   Sorry, wrong disk! Insert PROSA's disk 2, please!
   goto disk2_5

:d2_ps
echo.
if -%3 == -r echo ������� 䠩�� ���㬥��樨.
if -%3 == -e echo Writing the documentation files.
%1ps_doc

echo.
if -%3 == -r echo ������� �ਬ��� �ࠩ��஢ � ���⮢.
if -%3 == -e echo Writing examples of fonts and drivers.
cd examples
%1ps_exmpl
cd ..

echo ************************************************************************
if -%3 == -r echo ��⠭�������� ��室�� 䠩�� ���⮢ ��� 9-������� �ਭ�஢ (340 K)?
if -%3 == -e echo Do you want to install the source files of fonts for 9-pin printers (340 K) ?
if -%3 == -r ..\ask "(��-1, ���-0, ��室-ESC) -?",10
if -%3 == -e ..\ask "(Yes-1, No-0, Exit-ESC) -?",10
if errorlevel 3 goto exit
if errorlevel 2 goto d35_52
..\askspace 340000
if errorlevel 1 goto no_memory
if -%3 == -r echo ��. ������� 䠩��...
if -%3 == -e echo YES. Writing files...
cd fonts
%1ps_lj9
cd ..

:d35_52
   if exist %1%2prosa.exe  goto new_ps
   cls
   echo ***************************************************************************
   echo.
   if -%3 == -r echo   ��⠢�� ��� ������ DJ / ������� �������� 1.3 � ������ ���� �������.
   if -%3 == -e echo   Insert the FONTS DJ / UTILS disk of LEXICON v.1.3 kit and press any key.
   pause > nul
   if exist %1%2prosa.exe goto new_ps
   echo 
   echo.
   if -%3 == -r echo   �� �� ���! ��������, ���� ��� ������ DJ / ������� !
   if -%3 == -e echo   Sorry, wrong disk! Insert the FONTS DJ / UTILS disk, please!
   goto d35_52

:new_ps
   cls
   echo **************************************************
   echo.
   if -%3 == -r echo  ������� ���� �࠭���� �ࠩ��஢ �ਭ�஢
   if -%3 == -r echo  � �������⥫��� ���㬥���� � ������ �����.
   if -%3 == -e echo  Installing the new version of printer driver translator
   if -%3 == -e echo  and additional guide for the PROSA package.
   echo.
   ..\askspace 70000
   if errorlevel 1 goto no_memory
   %1%2prosa
   if exist tools\*.* copy lexdrtr.exe tools\lexdrtr.exe > nul
   if exist tools\lexdrtr.exe del lexdrtr.exe
   cd ..

:final
cls
echo *******************************************************************
if -%3 == -e goto e_final
echo.
echo       ��⠭���� ��⥬� ��������� 1.3 �����襭�.
echo.
echo       ����������!  ��� ��ଠ�쭮� ࠡ��� ��������� ����室���:
echo.
echo  1) - ������� ��⠫�� ��������� � ᯨ᮪ ��⠫���� ������� PATH
echo       � 䠩�� AUTOEXEC.BAT;
echo  2) - ������� ��ப�
echo       FILES = 20
echo       (�� ����� 20) � 䠩� CONFIG.SYS.
echo.
echo       ������ �ᯥ客!
echo       ��� ��室� � ��� ������ ���� �������.
pause > nul
goto exit

:e_final
echo       The installation of LEXICON v. 1.3 is now complete.
echo.
echo.      ATTENTION! For the normal usage of LEXICON you should:
echo.
echo  1) - change AUTOEXEC.BAT by including the LEXICON directory in your PATH;
echo  2) - make sure that the line
echo       FILES = 20
echo       (or more) exists in your CONFIG.SYS file.
echo.
echo       Good luck!
echo       To exit to DOS, press any key.
goto exit

:no_memory
echo 
             echo ������������������������������������������������������
if -%3 == -e echo �   THERE IS NOT ENOUGH DISK SPACE ON TARGET DRIVE!  �
if -%3 == -e echo �               INSTALLATION ABORTED                 �
if -%3 == -r echo �           �� ����� ���� ���������� �����!          �
if -%3 == -r echo �                ��������� ��������                  �
             echo ������������������������������������������������������
echo.
if -%3 == -r echo �������, �ਤ���� �᢮������ ��᪮��� ������ � �맢��� INSTALL ᭮��.
if -%3 == -r echo ��� ��室� ������ ���� �������.
if -%3 == -e echo Sorry, you have to make room on disk and then run INSTALL again.ore.
if -%3 == -e echo Press any key to exit.
pause > nul

:exit
~del

:end
