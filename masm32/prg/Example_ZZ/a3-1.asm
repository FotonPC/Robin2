include console.inc
COMMENT *
  ������ �� ����������
*

     public Pdb,Pdw,Pdd,Pi32
Pi32 equ  010101

.data
   Pdb  db 11
   Pdw  dw 2222
   Pdd  dd 33333333

; ������� ����� �� a3-2.asm 
     extrn Qdb:byte, Qdw:word, Qdd:byte
     extrn Qtxt:byte, Qi32:abs; abs - ������ i32
     extrn N:abs; N = 10101
     
.code
start:
; ��������� ���� �������
   ClrScr
   ConsoleTitle "  ������������� ��������� �� ����������"
   newline 2

   outintln Qdd,,'Extrn Qdd �� a3-2.asm='
   outintln Qi32,,'Extrn Qi32 �� a3-2.asm='
   outintln N,,'Extrn N=10101 �� a3-2.asm='
   outstrln offset Qtxt

   mov   bl,-99
   xor   eax,eax
   mov   al,bl
   push  eax 
   extrn QQ@0:near
   call  QQ@0
   SetTextAttr Yellow

L: outintln al,,'al �� QQ �� a3-1.asm='
   SetTextAttr
   
   exit

;==============================================
     public P,PP
P    proc  uses eax ebx, par1:dword,par2:byte
     local loc1,loc2:dword

;  ������������� ����������� �������:
;    push ebp;     55
;    mov  ebp,esp; 8B EC
;    sub  esp,8;   83 EC 08
;    push eax;     50
;    push ebx;     53

;  ��������� ������� ���������:
;loc1 equ  dword ptr [ebp-4]
;loc2 equ  dword ptr [ebp-8]
;par1 equ  dword ptr [ebp+8]
;par2 equ  dword ptr [ebp+12]
    inc eax
    inc ebx
; ����� ret ������������� ����������� �������:
;   pop  ebx;     5B
;   pop  eax;     58
;   mov  esp,ebp; 8B E5  ����������� local p1,p2
;   pop  ebp;     5D
;   ret  8;       C2 00 08

     ret
P    endp

PP   proc
     push ebp
     mov  ebp,esp

     pop  ebp
     ret
PP   endp

end  start
