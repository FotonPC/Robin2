include console.inc

.data
buf db 0,0,0
_10 dd 10

.code
inint_proc proc
; Схема Горнера
     push  ebx
     push  ecx
     push  edx
     mov   buf+1,0;   ещё не было символов числа
     mov   buf+2,0;   хороший конец лексемы (spaces,CR,LF)
     xor   ebx,ebx;   здесь формируем x
@MM: invoke StdIn,offset buf,1; один символ
     cmp   buf,' '
     jne   @M1
     cmp   buf+1,0
     je    @MM;       ещё не было символов числа
     jmp   KOH;       пробел - конец лексемы
@M1: cmp   buf,13;    CR
     jne   @M11
     cmp   buf+1,0
     je    @MM;       CR, но ещё не было символов числа
     jmp   KOH;       CR - конец числа
@M11:cmp   buf,10;    LF
     jne   @M2
     cmp   buf+1,0
     je    @MM;       LF, но ещё не было символов числа
     jmp   KOH;       LF - конец строки и числа (так не бывает!)
@M2: cmp   buf,'-'
     jne   @M3
     cmp   buf+1,0
     jne   KOH1;      минус внутри числа - плохой конец лексемы
     mov   buf+1,'-'; минус перед числом
     jmp   @MM
@M3: cmp   buf,'+' 
     jne   @M4
     cmp   buf+1,0
     jne   KOH1;      плюс внутри числа - плохой конец лексемы
     mov   buf+1,'+'; плюс перед числом
     jmp   @MM
@M4: cmp   buf,'0'
     jb    KOH1;      не цифра - плохой конец лексемы
     cmp   buf,'9'
     ja    KOH1;      не цифра - плохой конец лексемы
     cmp   buf+1,0
     jne   @M5
     mov   buf+1,'+'; первая цифра числа, минуса не было
;    цифра
@M5: mov   eax,ebx
     mul   _10
     jc    Error
     mov   ebx,eax;   x:=10*x 
     movzx eax,buf
     sub   eax,'0'
     add   ebx,eax;   x:=x*10+digit
     jc    Error
     cmp   buf+1,'-'; был минус перед числом
     jne   @MM;        не было минуса перед числом
     cmp   ebx,80000000h;  
     jbe   @MM
;    плохое число со знаком минус
     jmp   Error
KOH1:mov   buf+2,1;   плохой конец лексемы числа     
KOH: mov   eax,ebx
     cmp   buf+1,'-'
     jne   @M6
     neg   eax
@M6: cmp   buf+1,'-'; ZF:=1 => есть "-", иначе ZF:=0
     clc            ; CF:=0 - число в диапазоне dword
     pushfd
     and   byte ptr [esp],7Fh; SF:=0
     cmp   buf+2,0;   хорошая лексема ?  
     je    @M7
     or    byte ptr [esp],80h; SF:=1
@M7: popfd;         есть флаги CF=0, ZF и SF
@M8: pop   edx
     pop   ecx
     pop   ebx
     ret
Error:
     SetTextAttr Yellow
     outstrln "** inint: Number too big:=MaxLongint, CF:=1 **"
     SetTextAttr
     mov   eax,7FFFFFFFh; MaxLongint
     push  eax
     flush
     pop   eax
     stc;           CF:=1 - ошибка, ZF и SF не определены
     jmp  @M8
inint_proc endp
;---------------------------------

     end
