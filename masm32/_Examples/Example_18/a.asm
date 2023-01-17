include console.inc
.data
   N db ?
.code
Start:
   ClrScr
QQ:
   inchar N,'Символ='
   flush
   ConsoleMode
   outcharln N
   ConsoleMode
   jmp QQ
   exit
end Start


 