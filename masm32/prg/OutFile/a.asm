include console.inc

COMMENT *

   Заготовка программы

*

.data

.code
Start:
    ClrScr
    outstr "Привет"; 866  DOS
    newline 1
    ConsoleMode
    outstrln "Привет"; 1251 Win
    newline 3

    outint   27
    outchar  '+'
    outint   23
    outchar  '='
    outint   50
    newline

    wait  



    exit
   end Start