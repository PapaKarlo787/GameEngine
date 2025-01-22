@echo off
rem Пакетный файл для установки ЛЕКСИКОНа  1.3
rem Параметры: 1 [исходный дисковод]
rem Параметры: 2 [приемный диск или каталог или код языка] (e-english; r-russian)
rem Параметры: 3 [код языка]

rem Указан ли дисковод-источник? Если нет, выдать подсказку.
if -%1 == - goto bad_call
for %%d in (a: b: A: B:) do if -%1 == -%%d goto recall
echo   Source DRIVE NAME ISN'T RECOGNIZED (a: or b:)
echo   НЕ ОПОЗНАНО ИМЯ ИСХОДНОГО ДИСКОВОДА (a: или b:)
echo Press any key to get help / нажмите любую клавишу для выдачи подсказки.
pause > nul
goto bad_call

:recall
rem Обработка кода языка диалога, перенос его в 3-й параметр
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
rem Проверить, есть ли в текущем каталоге файлы ЛЕКСИКОНа.
if exist *.lex goto upgrade
rem Если текущий каталог пуст, начать новую установку
if not exist *.* goto newinst
if -%3 == -e echo There are no LEXICON files in current directory (*.LEX), upgrade impossible.
if -%3 == -e echo Сurrent directory isn't empty, new installation isn't possible.
if -%3 == -r echo В текущем каталоге нет файлов ЛЕКСИКОНа (*.LEX), смена версии невозможна.
if -%3 == -r echo Текущий каталог не пуст, новая установка невозможна.
if -%3 == -e echo Press any key to get help.
if -%3 == -r echo Нажмите любую клавишу для выдачи подсказки.
pause > nul
goto bad_call

:param2
rem Указан ли параметром 2 диск? Если да, начать установку с создания подкаталога.
for %%d in (c: C: d: D: e: E: f: F: g: G: h: H: i: I: j: J: k: K: l: L: m: M: n: N:) do if -%2 == -%%d goto cdlex
rem Если текущий каталог пуст, начать новую установку
if not exist *.* goto newinst

:warning
if -%3 == -e echo The second parameter should be TARGET DRIVE NAME (installation in ROOT\LEXICON).
if -%3 == -r echo Второй параметр должен быть ИМЕНЕМ ДИСКА (установка в каталог \LEXICON).
echo.
if -%3 == -e echo Press any key to get help.
if -%3 == -r echo Нажмите любую клавишу для выдачи подсказки.
pause > nul
goto bad_call

:cdlex
%2
cd \
md lexicon > nul
cd lexicon

rem Вызов пакетa, продолжающего установку.
rem Передача параметров: 1 - имя диска, 2 - путь к шрифтам, 3 - язык
rem 4 - upgrade или new (новая установка)

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
echo ─────────────────────────────────────────────────────────────────────────────
echo Если на компьютере уже установлен ЛЕКСИКОН 1.2, перейдите в его каталог
echo и вызовите INSTALL так:  install дисковод_откуда
echo               например:  a:install a:
echo Если Вы устанавливаете ЛЕКСИКОН заново, вместе с дискетами версии 1.3
echo понадобится комплект дискет версии 1.2. В этом случае вызывайте INSTALL так:
echo                  install дисковод_откуда диск_куда
echo     например:    install a: c:
echo ЛЕКСИКОН будет установлен в подкаталог LEXICON в корневом каталоге указанного
echo диска. Можно также вручную создать каталог для ЛЕКСИКОНа с любым именем
echo и в любом месте, ПЕРЕЙТИ В НЕГО и вызвать INSTALL, как при обновлении версии,
echo     например    a:install a: - для установки в текущий каталог (пустой).
echo ▌▌▌ Нажмите любую клавишу для выхода. Press any key to exit. 
pause > nul
