include console.inc

COMMENT *
   ���������� �� ������ ���������.
   ���� ������ �����, ����� ��� ����������� ����,
   ��������, -1234 => 4321-
   �������� ���� ��� �������� ����� = MinLongint
*

.data
   X   dd ?
   Y   dd ?

.code
Begin_of_program:

;   extrn FreeConsole@0:near,AllocConsole@0:near
;   call FreeConsole@0
;   call AllocConsole@0 

NewConsole

   settextattr
   clrscr
   GotoXY 10,3
   ConsoleTitle "  ����� ����������� ���� ������ �����"
   newline 2
   inint X,' ������� ����� X = '
   outstr ' ���������� ���  = '
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

KOH:

   settextattr 16*Blue+Yellow

   exit
   end Begin_of_program