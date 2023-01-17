include console.inc

COMMENT *
   Отладочный модуль
*
tRec struc
  a  db ?
Name db ?
tRec ends

.data
  X dd ?
  Y df ?

@Info MACRO
%echo
%echo Compiler version : @Version
%echo Compilation date : @Date, @Time
%echo
ENDM

.code
Start:
@Info
clrscr
    Newline 3
    OutFlafs
    mov   eax,0C0000000h
    shl   eax,1
    OutFlafs
exit

    mov  al,-1
    outnumln al,,b
    clc
    db   0d6h;    setalc
    outnumln al,,b
    stc
    db   0d6h
    outnumln al,,b
    exit
    end Start
