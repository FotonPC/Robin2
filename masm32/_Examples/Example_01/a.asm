include console.inc

COMMENT *
   ���� ������ ����� � ����� ����� ��� ����
*

.data
   X   dd  1
   Sm  dd 0 dup (?)
   Sum db ?; ����� ����
   T   dq 10
   Y   dw -2078
   Z   real4 ?
   
MaxLongint equ 80000000h

.code
Start:
   GotoXY 10,10
;Debug:
ifdef Debug
   outstrln 'Debug'
endif
   Pause    '�����, �������...'
   ConsoleTitle "   ���� ������ �����, ����� ����� ��� ����"
Begin:
   clrscr
   newline 2
   mov   Sum,0
   outstr '������� ����� X='
   inintln X
OutFlags
   jnc   @L
   cmp   X,0
   jne   @F
   outstrln '������ ������� ����� !'
   jmp   Next
@@:
   outstrln '������� ������� �����!'
   jmp   Next
@L:jnz   @F
   pushfd
   outstrln '������� ����� ������ ����! ZF=1'
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
;   outint Sum,,"Sum="
;   pause "  Press Enter..."
   cmp   eax,0
   jne   L
   outwordln Sum,,"����� ����="

Next:
   MsgBox "����� ���������",                            \
          <"������� ��� ���?",13,10,"��� �� �������?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp   eax,IDYES
   je    Begin

   exit 1

.data
msg    db  'Hello, world!',0
len    equ $-msg
Params dd  1;          �������� ���������� (stdout)  
       dd  msg;        ����� ���������
       dd  len;        ����� ���������
.code
Pech:
Comment # 
   mov  edx,len;        ����� ��������� 
   mov  ecx,offset msg; ��������� ��� ������ �� �����
   mov  ebx,1;          �������� ���������� (stdout)
   push Vozv    
   push ecx
   push edx
   push ebp
   mov  ebp,esp
   syscall
   xor  eax,eax;        ������������
Vozv:   
   ret
#
   mov  eax,4;          ����� ���������� ������ (sys_write)
   lea  edx,Params;     ������ �� ������ ���������� 
   int 2Eh;             ��������� �����
   exit
   end Start
