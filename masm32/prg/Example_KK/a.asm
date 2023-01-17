include console.inc

COMMENT *
   Замер скорости работы циклов

*

.data
M dq 0 dup (?)
N dd 0,0
.code
Start:
   ClrScr
   ConsoleTitle "   Замер скорости работы циклов"
   Newline 3

K  equ  100000
   mov  ebx,K
L: rdtsc
   mov  esi,eax
   mov  edi,edx
   mov  ecx,10000
@@:add  eax,ecx
;   add  eax,ecx
;   add  eax,ecx
;   add  eax,ecx
   sub  ecx,1
   jnz  @B 
;   loop @B
   rdtsc
   sub  eax,esi
   sbb  edx,edi
   add  N,eax
   adc  N+4,edx
   dec  ebx
   jnz  L
   mov  eax,N
   mov  edx,N+4
   mov  ebx,K
   div  ebx
   outwordln eax

   MsgBox " Конец программы", \
          <"Повторить",13,10,"программу",13,10,"с начала ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp eax,IDYES
   je  Start
KOH:   
   exit
   end Start
