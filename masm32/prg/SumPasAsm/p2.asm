.386
.model flat,stdcall
option casemap:none

Comment * ������ p2.asm
   ������������ �������, �������� ������.
   � �������� end �� ����� ����� Start
*
.code
   public Sum;         ������� ��� _Sum@0

   externdef  Error: byte; ������� ��� _Error
;   extrn  Error: byte; ������� ��� _Error
Sum proc
   push ebp
   mov  ebp,esp
   push ecx
   push ebx
   mov  Error,-1;     Error:=true  
   mov  ebx,[ebp+8];  ����� �[1]
   mov  ecx,[ebp+12]; N
   xor  eax,eax;      Sum:=0
L: add  eax,[ebx];    Sum:=Sum+A[i]
   jo   Voz;          ��� ������������
   add  ebx,4;        i:=i+1
   loop L
   mov  Error,0;      Error:=false
Voz:
   pop  ebx
   pop  ecx
   pop  ebp
   ret  8
Sum endp
   end
