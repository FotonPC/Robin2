@echo off
:begin
Cls
Title Калькулятор
Color 1e
Echo Введите выражение:
Set /?
Set /P exp=
Set /A result=%exp%
Echo Значение выражения: %exp% = %result%
Pause >nul
goto begin

