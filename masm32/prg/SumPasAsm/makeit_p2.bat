@echo off

  set Name=p2
  set path=..\bin;..\..\bin
  set include=..\include;..\..\include
  set lib=..\lib;..\..\lib

  ml /c /coff /Fl %Name%.asm
Rem  ml /c /coff %Name%.asm
  if errorlevel 1 goto errasm

  goto TheEnd

:errasm
  echo Assembler Error !!!!!!!!!!!!
  goto TheEnd

:TheEnd

pause
