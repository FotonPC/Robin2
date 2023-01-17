include console.inc

COMMENT *
    Выдача сообщения об ошибке
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
    MsgBox "Последняя ошибка : ",offset ErrTxt,MB_OK

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
   ConsoleTitle "   Ввод и вывод русских букв"

newline
inchar al,"Введите один символ = "
outstr "Введён символ = "
ConsoleMode
outchar al
newline
ConsoleMode
outchar 'D',"Вот латинская буква D = "
newline
outchar 'Ж',"Вот русская буква Ж = "
newline


exit   
   LastError
   pause "......."
   
   exit
   end Start