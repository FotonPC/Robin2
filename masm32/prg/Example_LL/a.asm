include console.inc

COMMENT *
   Получение ECX числа Чибоначчи
*

.data
.code
Start:
   ClrScr
   ConsoleTitle "   Получение ECX-го числа Чибоначчи"
   Newline 3

   xor  eax,eax
  
   mov  edx,1
   inint ecx,"ecx="
L: xadd eax,edx
   loop L
   outwordln eax

   neg  eax
   sbb  eax,eax
   neg  eax
   outwordln eax

   MsgBox " Конец программы", \
          <"Повторить",13,10,"программу",13,10,"с начала ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp eax,IDYES
   je  Start
KOH:   
   exit
   end Start
