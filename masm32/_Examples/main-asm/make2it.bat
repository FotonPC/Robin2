@echo off
REM  ќтключили отображение на экран выполн€емых команд этого файла
REM  =========================================================================
REM  | Ёто коммандный файл test.bat с доопределением переменной окружени€ path  |
REM  =========================================================================
REM ѕроверка наличи€ параметра при вызове коммандного файла m.bat :
REM main.asm - первый (главный) модуль, 
REM unit.asm - второй модуль

if exist main.asm goto Emain
echo main.asm - первый (главный) модуль отсутствует
  goto TheEnd
:Emain
if exist unit.asm goto Eunit
echo unit.asm - второй модуль отсутствует
  goto TheEnd
:Eunit

REM указание мест, где следует искать дистрибутив MASM:
  set path= %path%;c:\masm 6.14\bin;..\bin;..\..\bin
REM ;c:\masm32\bin
REM  c:\masm 6.14 - на факультете,  c:\masm32 - дома 
  
REM ѕараметры (компил€ции) ассемблера (ml.exe -?):
REM    /Fl     создание листинга (%~n1.lst)
REM    /I...   каталог с включаемыми (по include) файлами
REM    /c      трансл€ци€ в объектный файл (%~n1.obj), без компоновки
REM    /coff   формат объектного файла Ч COFF (Common Object File Format)
REM    /nologo запрет выдавать на экран версию компил€тора и др.
REM -------------------------------------------------------------------------------
ml.exe /Fl /I"c:\masm 6.14\include" /c /coff /nologo main.asm 
REM  /Ic:\masm32\include
REM -------------------------------------------------------------------------------
REM ѕроверка успешности компил€ции
if errorlevel 1 goto errasm

ml.exe /Fl /I"c:\masm 6.14\include" /c /coff /nologo unit.asm 
REM -------------------------------------------------------------------------------
REM /Ic:\masm32\include 
REM ѕроверка успешности компил€ции
if errorlevel 1 goto errasm

REM ѕараметры компоновки (link.exe -?):
REM    /libpath:...       каталог с вспомогательными библиотеками
REM    /subsystem:console указание строить консольное Windows-приложение.
REM    /nologo            запрет выдавать на экран версию редактора св€зей и др.
REM --------------------------------------------------------------------------------------------
link.exe /libpath:"c:\masm 6.14\lib" /subsystem:console main.obj unit.obj 
REM  /libpath:c:\masm32\lib /nologo
REM --------------------------------------------------------------------------------------------
REM  ”даление промежуточных объектных файлов
del unit.obj 
del main.obj  
main.exe
  goto TheEnd

:errasm
REM —ообщение о том, что в процессе компил€ции были зафиксированы ошибки
  echo Assembler Error !!!!!!!!!!!!
  goto TheEnd

:TheEnd
rem 
pause
rem echo on
