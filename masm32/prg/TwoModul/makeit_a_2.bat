@echo off

  set Name=a_2
  set path=..\bin;..\..\bin
  set include=..\include;..\..\include
  set lib=..\lib;..\..\lib

  ml /c /coff /Fl %Name%.asm
Rem  ml /c /coff %Name%.asm
  if errorlevel 1 goto errasm

  Link /subsystem:console %Name%.obj

  if errorlevel 1 goto errlink

   %Name%.exe
  goto TheEnd

:errlink
  echo Link Error !!!!!!!!!!!!!!!!!
  goto TheEnd

:errasm
  echo Assembler Error !!!!!!!!!!!!
  goto TheEnd

:TheEnd

pause
