include console.inc

COMMENT *
   ������ ����� ����������
   http://www.manhunter.ru/assembler/773_kak_na_assemblere_poluchit_stroku_nazvaniya_processora.html
*

.data
   buf db 128 dup (?) 
.code
Start:
   ClrScr
   ConsoleTitle "   ������ ����� ����������"
   Newline 3

   mov   esi,offset buf
   mov   edi,esi
   cld
; ��������� ���������� � ����������
   mov   eax,80000002h
@@:
   push  eax
   cpuid
   stosd
   xchg  eax,ebx
   stosd
   xchg  eax,ecx
   stosd
   xchg  eax,edx
   stosd
   pop   eax
   inc   eax
   cmp   eax,80000004h
   jbe   @b
; �������� ������ � ������� ASCIIZ
   xor   eax,eax 
   stosb
   outstr "��������� = "
   SetTextAttr Yellow
   outstrln offset buf
   SetTextAttr

   MsgBox " ����� ���������", \
          <"��������� ������� ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp eax,IDNO
   je  KON

; "���������" ������� (�� ������ ��� �����)
HWND_BROADCAST  equ 0FFFFh
WM_SYSCOMMAND   equ 112h
SC_MONITORPOWER equ 0F170h
SendMessageA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SendMessage equ <SendMessageA>
   invoke  SendMessage,HWND_BROADCAST,WM_SYSCOMMAND,SC_MONITORPOWER,2

KON:
   exit

   MsgBox " ����� ���������", \
          <"���������",13,10,"���������",13,10,"� ������ ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp eax,IDYES
   je  Start
   
KOH:   
   exit
   end Start
