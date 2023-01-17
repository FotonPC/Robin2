include console.inc

COMMENT *

   Заготовка программы

*
.data
x dd ?
.code
Start:
   ClrScr
   ConsoleTitle "  Заготовка программы"
DEBUG = 1
ifdef DEBUG
   outstrln 'Hi'
endif

;   k = 0FFFFFFFFh
;   k = -1
k equ -1
; Макропроцессор "видит" беззнаковое k=0FFFFFFFh
if k LT 0
   outnumln k,,x
else
   outnumln k,,X
   k = -1
endif

   MsgBox "Конец задачи","Повторить программу ?",MB_YESNO+MB_ICONQUESTION
   cmp  eax,IDYES
   je   Start
   exit
   end Start