include console.inc

COMMENT *

   ��������� ���������

*

.data

.code
Start:
    ClrScr
    outstr "������"; 866  DOS
    newline 1
    ConsoleMode
    outstrln "������"; 1251 Win
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