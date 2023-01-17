include console.inc

COMMENT *
   Выдача марки процессора
   http://www.manhunter.ru/assembler/773_kak_na_assemblere_poluchit_stroku_nazvaniya_processora.html
*

.data
   buf db 128 dup (?) 
.code
Start:
   ClrScr
   ConsoleTitle "   Выдача марки процессора"
   Newline 3

   mov   esi,offset buf
   mov   edi,esi
   cld
; Прочитать информацию о процессоре
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
; Привести строку к формату ASCIIZ
   xor   eax,eax 
   stosb
   outstr "Процессор = "
   SetTextAttr Yellow
   outstrln offset buf
   SetTextAttr

   MsgBox " Конец программы", \
          <"Выключить монитор ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp eax,IDNO
   je  KON

; "Выключить" монитор (до кнопкм или мышки)
HWND_BROADCAST  equ 0FFFFh
WM_SYSCOMMAND   equ 112h
SC_MONITORPOWER equ 0F170h
SendMessageA PROTO :DWORD,:DWORD,:DWORD,:DWORD
SendMessage equ <SendMessageA>
   invoke  SendMessage,HWND_BROADCAST,WM_SYSCOMMAND,SC_MONITORPOWER,2

KON:
   exit

   MsgBox " Конец программы", \
          <"Повторить",13,10,"программу",13,10,"с начала ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp eax,IDYES
   je  Start
   
KOH:   
   exit
   end Start
