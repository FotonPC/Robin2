include console.inc

COMMENT *
   ������ � ��������.
   �������� ���� ������, � �������� ���������� ��� � �����
   ��� � ����. ������������ ����� �� ��������������.
   ��������� ��������������� ���� ������
*
.const
  LL   db  14,0,0,0; ���� ���� ������ � ������ - 14 ��������, ���� ����� ����� �������� � ������ � ���� byte � ���� dword
  day  db  '0 �����������',0,'1 �����������',0
       db  '2 �������    ',0,'3 �����      ',0
       db  '4 �������    ',0,'5 �������    ',0
       db  '6 �������    ',0
  
.code
Start:
   ClrScr
   ConsoleTitle "   ���������� ��� ������ �� ������ ��� � ����"

   DownloadFile "http://arch32.cs.msu.su/semestr2/Programm.pdf","c:\Temp\Programm.pdf"


   GotoXY 1,5
   outstrln '������� ����� ��� ������ ������� ��� ���� (0-6) = '
   mov   eAX, offset day;   ����� '1 �����������'
   mov   eCX, 7;            ���� �� 7 ����
Days:
   outstrln eAX;            ����� ��� ������ � �������
   add   eAX, dword ptr LL; �� ����. ���� ������
   dec   eCX
   jnz   Days
   newline
   inint eDX,"����� ��� ������ = "
   inint eAX,'������� ����� ��� � ���� (������� � 1) = '
   add   eAX, eDX
   dec   eAX 
   mov   DL, 7
; ���������� �������� �������, ��� ��� ��� ���������� �����
; ��������� ������ ���������� � ����, AH ������� �� 
; ������� - ����� ��� ������  
;   xor   eAX,eAX
   div   DL   
   mov   AL, AH  
   mul   LL ; � AX ����� �������, � ������� ���������� �������� ��� ������ � ������
   xor   eBX,eBX
   mov   BX,AX
; eBX - offset ��� ������ � day
   lea   eAX, day[eBX+2] ; +2 - ������� ����� ���
   outstr "���� ������ = "
   SetTextAttr Yellow
   outstrln eax
   SetTextAttr
   MsgBox " ����� ���������", \
          <"���������",13,10,"���������",13,10,"� ������ ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp  eax,IDYES
   je   Start
   exit
   end Start
