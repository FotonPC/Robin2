include console.inc

COMMENT *

   ��������� ���������

*
.data
x dd ?
.code
Start:
   ClrScr
   ConsoleTitle "  ��������� ���������"
DEBUG = 1
ifdef DEBUG
   outstrln 'Hi'
endif

;   k = 0FFFFFFFFh
;   k = -1
k equ -1
; �������������� "�����" ����������� k=0FFFFFFFh
if k LT 0
   outnumln k,,x
else
   outnumln k,,X
   k = -1
endif

   MsgBox "����� ������","��������� ��������� ?",MB_YESNO+MB_ICONQUESTION
   cmp  eax,IDYES
   je   Start
   exit
   end Start