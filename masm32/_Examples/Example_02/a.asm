include console.inc

COMMENT *

   Ввод текста до точки,
   вывод количества цифр в тексте

*

.data
   cc  db ?
   N   dd 0; Число цифр

.code
Start:
   ClrScr
   GotoXY 10,3
   ConsoleTitle "   Число символов цифр в тексте до точки"
   newline 2
   outstrln 'Вводите текст до точки:'
   mov  N,0
L: inchar cc
   cmp  cc,'0'
   jb   L1 
   cmp  cc,'9'
   ja   L1 
   inc  N
L1:cmp  cc,'.'
   jne  L
   newline
   SetTextAttr Yellow
   outstr "Число цифр в тексте="
   outwordln N
   SetTextAttr
   MsgBox " Конец программы", \
          <"Повторить",13,10,"программу",13,10,"с начала ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp  eax,IDYES
   je   Start
   exit
   end Start