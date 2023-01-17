include ..\..\include\console.inc

COMMENT *
   Суммирование матрицы
   Копирование массива
*

Nmin equ 600
K equ 80
M equ 50000

.data
X   dd K dup (K dup (?))
N   dd ?
T   dd ?
Min dd 1000
A   db M dup (?)
B   db M dup (?)


.code
Start:
   ConsoleTitle " Копирование массива 1). rep movsb 2). mov"
   clrscr

; Минимум
   mov  ebx,Nmin
   mov  Min,0FFFFFFFh; Maxlongword
   cld
M00:
   rdtsc
   mov  T,eax;              Такты
   mov  edi,offset A 
   mov  esi,offset B
   mov  ecx,M
;rep movsb;                  A:=B
@@:lodsb
   cmp  al,100
   dec  ecx
   jnz  @B
   rdtsc
   sub  eax,T;              Такты
   cmp  Min,eax
   jb   @F
   mov  Min,eax
@@:dec  ebx
   jne  M00
   
   outword   M,,"Длина массива="
   outwordln Min,10,", Минимум тактов по rep movsb ="
   
L01:
; Минимум
   mov  ebx,Nmin
   mov  Min,0FFFFFFFh; Maxlongword
M01:
   rdtsc
   mov  T,eax;              Такты
   mov  edi,offset A 
   mov  esi,offset B
   mov  ecx,M
@@:
   mov  al,[esi]
;   mov  [edi],dl
   cmp  al,100
   inc  esi
;   inc  edi
   dec  ecx
   jnz  @B
   rdtsc
   sub  eax,T;              Такты
   cmp  Min,eax
   jb   @F
   mov  Min,eax
@@:dec  ebx
   jne  M01
   
   outword   M,,"Длина массива="
   outwordln Min,10,", Минимум тактов по циклу mov ="


exit
   ConsoleTitle "Суммирование матрицы"
   clrscr
   inint N,"Длина строки до 480=" 
L0:

; Минимум
   mov  edi,Nmin
M0:mov  Min,0FFFFFFFh; Maxlongword
   
   rdtsc
   mov  T,eax;              Такты

   mov  eax,N
   mul  N
   mov  ecx,eax;            N*N
   xor  ebx,ebx
L1:add  eax,X[4*ebx]
   inc  ebx
   dec  ecx
   jne  L1
   
   rdtsc
   sub  eax,T;              Такты
   cmp  Min,eax
   jb   @F
   mov  Min,eax
@@:dec  edi
   jne  M0
   
   outwordln eax,10,"Минимум тактов по строкам ="
   push eax
   mov  eax,N
   mul  eax;    N*N
   mov  edi,eax
   outwordln eax,10,"Число элементов матрицы=   "
   pop  eax
   cdq
   div  edi;     Число тактов на элемент
   outword eax,4,"Число тактов на элемент="
   mov  eax,edx
   mov  esi,10
   mul  esi;     edx=10*(0,n)
   cdq
   div  edi
   outchar '.'
   outwordln eax
   
;-------------------------------------------------   
; Минимум
   mov  edi,Nmin
M1:mov  Min,0FFFFFFFh; Maxlongword

   rdtsc
   mov  T,eax;              Такты

   mov  eax,0;              Сумма
   mov  edx,N;              N столбцов
L3:mov  ecx,N;              N строк
   lea  ebx,X[4*edx-4];     Эл-нт в первой строке
L4:add  eax,[ebx]
   add  ebx,N
   add  ebx,N
   add  ebx,N
   add  ebx,N;              На след строку
   dec  ecx
   jne  L4;                 цикл по столбцу
   dec  edx
   jne  L3;                 цикл по строке
   
   rdtsc
   sub  eax,T;              Такты
   cmp  Min,eax
   jb   @F
   mov  Min,eax
@@:dec  edi
   jne  M1
   
   outwordln eax,10,"Минимум тактов по столбцам="
   push eax
   mov  eax,N
   mul  eax
   mov  edi,eax;    N*N
   outwordln eax,10,"Число элементов матрицы=   "
   pop  eax
   cdq
   div  edi;     Число тактов на элемент
   outword eax,4,"Число тактов на элемент="
   mov  eax,edx
   mov  esi,10
   mul  esi;     edx=10*(0,n)
   cdq
   div  edi
   outchar '.'
   outwordln eax

   newline
   MsgBox " ","Повторить ?",MB_YESNO
   cmp  eax,IDYES
   je   L0
   
   exit  
   end Start