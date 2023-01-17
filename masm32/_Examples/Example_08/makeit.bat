@echo off

  set Name=a
  set path=..\bin;..\..\bin
  set include=..\include;..\..\include
  set lib=..\lib;..\..\lib

  ml /c /coff /Fl /nologo %Name%.asm

  if errorlevel 1 goto errasm

  Link /subsystem:console /nologo %Name%.obj

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
