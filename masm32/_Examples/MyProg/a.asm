include console.inc

COMMENT *

   ��������� ���������

*
.data


.code
Start:
   ClrScr
   ConsoleTitle "  ��������� ���������"

   MsgBox "����� ������","��������� ��������� ?",MB_YESNO+MB_ICONQUESTION
   cmp  eax,IDYES
   je   Start
   exit
   end Start