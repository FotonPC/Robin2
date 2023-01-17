include ..\..\include\console.inc

COMMENT *
   ������������ �������
   ����������� �������
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
   ConsoleTitle " ����������� ������� 1). rep movsb 2). mov"
   clrscr

; �������
   mov  ebx,Nmin
   mov  Min,0FFFFFFFh; Maxlongword
   cld
M00:
   rdtsc
   mov  T,eax;              �����
   mov  edi,offset A 
   mov  esi,offset B
   mov  ecx,M
;rep movsb;                  A:=B
@@:lodsb
   cmp  al,100
   dec  ecx
   jnz  @B
   rdtsc
   sub  eax,T;              �����
   cmp  Min,eax
   jb   @F
   mov  Min,eax
@@:dec  ebx
   jne  M00
   
   outword   M,,"����� �������="
   outwordln Min,10,", ������� ������ �� rep movsb ="
   
L01:
; �������
   mov  ebx,Nmin
   mov  Min,0FFFFFFFh; Maxlongword
M01:
   rdtsc
   mov  T,eax;              �����
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
   sub  eax,T;              �����
   cmp  Min,eax
   jb   @F
   mov  Min,eax
@@:dec  ebx
   jne  M01
   
   outword   M,,"����� �������="
   outwordln Min,10,", ������� ������ �� ����� mov ="


exit
   ConsoleTitle "������������ �������"
   clrscr
   inint N,"����� ������ �� 480=" 
L0:

; �������
   mov  edi,Nmin
M0:mov  Min,0FFFFFFFh; Maxlongword
   
   rdtsc
   mov  T,eax;              �����

   mov  eax,N
   mul  N
   mov  ecx,eax;            N*N
   xor  ebx,ebx
L1:add  eax,X[4*ebx]
   inc  ebx
   dec  ecx
   jne  L1
   
   rdtsc
   sub  eax,T;              �����
   cmp  Min,eax
   jb   @F
   mov  Min,eax
@@:dec  edi
   jne  M0
   
   outwordln eax,10,"������� ������ �� ������� ="
   push eax
   mov  eax,N
   mul  eax;    N*N
   mov  edi,eax
   outwordln eax,10,"����� ��������� �������=   "
   pop  eax
   cdq
   div  edi;     ����� ������ �� �������
   outword eax,4,"����� ������ �� �������="
   mov  eax,edx
   mov  esi,10
   mul  esi;     edx=10*(0,n)
   cdq
   div  edi
   outchar '.'
   outwordln eax
   
;-------------------------------------------------   
; �������
   mov  edi,Nmin
M1:mov  Min,0FFFFFFFh; Maxlongword

   rdtsc
   mov  T,eax;              �����

   mov  eax,0;              �����
   mov  edx,N;              N ��������
L3:mov  ecx,N;              N �����
   lea  ebx,X[4*edx-4];     ��-�� � ������ ������
L4:add  eax,[ebx]
   add  ebx,N
   add  ebx,N
   add  ebx,N
   add  ebx,N;              �� ���� ������
   dec  ecx
   jne  L4;                 ���� �� �������
   dec  edx
   jne  L3;                 ���� �� ������
   
   rdtsc
   sub  eax,T;              �����
   cmp  Min,eax
   jb   @F
   mov  Min,eax
@@:dec  edi
   jne  M1
   
   outwordln eax,10,"������� ������ �� ��������="
   push eax
   mov  eax,N
   mul  eax
   mov  edi,eax;    N*N
   outwordln eax,10,"����� ��������� �������=   "
   pop  eax
   cdq
   div  edi;     ����� ������ �� �������
   outword eax,4,"����� ������ �� �������="
   mov  eax,edx
   mov  esi,10
   mul  esi;     edx=10*(0,n)
   cdq
   div  edi
   outchar '.'
   outwordln eax

   newline
   MsgBox " ","��������� ?",MB_YESNO
   cmp  eax,IDYES
   je   L0
   
   exit  
   end Start