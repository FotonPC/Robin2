@echo off
:begin
Cls
Title ��������
Color 1e
Echo ������ ��ࠦ����:
Set /?
Set /P exp=
Set /A result=%exp%
Echo ���祭�� ��ࠦ����: %exp% = %result%
Pause >nul
goto begin

