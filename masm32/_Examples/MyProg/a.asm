include console.inc

COMMENT *

   Заготовка программы

*
.data


.code
Start:
   ClrScr
   ConsoleTitle "  Заготовка программы"

   MsgBox "Конец задачи","Повторить программу ?",MB_YESNO+MB_ICONQUESTION
   cmp  eax,IDYES
   je   Start
   exit
   end Start