include console.inc

COMMENT *

   ������ � ��������.
������� �������� ����������� - ������� � ����� � ���������� matr
����� ������ �������� �������� �������� � ��� ���������� - ��������� ����� �������� ���������.

*
.const
 d equ 5  ;  ���������� �������� ������� 
 h equ 3  ;  ���������� ����� 
.data
matr dd 1, 2, 3, 4, 5
     dd 0, 0, 9, 8, 7
     dd 6,-5,-4,-3,-2 ; ����� ������ ��� �������� � ����� ������
.code
Start:
   ClrScr
   ConsoleTitle "�������"

; ������ �� ����� ���������� �������. ������� ��� �������� ������, ������������� ������ �������
     xor eax,eax   ;  ����� ����� �����
     xor ebx, ebx  ; ���������� ��������� �������, ����� ������ ������ � ������ ��������� 
     mov ecx, d*h ; ���������� ��������� � �������
  sum:   add eax, matr[ebx*type matr]
         inc ebx
         loop sum
     outintln  eax   ,,'����� ��������� ������� '


; ������ �� ����� ���������� �������, ������������� ���� ��������   
    outstrln '������ �������'
    xor ebp, ebp ; ��� �������� ����  ( ������ ������)
 r0 :   xor ebx, ebx ; ��� �������� �� ������ ������ (������ �������)
   r1:  outint matr[ebp][ebx],9
         add ebx, type matr; ������ ������� ������������� �� ������ �������� 
         cmp ebx, d*type matr 
          jne r1
       newline 
       add ebp, d*type matr ; ������ ������ ������������� �� ������ ������
       cmp ebp, d*h*type matr
       jne r0

; ���������� ������ �������� �� ��� �������
     inint  eax, '����� ������ '
     dec ax
     mov edx, d*type matr
     mul edx
     inint ebx,'����� ������� '
     dec ebx
     outintln  matr[eax][ebx*type matr] , , '�� ���� ����� ����� '


; ������ � ���������� �������. �������� ������ � �������   
     inint ebx, '������� ����� �������, ������� ���� ����������  '
     lea ebx, matr[ebx* type matr -type matr]; �������� ������� �������� ��������� �������
     mov ecx, h
     xor edx,edx
     sta: outint <dword ptr [ebx] [edx*type matr]>,8
          add edx,d ; ������ � �������� ��������� ������
          loop sta  
       newline 
   exit
   end Start