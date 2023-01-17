include console.inc

Comment *
   Функция на Ассемблере вызывается из Паскаля
*

.code
   public FU
FU proc
   push ebp
   mov  ebp,esp
;outstrln "Hi from Connect.asm"
   mov  eax,[ebp+12]; FUN:=2-й параметр-значение
   add  eax,[ebp+8]; 
   pop  ebp
;push 0
;call ExitProcess
   ret  8
FU endp
   end
