include console.inc

COMMENT *
   Отладочный модуль
*
;includelib "\masm 6.14\lib\masm32.lib"

SetWindowLongA PROTO hWnd:DWORD, nIndex:DWORD, dwNewLong:DWORD
GetWindowLongA PROTO hWnd:DWORD, GWL_WNDPROC:DWORD

WS_CAPTION  equ 0C00000h

.data
  GWL_STYLE dd ?
  hWnd      dd 0
  X         dd ?

.code
Start:
    mov  eax,80000000h; <0
    and  eax,0
    jns  @F
    outstrln "SF=1"
@@:
pause "..."
exit

@@: inint X,"X="
    mov  eax, 66666667h;1/10; Знак&беззн sar edx,2
mov ecx,1717986919
;    mov  eax, 33333334h;1/20; Знак&беззн sar edx,2
;    mov  eax,0CCCCCCCDh;1/5 Б/З shr edx,2
;    mov  eax, 66666667h;1/5 З/Н sar edx,1
;    mov  eax,55555556h;1/3; Знак&беззн sar edx,0

    imul  X
    sar  edx,2
    shl  X,1; знаковый бит в CF:=SF
    adc  edx,0
    mov  X,edx
    outintln X,,"X div 10 = "
    cmp  X,0
    jnz  @B
exit
Pause
    invoke GetWindowLongA,NULL,GWL_STYLE ; получение информации об окне
outintln eax,,"eax="
    and eax,not WS_CAPTION ; удаление WS_CAPTION
    invoke SetWindowLongA,NULL,GWL_STYLE,eax ; установка свойств окна

    exit
    end Start
