include console.inc

COMMENT *
   ���������� ������
*

SelfModify macro
      echo Old Macros Modify
  SelfModify macro p:=<y>
      echo New Macros Modify
    SelfModify macro
      echo Once More Macros Modify
    endm
  endm
endm

Maxn macro x:vararg
     mov eax,80000000h
for i,<x>
     local L
     cmp eax,i
     jge L
     mov eax,i
L:
endm
     exitm <eax>
     endm

.data

.code
Start:
   ConsoleTitle "   �������������������� MACRO"
echo
   SelfModify
   SelfModify
   SelfModify
   SelfModify
echo
Pause "������� �������..."
   ClrScr
   ConsoleTitle "   MACRO-������� � ���������� ������ ����������"
   k=0
   mov eax,0
   outintln Maxn(1,2,4)
.Listall
   while k LT 3
      local L
      k=k+1
L: outintln k
   endm

   exit

   MsgBox " ����� ���������", \
          <"���������",13,10,"���������",13,10,"� ������ ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp eax,IDYES
   je  Start
   
KOH:   
   exit
   end Start
