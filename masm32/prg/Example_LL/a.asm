include console.inc

COMMENT *
   ��������� ECX ����� ���������
*

.data
.code
Start:
   ClrScr
   ConsoleTitle "   ��������� ECX-�� ����� ���������"
   Newline 3

   xor  eax,eax
  
   mov  edx,1
   inint ecx,"ecx="
L: xadd eax,edx
   loop L
   outwordln eax

   neg  eax
   sbb  eax,eax
   neg  eax
   outwordln eax

   MsgBox " ����� ���������", \
          <"���������",13,10,"���������",13,10,"� ������ ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp eax,IDYES
   je  Start
KOH:   
   exit
   end Start
