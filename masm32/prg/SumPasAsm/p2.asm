.386
.model flat,stdcall
option casemap:none

Comment * модуль p2.asm
   Суммирование массива, контроль ошибок.
   В конечном end не нужна метка Start
*
.code
   public Sum;         внешнее имя _Sum@0

   externdef  Error: byte; внешнее имя _Error
;   extrn  Error: byte; внешнее имя _Error
Sum proc
   push ebp
   mov  ebp,esp
   push ecx
   push ebx
   mov  Error,-1;     Error:=true  
   mov  ebx,[ebp+8];  адрес А[1]
   mov  ecx,[ebp+12]; N
   xor  eax,eax;      Sum:=0
L: add  eax,[ebx];    Sum:=Sum+A[i]
   jo   Voz;          при переполнении
   add  ebx,4;        i:=i+1
   loop L
   mov  Error,0;      Error:=false
Voz:
   pop  ebx
   pop  ecx
   pop  ebp
   ret  8
Sum endp
   end
