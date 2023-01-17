include console.inc

COMMENT *
   Ввод целого числа, вывод его зеркального вида,
   например, -1234 => 4321-
   работает даже при значении числа = MinLongint
*

.data
   X   dd ?
   Y   dd ?
Z dw ?
.code
Begin_of_program:
   clrscr
   GotoXY 10,3
   ConsoleTitle "  Вывод зеркального вида целого числа"
   newline 2
   inintln X,' Введите целое  X = '
   jc   Error
   jns  L0
   pushfd
   outstrln "Плохой конец лексемы целого числа!"
   popfd
L0:jz   Minus
   outstr ' Зеркальный вид X = '
   mov  ebx,10
   mov  eax,X
M: mov  edx,0; беззнаковое число
   div  ebx
   outword dl; Последняя цифра
   cmp  eax,0
   jne  M
   jmp  L2
Minus:
   outstr ' Зеркальный вид X = '
   mov  ebx,10
   mov  eax,X
   mov  Y,eax
L: cdq
   idiv  ebx
L1:neg  edx
   js   L1;    abs(Последняя цифра)
   outword dl; Последняя цифра
   cmp  eax,0
   jne  L
   cmp  Y,0
   jge  L2
   outchar '-' 
L2:
   newline
   MsgBox "Конец задачи","Попробуем ещё одно число ?",MB_RETRYCANCEL+MB_ICONQUESTION
   cmp  eax,IDRETRY
   jne  KOH
;   flush
   jmp  Begin_of_program
Error:
   outstrln "Введено плохое целое число!"
   jmp  L2
KOH:
   exit
   end Begin_of_program