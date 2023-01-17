include console.inc

COMMENT *
   Ввод целого числа и вывод суммы его цифр
*

.data
   X   dd  1
   Sm  dd 0 dup (?)
   Sum db ?; Сумма цифр
   T   dq 10
   Y   dw -2078
   Z   real4 ?
   
MaxLongint equ 80000000h

.code
Start:
   GotoXY 10,10
;Debug:
ifdef Debug
   outstrln 'Debug'
endif
   Pause    'Начнём, пожалуй...'
   ConsoleTitle "   Ввод целого числа, вывод суммы его цифр"
Begin:
   clrscr
   newline 2
   mov   Sum,0
   outstr 'Введите целое X='
   inintln X
OutFlags
   jnc   @L
   cmp   X,0
   jne   @F
   outstrln 'Плохая лексема числа !'
   jmp   Next
@@:
   outstrln 'Слишком большое число!'
   jmp   Next
@L:jnz   @F
   pushfd
   outstrln 'Введено число меньше нуля! ZF=1'
   popfd
@@:jns   @F
   outstrln 'Плохой конец лексемы целого числа!'
@@:mov   ebx,10
   mov   eax,X
L: cdq
   idiv  ebx
L1:neg   edx
   js    L1; edx:=abs(edx)
   add   Sum,dl; Sum:=Sum+цифра
;   outint Sum,,"Sum="
;   pause "  Press Enter..."
   cmp   eax,0
   jne   L
   outwordln Sum,,"Сумма цифр="

Next:
   MsgBox "Конец программы",                            \
          <"Желаете ещё раз?",13,10,"Или НЕ желаете?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp   eax,IDYES
   je    Begin

   exit 1

.data
msg    db  'Hello, world!',0
len    equ $-msg
Params dd  1;          файловый дескриптор (stdout)  
       dd  msg;        адрес сообщения
       dd  len;        длина сообщения
.code
Pech:
Comment # 
   mov  edx,len;        длина сообщения 
   mov  ecx,offset msg; сообщение для вывода на экран
   mov  ebx,1;          файловый дескриптор (stdout)
   push Vozv    
   push ecx
   push edx
   push ebp
   mov  ebp,esp
   syscall
   xor  eax,eax;        пропуститься
Vozv:   
   ret
#
   mov  eax,4;          номер системного вызова (sys_write)
   lea  edx,Params;     ссылка на список параметров 
   int 2Eh;             системный вызов
   exit
   end Start
