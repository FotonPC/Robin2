include console.inc
.data
   N db ?
.code
Start:
   ClrScr
QQ:
   inchar N,'������='
   flush
   ConsoleMode
   outcharln N
   ConsoleMode
   jmp QQ
   exit
end Start


 