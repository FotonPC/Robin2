@echo off
REM  ��������� ����������� �� ����� ����������� ������ ����� �����
REM  =========================================================================
REM  | ��� ���������� ���� test.bat � �������������� ���������� ��������� path  |
REM  =========================================================================
REM �������� ������� ��������� ��� ������ ����������� ����� m.bat :
REM main.asm - ������ (�������) ������, 
REM unit.asm - ������ ������

if exist main.asm goto Emain
echo main.asm - ������ (�������) ������ �����������
  goto TheEnd
:Emain
if exist unit.asm goto Eunit
echo unit.asm - ������ ������ �����������
  goto TheEnd
:Eunit

REM �������� ����, ��� ������� ������ ����������� MASM:
  set path= %path%;c:\masm 6.14\bin;..\bin;..\..\bin
REM ;c:\masm32\bin
REM  c:\masm 6.14 - �� ����������,  c:\masm32 - ���� 
  
REM ��������� (����������) ���������� (ml.exe -?):
REM    /Fl     �������� �������� (%~n1.lst)
REM    /I...   ������� � ����������� (�� include) �������
REM    /c      ���������� � ��������� ���� (%~n1.obj), ��� ����������
REM    /coff   ������ ���������� ����� � COFF (Common Object File Format)
REM    /nologo ������ �������� �� ����� ������ ����������� � ��.
REM -------------------------------------------------------------------------------
ml.exe /Fl /I"c:\masm 6.14\include" /c /coff /nologo main.asm 
REM  /Ic:\masm32\include
REM -------------------------------------------------------------------------------
REM �������� ���������� ����������
if errorlevel 1 goto errasm

ml.exe /Fl /I"c:\masm 6.14\include" /c /coff /nologo unit.asm 
REM -------------------------------------------------------------------------------
REM /Ic:\masm32\include 
REM �������� ���������� ����������
if errorlevel 1 goto errasm

REM ��������� ���������� (link.exe -?):
REM    /libpath:...       ������� � ���������������� ������������
REM    /subsystem:console �������� ������� ���������� Windows-����������.
REM    /nologo            ������ �������� �� ����� ������ ��������� ������ � ��.
REM --------------------------------------------------------------------------------------------
link.exe /libpath:"c:\masm 6.14\lib" /subsystem:console main.obj unit.obj 
REM  /libpath:c:\masm32\lib /nologo
REM --------------------------------------------------------------------------------------------
REM  �������� ������������� ��������� ������
del unit.obj 
del main.obj  
main.exe
  goto TheEnd

:errasm
REM ��������� � ���, ��� � �������� ���������� ���� ������������� ������
  echo Assembler Error !!!!!!!!!!!!
  goto TheEnd

:TheEnd
rem 
pause
rem echo on
