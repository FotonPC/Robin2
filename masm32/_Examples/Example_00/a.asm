include console.inc

COMMENT *
   ���� ������ ����� � ����� ����� ��� ����
*

Rec record a:31,b:1

MaxLongint equ 80000000h
M macro
  local K
  K=0
  K=K+1
  outintln K
  endm

_DATA  segment para public 'DATA'
   X   dd ?
   Sum db ?; ����� ����
   Y   sbyte 1
 Xesp  dw 0FFFFh
   Z   byte ?
   T   db "ASDFGHJKL",0
   FZF db ?
   FSF db ?
   FCF db ?
   FOF db ?
_DATA  ends

_TEXT  segment para public 'CODE'
Start:
   GotoXY 10,10
   Pause    '�����, �������...'
   ConsoleTitle "   ���� ������ �����, ����� ����� ��� ����"
Begin:
   clrscr
   newline 2
   mov   Sum,0
   outstr '������� ����� X='
   inintln X
   jnc   @F
   outstrln '������� ������� �����!'
   jmp   Next
@@:jnz   @F
   pushfd
   outstrln '������� ����� ������ ����!'
   popfd
@@:jns   @F
   outstrln '������ ����� ������� ������ �����!'
@@:mov   ebx,10
   mov   eax,X
L: cdq
   idiv  ebx
L1:neg   edx
   js    L1; edx:=abs(edx)
   add   Sum,dl; Sum:=Sum+�����
   cmp   eax,0
   jne   L
   outwordln Sum,,"����� ����="

Next:
   MsgBox "����� ���������","������� ��� ���?",  \
          MB_YESNO+MB_ICONQUESTION
   cmp   eax,IDYES
   outwordln eax,,'EAX='
   je    Begin

   exit
_TEXT  ends
   end Start