include console.inc

COMMENT *
   Вызывается из другой программы.
   Ввод целого числа, вывод его зеркального вида,
   например, -1234 => 4321-
   работает даже при значении числа = MinLongint
*

.data
   X   dd ?
   Y   dd ?

.code
Begin_of_program:

;   extrn FreeConsole@0:near,AllocConsole@0:near
;   call FreeConsole@0
;   call AllocConsole@0 

NewConsole

   settextattr
   clrscr
   GotoXY 10,3
   ConsoleTitle "  Вывод зеркального вида целого числа"
   newline 2
   inint X,' Введите целое X = '
   outstr ' Зеркальный вид  = '
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

KOH:

   settextattr 16*Blue+Yellow

   exit
   end Begin_of_program