
     set path=d:\Free Pascal 2.6.4\bin\i386-win32\
rem     set lib=c:\windows\system32
     set lib=..\lib;..\..\lib

     fpc TwoModul.pas -Xe -k"-L d:\temp -luser32 -lkernel32 -lmsvcrt -lmasm32"
rem     fpc TwoModul.pas -Xe -k"-L c:\windows\system32 -luser32 -lkernel32 -lmsvcrt -lmasm32"
     if not errorlevel 1 TwoModul.exe

     pause