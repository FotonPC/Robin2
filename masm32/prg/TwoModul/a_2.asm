include console.inc

COMMENT *
    Функция
       Function Q(a,b:Longint):Longint;
    вызывается из Free Pascal
*

.data
      public xAsm; from Free Pascal
xAsm  dd 55555
      extrn xPas:dword; xPas из TwoModul.pas
      extrn F@0:proc;   F    из TwoModul.pas

;xPas  dd 33333

.code
    public Q; Function Q(a,b:Longint):Longint;
Q   proc
    ??SaveReg
    ConsoleTitle 'a_2: работает процедура Q из a_2.asm'
    SetTextAttr Yellow
;   ClrScr
    outstrln "В модуле a_2.asm !!!"
    newline 2
    outintln xPas,,"xPas from TwoModul.pas="
    call     F@0
    outintln eax,,"F from TwoModul.pas="
;   ReadKey "ReadKey:="; _wait_key@0
    new
    OutDateln "Дата="
    OutTimeln "Время="
;   Randomize
    mov    al,'#'
    inchar al,"Ввод символа al="
    outcharln al,"Outcharln: al="
    inchar al
    outcharln al,"Outcharln: ah="
    mov    eax,-11111
    inint  eax,"eax="
    outintln eax,,"Outintln: eax="
    inchar al,"Ввод символа al="
    outcharln al,"Outcharln: al="
    SetTextAttr
;    MsgBox "Конец функции","Нажмите ОК",MB_OK+MB_ICONQUESTION
    ??RestoreReg

    push ebp
    mov  ebp,esp
    push ebx
a   equ  dword ptr [ebp+8]
b   equ  dword ptr [ebp+12]
    mov  eax,xPas; xPas из TwoModul.pas
    add  eax,b
    add  eax,a
    pop  ebx
    pop  ebp
    ret  8
Q   endp
;=============================
Start:
    push 11111
    push 22222
    call Q
;    pause "Конец a_2.asm"
    exit
    end   Start
