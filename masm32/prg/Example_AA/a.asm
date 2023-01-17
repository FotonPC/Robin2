include ..\..\include\console.inc
.686p
COMMENT *
   —мена атрибутов страницы
*
date record day:5,month:4,year:7=4

integer typedef dword

.data
OldAttr dd   ?
param   dd   offset OldAttr
X       dd   123
Y       dd   ?
Z       word ?
Z1      integer 33333
Z4      byte 33
Z64     dq 123456789012345
buf     db 300 dup (?)
        df ? 


Dat1 date {22, ,}
Dat2 date {}

.code
Start:
   sub esp,4
   inchar byte ptr [esp],"¬ведите символ в [esp] ="
;   mov [esp],al
   mov al,[esp]
   newline
;   outchar byte ptr [esp],"byte ptr [esp]="
   outchar al,"byte ptr [esp]="
   newline

exit

@@:inint eax,"ƒлина текста="
   cmp   eax,0
   je    KOH
   outword eax,,"¬ведите текст длиной не более "
   inputstr offset buf,eax," симвлов="
   outintln eax,,"¬ведЄн текст длиной="
   outstr "¬ведЄнный текст="
   outstrln offset buf
   newline
   flush
   jmp   @B
   
KOH: 
exit

L:
inint X,"X="
Comment &
   cmp X,0
   jge @F
   neg X
@@:
&

mov eax,X
sar eaX,31; if X>=0 then eax:=0 else eax:=-1
xor X,eax
sub X,eax

outintln X
cmp X,0
jne L
exit

;   ChagePageAttr ChangedCode,PAGE_EXECUTE_READWRITE
;   invoke VirtualProtect,ChangedCode,1, \; 1 byte => одна страница
;          PAGE_EXECUTE_READWRITE,       \
;          offset OldAttr;                ; старые атрибуты страницы
   mov ebx,90909090h
   mov dword ptr ChangedCode,ebx
   mov byte ptr ChangedCode+4,bl
   mov ebx,11111111
   outintln ebx,,"ebx="
   jmp ChangedCode
;----------------------------------------------
ChangedCode:
   mov ebx,22222222; Over written  by 5 NOPs
   outintln ebx,,"ebx="
   exit
   end Start