include console.inc

COMMENT *

   ���� ������ �� �����,
   ����� ���������� ���� � ������

*

.data
   cc  db ?
   N   dd 0; ����� ����

.code
Start:
   ClrScr
   GotoXY 10,3
   ConsoleTitle "   ����� �������� ���� � ������ �� �����"
   newline 2
   outstrln '������� ����� �� �����:'
   mov  N,0
L: inchar cc
   cmp  cc,'0'
   jb   L1 
   cmp  cc,'9'
   ja   L1 
   inc  N
L1:cmp  cc,'.'
   jne  L
   newline
   SetTextAttr Yellow
   outstr "����� ���� � ������="
   outwordln N
   SetTextAttr
   MsgBox " ����� ���������", \
          <"���������",13,10,"���������",13,10,"� ������ ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp  eax,IDYES
   je   Start
   exit
   end Start