include console.inc

COMMENT *
   ���� ������ �����, ����� ��� ����������� ����,
   ��������, -1234 => 4321-
   �������� ���� ��� �������� ����� = MinLongint
*

.data
   X   dd ?
   Y   dd ?
Z dw ?
.code
Begin_of_program:
   clrscr
   GotoXY 10,3
   ConsoleTitle "  ����� ����������� ���� ������ �����"
   newline 2
   inintln X,' ������� �����  X = '
   jc   Error
   jns  L0
   pushfd
   outstrln "������ ����� ������� ������ �����!"
   popfd
L0:jz   Minus
   outstr ' ���������� ��� X = '
   mov  ebx,10
   mov  eax,X
M: mov  edx,0; ����������� �����
   div  ebx
   outword dl; ��������� �����
   cmp  eax,0
   jne  M
   jmp  L2
Minus:
   outstr ' ���������� ��� X = '
   mov  ebx,10
   mov  eax,X
   mov  Y,eax
L: cdq
   idiv  ebx
L1:neg  edx
   js   L1;    abs(��������� �����)
   outword dl; ��������� �����
   cmp  eax,0
   jne  L
   cmp  Y,0
   jge  L2
   outchar '-' 
L2:
   newline
   MsgBox "����� ������","��������� ��� ���� ����� ?",MB_RETRYCANCEL+MB_ICONQUESTION
   cmp  eax,IDRETRY
   jne  KOH
;   flush
   jmp  Begin_of_program
Error:
   outstrln "������� ������ ����� �����!"
   jmp  L2
KOH:
   exit
   end Begin_of_program