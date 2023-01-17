include ..\..\include\console.inc

COMMENT *
   ��������� ���������� � ������� ����� �������
   https://vxlab.info/wasm/article.php-article=GordonExcept.htm
   http://xaknotdie.org/defaced/5/d5%5B0x0e%5D.html
*

SetUnhandledExceptionFilter proto :dword

EXCEPTION_RECORD struc
   ExceptionCode         dd ?; ��� ����������
   ExceptionFlag         dd ?
; ExceptionFlag=0 - ����� ���������� ����, 
; =1 - ������ ���������� ����,
; =2 - �� ���� (������) ����������� �� ��� ������ (�������� ���� � �.�)
   NestedExceptionRecord dd ?
   ExceptionAddress      dd ?; ����� �������, ��������� ����������
   NumberParameters      dd ?; ����� dd � ���� AdditionalData
   AdditionalData        dd 5 dup (?)
EXCEPTION_RECORD ends

COMMENT * ���� ��������� ����������
  C0000005h (EXCEPTION_ACCESS_VIOLATION)
		������� ������� ��� �������� � ������, �� ���� �� �� ����������� ����
  C000001Dh � ������� �������� ���������� � �������� �������� ������
  C000008Ch (STATUS_ARRAY_BOUNDS_EXCEEDED)
            � ������� ������������ �������� �������� �� ��������� BOUND
  C0000094h (EXCEPTION_INT_DIVIDE_BY_ZERO)
		������� �������� ����� ������ ���� �� 0
  C0000095h (EXCEPTION_INT_OVERFLOW)� ������� �������� � ������������� ������������� (ax=20000 div bl=2)
  C00000FDh (EXCEPTION_STACK_OVERFILOW)
		����, ���������� ������, ��������
  80000001h � ������� ���������� � �������� ������ � ��������� ������ PAGE_GUARD
              �������� ���������� ���������, � ������������ ������ ����������
  80000003h (EXCEPTION_BREAKPOINT)
		����� ����������, �������������� �������� INT3
  80000004h - EXCEPTION_SINGLE_STEP �� TF=1 (��������� ��������� �������)

	    (EXC�PTION_ILLEGAL_INSTRUCTION)
		������� � �������������� ����� ��������
	    (EXCEPTION_PRIV_INSTRUCTION)
		������� ��������� ����������������� �������
	    (EXCEPTION_SINGLE_STEP)
		���������� TF=1
  .........   ������ ���� � ��������� ��� ��������, ������ ������ ����������
*

; �������� ������ ����������� ������
CONTEXT struc
   Context_flags dd ?;                 ��� �� ����������
   DEBUG_REGS    dd 6 dup (?);         ��� �� ����������
   FPU_regs      db (8Ch-1Ch) dup (?); ��� �� ����������
; �������� ���� ��������� � ����� ����������
   gs_reg     dd ?
   fs_reg     dd ?
   es_reg     dd ?
   ds_reg     dd ?
   edi_reg    dd ?
   esi_reg    dd ?
   ebx_reg    dd ?
   edx_reg    dd ?
   ecx_reg    dd ?
   eax_reg    dd ?
   ebp_reg    dd ?
   EIP_reg    dd ?
   cs_reg     dd ?
   EFLAGS_reg dd ?
   esp_reg    dd ?
   ss_reg     dd ?
CONTEXT ends

.data
   X  dd ?

.code
Start:
   ConsoleTitle " �������� � ��������� ����������"
   clrscr
   
   push MyException;    ��� ���������� !!!
   call SetUnhandledExceptionFilter
   
;  ������� ����������

   mov  ax,10
   mov  cl,0
   newline
   outint ax,,"ax="
   outint cl,,", cl="
   outstrln ". ������� div cl"
   pause "����� ������ �� ���� ! ..."
   div  cl
   outintln cl,,"cl="
   outintln al,,"ax div cl="
   newline
   pause "����� ������..."
   exit  

CONT:
   newline
   outstrln " ����� ������� �� ���� ������� �� ����� CONT"
   newline
   pause "����� ������..."
   exit  
; ---------------------------------------------------------
; ���������� ���������� ���������� UnhandledExceptionFilter
; �� ���� �� ��� ������ ������

MyException proc 
   newline 2
   SetTextAttr Yellow
   outstrln " ��������� ���������� !"
   mov  ebx,[esp+4];    ����� EXCEPTION_POINTERS
   mov  eax,[ebx];      ����� EXCEPTION_RECORD
   mov  eax,[eax];      ExceptionCode
   outnumln eax,,X," ��� ���������� = "
   cmp  eax,0C0000094h; ������� �� ���� ?
   jne  @F
   outstrln " ������� �� ���� !"
   newline
@@:   
   SetTextAttr
   mov  ebx,[ebx+4];    ����� CONTEXT
   outnumln [ebx].CONTEXT.EIP_reg,,X, \
            " ������� EIP ��������� �� (div cl) = "
   newline
   
   MsgBox "������� �� cl=0 !","���������� ���� � cl=5 ?", \
          MB_YESNO+MB_ICONEXCLAMATION
   cmp eax,IDYES
   jne @F
   mov  [ebx].CONTEXT.ecx_reg,5; cl:=5
   mov eax,-1; ���������� ���� � ����������� �����
   ret 4
@@:
   MsgBox "������� �� ���� !","���������� ���� � ����� CONT ?", \
          MB_YESNO+MB_ICONEXCLAMATION
   cmp eax,IDYES
   jne @F
   mov [ebx].CONTEXT.EIP_reg,CONT; EIP:=offset CONT
   mov eax,-1; ������������ �������� � ����������� ����
   ret 4
@@:
   mov eax,0; ���������� ��������� � ����������� �������� ���������

; eax=-1 ������������� �������� � ���������� ���������� ���������.
; eax= 1 �� ���������� ��������� � ����������� �������� ���������.
; eax= 0 ���������� ��������� � ����������� �������� ���������.

   ret 4; ��� ���� ��������, ������ �� EXCEPTION_POINTERS

MyException endp

   end Start