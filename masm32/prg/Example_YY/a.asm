include console.inc
.686

COMMENT *
   Проверка всякой всячины
*

.data
  X  dq 1 
  Y  dd 2
  Z  dw 3
  _2 dd 2
  Q  dq ?
  V  db 10 dup (?),0
     
.code
Start:
   ConsoleTitle " Целые числа на вещественных регистрах"
   
; Q:=5*Z*(X+Y)
   FILD  X; ВСТЕК(X)
   FIADD Y; st(0):=X+Y
   FIMUL Z; st(0):=Z*(X+Y)
   FIMUL _2; st(0):=2*Z*(X+Y)
;   FISTP Q; ИЗСТЕКА(Q)
;   outintln Q,,"2*Z*(X+Y)="

   FBSTP  tbyte ptr V; ИЗСТЕКА(V)
;   outstrln offset V
   xor ebx,ebx
   mov ecx,10
L: mov al,V[ebx]
   mov ah,al
   shr ah,4
   add ah,'0'
   and al,1111b
   add al,'0'
   outcharln ah
   outcharln al
   inc ebx
   dec ecx
   jne L
   
; стековые операции
   FILD  X; ВСТЕК(X)
   FILD  Y; ВСТЕК(Y)
   FADD   ; st(0)=X+Y
   FILD  Z; ВСТЕК(Z)
   FMUL   ; st(0):=Z*(X+Y)
   FLD   st(0); ВСТЕК(st(0))
   FADD   ; st(0):=2*Z*(X+Y)
   FISTP Q; ИЗСТЕКА(Q)
   outintln Q,,"2*Z*(X+Y)="

exit

   ConsoleTitle "   Проверка RDTSC"

N  equ   100000

   mov   esi,-1; MaxLongword
   mov   edi,N
L1:   
   rdtsc
   mov  ebx,eax
   mov  ecx,10000
@@:add  eax,ecx
   loop @B	
   rdtsc		
   sub  eax,ebx
   cmp  eax,esi
   jae  @F
   mov  esi,eax
@@:
   dec  edi
   ja   L1
   outwordln esi,,"Число тактов="


   rdtsc		
   mov ebx,eax	
   mov ecx,10000	
@@:add eax,ecx
   dec ecx
   jnz @B
   rdtsc
   sub eax,ebx
   outwordln eax

   rdtsc
   mov ebx,eax
   mov ecx,10000
@@:add eax,ecx
   add edi,ebx
   add esi,ebx
   add ebp,ebx
   sub ecx,4
   jnz @B
   rdtsc
   sub eax,ebx
   outwordln eax

; 10000=55000,25000,15000

exit

;if1
;   echo Pass1
;else
;   echo Pass2
;endif

   exit
   end Start