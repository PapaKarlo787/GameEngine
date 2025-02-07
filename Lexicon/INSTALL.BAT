@echo off
rem ������ 䠩� ��� ��⠭���� ���������  1.3
rem ��ࠬ����: 1 [��室�� ��᪮���]
rem ��ࠬ����: 2 [�ਥ��� ��� ��� ��⠫�� ��� ��� �몠] (e-english; r-russian)
rem ��ࠬ����: 3 [��� �몠]

rem ������ �� ��᪮���-���筨�? �᫨ ���, �뤠�� ���᪠���.
if -%1 == - goto bad_call
for %%d in (a: b: A: B:) do if -%1 == -%%d goto recall
echo   Source DRIVE NAME ISN'T RECOGNIZED (a: or b:)
echo   �� �������� ��� ��������� ��������� (a: ��� b:)
echo Press any key to get help / ������ ���� ������� ��� �뤠� ���᪠���.
pause > nul
goto bad_call

:recall
rem ��ࠡ�⪠ ���� �몠 �������, ��७�� ��� � 3-� ��ࠬ���
if -%2 == -# goto chkdir
if -%2 == -  %1\install %1 # r
if -%2 == -e %1\install %1 # e
if -%2 == -E %1\install %1 # e
if -%2 == -R %1\install %1 # r
if -%2 == -E %1\install %1 # e
if -%3 == -  %1\install %1 %2 r
if -%3 == -R %1\install %1 %2 r
if -%3 == -E %1\install %1 %2 e
goto param2

:chkdir
rem �஢����, ���� �� � ⥪�饬 ��⠫��� 䠩�� ���������.
if exist *.lex goto upgrade
rem �᫨ ⥪�騩 ��⠫�� ����, ����� ����� ��⠭����
if not exist *.* goto newinst
if -%3 == -e echo There are no LEXICON files in current directory (*.LEX), upgrade impossible.
if -%3 == -e echo �urrent directory isn't empty, new installation isn't possible.
if -%3 == -r echo � ⥪�饬 ��⠫��� ��� 䠩��� ��������� (*.LEX), ᬥ�� ���ᨨ ����������.
if -%3 == -r echo ����騩 ��⠫�� �� ����, ����� ��⠭���� ����������.
if -%3 == -e echo Press any key to get help.
if -%3 == -r echo ������ ���� ������� ��� �뤠� ���᪠���.
pause > nul
goto bad_call

:param2
rem ������ �� ��ࠬ��஬ 2 ���? �᫨ ��, ����� ��⠭���� � ᮧ����� �����⠫���.
for %%d in (c: C: d: D: e: E: f: F: g: G: h: H: i: I: j: J: k: K: l: L: m: M: n: N:) do if -%2 == -%%d goto cdlex
rem �᫨ ⥪�騩 ��⠫�� ����, ����� ����� ��⠭����
if not exist *.* goto newinst

:warning
if -%3 == -e echo The second parameter should be TARGET DRIVE NAME (installation in ROOT\LEXICON).
if -%3 == -r echo ��ன ��ࠬ��� ������ ���� ������ ����� (��⠭���� � ��⠫�� \LEXICON).
echo.
if -%3 == -e echo Press any key to get help.
if -%3 == -r echo ������ ���� ������� ��� �뤠� ���᪠���.
pause > nul
goto bad_call

:cdlex
%2
cd \
md lexicon > nul
cd lexicon

rem �맮� �����a, �த�����饣� ��⠭����.
rem ��।�� ��ࠬ��஢: 1 - ��� ��᪠, 2 - ���� � ���⠬, 3 - ��
rem 4 - upgrade ��� new (����� ��⠭����)

:newinst
copy %1\lexfiles\ask*.* > nul
copy %1\lexfiles\~*.* > nul
if exist %1\fonts\pr_9.exe ~ %1 \fonts\ %3 n
~ %1 \ %3 n

:upgrade
if exist ~*.bat del ~*.bat
copy %1\lexfiles\ask*.* > nul
copy %1\lexfiles\~*.* > nul
if exist %1\fonts\pr_9.exe ~ %1 \fonts\ %3 u
~ %1 \ %3 u

:bad_call
cls
echo If LEXICON 1.2 is already installed on your system, run INSTALL from
echo directory with its files:  install source_drive [e] (english dialogue).
echo                For example:  a:install a: e
echo For the first installation you need distribution kits for both 1.2 and 1.3
echo versions. In this case run INSTALL with three parameters:
echo                            install source_drive target_drive [e]
echo                For example:  a:install a: c: e
echo LEXICON will be installed to the \LEXICON directory on the target drive.
echo You can create a new directory for LEXICON at any place on your tree (manually)
echo and run INSTALL from this directory,
echo for example:  a:install a: lex13 - to install to the LEX13 directory (empty).
echo �����������������������������������������������������������������������������
echo �᫨ �� �������� 㦥 ��⠭����� �������� 1.2, ��३��� � ��� ��⠫��
echo � �맮��� INSTALL ⠪:  install ��᪮���_��㤠
echo               ���ਬ��:  a:install a:
echo �᫨ �� ��⠭�������� �������� ������, ����� � ��᪥⠬� ���ᨨ 1.3
echo ����������� �������� ��᪥� ���ᨨ 1.2. � �⮬ ��砥 ��뢠�� INSTALL ⠪:
echo                  install ��᪮���_��㤠 ���_�㤠
echo     ���ਬ��:    install a: c:
echo �������� �㤥� ��⠭����� � �����⠫�� LEXICON � ��୥��� ��⠫��� 㪠�������
echo ��᪠. ����� ⠪�� ������ ᮧ���� ��⠫�� ��� ��������� � ��� ������
echo � � �� ����, ������� � ���� � �맢��� INSTALL, ��� �� ���������� ���ᨨ,
echo     ���ਬ��    a:install a: - ��� ��⠭���� � ⥪�騩 ��⠫�� (���⮩).
echo ��� ������ ���� ������� ��� ��室�. Press any key to exit. 
pause > nul
