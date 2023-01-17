include console.inc

.data
X sdword 1
.code
Start:
   ClrScr
   ConsoleTitle "  Mакрокоманда .if"
   mov eax,3
.LISTALL

.repeat
    sub eax,1
.until eax==0 || !CARRY?; (eax=0) or (CF=0)

   MsgBox "Конец задачи","Повторить программу ?",MB_YESNO+MB_ICONQUESTION
   cmp  eax,IDYES
   je   Start
   exit
   end Start