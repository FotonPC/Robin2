include console.inc

COMMENT *
   ���� ������ ����� �� N 1 �� 100, ����� ���� �������
   X: array[1..N] of longint;
   ����� max X[i], ������� ������ X[N], � ���� �����
   ���, �� ����� "����� ����� ���!". ����� ����������� � �������
   function MaxGtLast(var X:Mas; N:Longword):Longint; 
*

MinLongint equ 80000000h

.data
   M    dd 100 dup (?)
   Nmax dd ?
   Y    dd ?
   T    db "������������ �� �����, ������� ���������� = ",0

.code
MaxGtLast proc
     push ebp
     mov  ebp,esp
     push ebx
     push ecx
@Last equ  edx
     push edx
@X   equ  dword ptr [ebp+8];  ����� X[1]
@N   equ  dword ptr [ebp+12]; �����
     mov  ebx,@X;             ����� X[1]
     mov  ecx,@N
     mov  @Last,[ebx+4*ecx-4]
     dec  ecx
     mov  eax,MinLongint
@L0: cmp  [ebx],@Last
     jge  @L1
     cmp  eax,MinLongint
     jne  @L2
     mov  eax,[ebx];          ������ X[i] ������ Last
     jmp  @L1
@L2: cmp  eax,[ebx]
     jge  @L1;                eax >= X[i]
     mov  eax,[ebx];          �� ������ X[i] ������ Last
@L1: add  ebx,4;              i:=i+1
     loop @L0
     pop  edx
     pop  ecx
     pop  ebx
     pop  ebp
     ret  8
MaxGtLast endp
;----------------------------------
Start:
     clrscr
     GotoXY 10,3
     ConsoleTitle "    MAX  ��  X[i],  �������  X[N]"
     newline 2
     inint Nmax,' ������� ����� ������� N ������ 100 � N ������ 1 : '
     mov   ecx,Nmax
     mov   ebx,0;    i:=1
     cmp   ecx,100
     jg    L0
     cmp   ecx,1
     jg    L1
L0:  MsgBox "������ �����","��������� ��� ��� ?",MB_RETRYCANCEL+MB_ICONQUESTION
     cmp  eax,IDRETRY
     je   Start
     exit
L1:  outword Nmax,,"������� ������ �� "
     outstrln " ����� :"
L2:  inint M[4*ebx]
     inc   ebx;      i:=i+1
     loop  L2
     push  Nmax
     push  offset M
     call  MaxGtLast
.if  eax==MinLongint
     SetTextAttr Yellow
     outstrln "����� ����� ���!"
     SetTextAttr
.else
     outintln eax,,offset T
.endif
     newline
     MsgBox "����� ������","��������� ��� ���� ������ ?",MB_YESNO+MB_ICONQUESTION
     cmp  eax,IDYES
     je   Start

     exit
     end Start