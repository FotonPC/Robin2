include console.inc

COMMENT *
    ������ ��������� �� ������
*
GetLastError proto
FormatMessageA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FormatMessage equ <FormatMessageA>
FORMAT_MESSAGE_FROM_SYSTEM equ 1000h

LastError macro
    local ErrTxt
.data
    ErrTxt db 1024 dup (?)
.code    
    pushad
    pushfd
    invoke GetLastError
    mov edi,eax
    invoke FormatMessage,FORMAT_MESSAGE_FROM_SYSTEM,
                         NULL,edi,0,offset ErrTxt,1024,NULL
    MsgBox "��������� ������ : ",offset ErrTxt,MB_OK

    popfd
    popad
    
endm

MessageBeep proto :dword
Beep proto :dword, :dword

.data

.code
Start:
Comment *
    mov  ebx,MB_OK
@@: 
    outwordln ebx
    invoke MessageBeep,ebx
    outchar bl
;    pause "..."
;    jmp  @B
exit
*

   ClrScr
   ConsoleTitle "   ���� � ����� ������� ����"

newline
inchar al,"������� ���� ������ = "
outstr "����� ������ = "
ConsoleMode
outchar al
newline
ConsoleMode
outchar 'D',"��� ��������� ����� D = "
newline
outchar '�',"��� ������� ����� � = "
newline


exit   
   LastError
   pause "......."
   
   exit
   end Start