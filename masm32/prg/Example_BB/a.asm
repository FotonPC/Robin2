include console.inc

COMMENT *
   Отладочный модуль
*

.data
X   dd -555
Y   dq -1234567890123456789
fmt db "X=%I64d",0
buf db 20 dup ('*'),0

.code
Start:
   ConsoleTitle "Проверка sprintf"
   
;outnumln X,,,"outnumln ="
;outnumln X,,d,"outnumln d="
;outnumln X,,x,"outnumln x="
;outnumln X,,X,"outnumln X="
;outnumln X,,b,"outnumln b="

outnumln Y,,,"outnumln Yd="
outnumln Y,,X,"outnumln YX="
outnumln Y,,u,"outnumln Yu="
outnumln X,,b,"outnumln Xb="
outnumln Y,,b,"outnumln Yb="

outintln Y,30,"outintln Y="
lea eax,Y
outintln qword ptr [eax],30,"outintln Y="
outwordln Y,30,"outwordln Y="
;   invoke crt_printf,offset fmt,Y
;newline

exit

   invoke crt_sprintf,offset buf,offset fmt,X
outstrln offset buf
newline
   invoke crt_sprintf,offset buf,offset fmt,Y
outstrln offset buf
newline

   pause
   exit
   end Start
