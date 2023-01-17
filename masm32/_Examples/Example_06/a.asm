include console.inc

Comment & 
    ��������� ��� ��������� "������� �� ���� ����� �� ������"
    ������ ��������� ������������ �������� ������� � ��������
    ������ � ��������� ���������
    �������
    =======
    �������� "�������" ����� (������ ����������� �������) �
    "���������", ��������. �������, ������� �� ������� ��
    ���������. �������� ��������, �� ����� �� "���������"
    ���� ��� �������.
    ����������. "�������" ������� ������� ������,
    � "�� �������" - �������. ������ ����� �� ������.
    �������, ����� ��������� �����������, ��������� �� ��� ���� ����� 
&

.const 
   otvet db '�� �������',0
.data 
   X dd ?
   Y db ?

.code	
Start:
   ClrScr
   ConsoleTitle "   �������� ��������� X (dd) �� Y (db)"
   newline 3
   inint X,"������ ����� X = "
   inint Y,"������ ����� Y (�� -128 �� +127) = "
   cmp   Y,0
   jne   @F
   outstrln "Y = 0"
   je    Povtor
@@:
   cmp   Y,1
   jne   @F
   outstrln "Y = 1"
   je    Povtor
@@:
   cmp   Y,-1
   jne   @F
   outstrln "Y = -1"
   je    Povtor
@@:
   mov   eax,X
   cdq;        <edx,eax>:=itn64(X)
   movsx ebx,Y; ebx:=Longint(Y) 
   idiv  ebx
   cmp   edx,0
   jne   @F
   SetTextAttr LightGreen
   outstrln "X ������� �� Y"
   SetTextAttr
   jmp   Povtor
@@:
   SetTextAttr LightRed
   outstrln "X �� ������� �� Y"
   SetTextAttr
Povtor:
   MsgBox " ����� ���������","��������� ?", \
          MB_YESNO+MB_ICONQUESTION
   cmp  eax,IDYES
   je   Start
   exit
   end Start