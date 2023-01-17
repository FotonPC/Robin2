@echo off

  set Name=a3-1
  set path=..\bin;..\..\bin
  set include=..\include;..\..\include
  set lib=..\lib;..\..\lib

  ml /c /coff /Fl %Name%.asm
Rem  ml /c /coff %Name%.asm
  if errorlevel 1 goto errasm

Rem  Link /?
Rem  Link /subsystem:console /out:a3.exe %Name%.obj a3-2.obj
Rem  Link /subsystem:console /map:%Name%.map %Name%.obj a3-2.obj
  Link /subsystem:console %Name%.obj a3-2.obj

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
