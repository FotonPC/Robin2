include console.inc

COMMENT *
   Ввод целого числа от N 1 до 100, затем ввод массива
   X: array[1..N] of longint;
   вывод max X[i], которые меньше X[N], а если таких
   нет, то вывод "Таких чисел нет!". Сумма вычисляется в функции
   function MaxGtLast(var X:Mas; N:Longword):Longint; 
*

MinLongint equ 80000000h

.data
   M    dd 100 dup (?)
   Nmax dd ?
   Y    dd ?
   T    db "Максимальное из чисел, меньших последнего = ",0

.code
MaxGtLast proc
     push ebp
     mov  ebp,esp
     push ebx
     push ecx
@Last equ  edx
     push edx
@X   equ  dword ptr [ebp+8];  адрес X[1]
@N   equ  dword ptr [ebp+12]; длина
     mov  ebx,@X;             адрес X[1]
     mov  ecx,@N
     mov  @Last,[ebx+4*ecx-4]
     dec  ecx
     mov  eax,MinLongint
@L0: cmp  [ebx],@Last
     jge  @L1
     cmp  eax,MinLongint
     jne  @L2
     mov  eax,[ebx];          первое X[i] меньше Last
     jmp  @L1
@L2: cmp  eax,[ebx]
     jge  @L1;                eax >= X[i]
     mov  eax,[ebx];          не первое X[i] меньше Last
@L1: add  ebx,4;              i:=i+1
     loop @L0
     pop  edx
     pop  ecx
     pop  ebx
     pop  ebp
     ret  8
MaxGtLast endp
;----------------------------------
Start:
     clrscr
     GotoXY 10,3
     ConsoleTitle "    MAX  из  X[i],  меньших  X[N]"
     newline 2
     inint Nmax,' Введите длину массива N меньше 100 и N больше 1 : '
     mov   ecx,Nmax
     mov   ebx,0;    i:=1
     cmp   ecx,100
     jg    L0
     cmp   ecx,1
     jg    L1
L0:  MsgBox "Плохая длина","Попробуем ещё раз ?",MB_RETRYCANCEL+MB_ICONQUESTION
     cmp  eax,IDRETRY
     je   Start
     exit
L1:  outword Nmax,,"Введите массив из "
     outstrln " чисел :"
L2:  inint M[4*ebx]
     inc   ebx;      i:=i+1
     loop  L2
     push  Nmax
     push  offset M
     call  MaxGtLast
.if  eax==MinLongint
     SetTextAttr Yellow
     outstrln "Таких чисел нет!"
     SetTextAttr
.else
     outintln eax,,offset T
.endif
     newline
     MsgBox "Конец задачи","Попробуем ещё один массив ?",MB_YESNO+MB_ICONQUESTION
     cmp  eax,IDYES
     je   Start

     exit
     end Start