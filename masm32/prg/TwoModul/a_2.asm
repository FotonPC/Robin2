include console.inc

COMMENT *
    �������
       Function Q(a,b:Longint):Longint;
    ���������� �� Free Pascal
*

.data
      public xAsm; from Free Pascal
xAsm  dd 55555
      extrn xPas:dword; xPas �� TwoModul.pas
      extrn F@0:proc;   F    �� TwoModul.pas

;xPas  dd 33333

.code
    public Q; Function Q(a,b:Longint):Longint;
Q   proc
    ??SaveReg
    ConsoleTitle 'a_2: �������� ��������� Q �� a_2.asm'
    SetTextAttr Yellow
;   ClrScr
    outstrln "� ������ a_2.asm !!!"
    newline 2
    outintln xPas,,"xPas from TwoModul.pas="
    call     F@0
    outintln eax,,"F from TwoModul.pas="
;   ReadKey "ReadKey:="; _wait_key@0
    new
    OutDateln "����="
    OutTimeln "�����="
;   Randomize
    mov    al,'#'
    inchar al,"���� ������� al="
    outcharln al,"Outcharln: al="
    inchar al
    outcharln al,"Outcharln: ah="
    mov    eax,-11111
    inint  eax,"eax="
    outintln eax,,"Outintln: eax="
    inchar al,"���� ������� al="
    outcharln al,"Outcharln: al="
    SetTextAttr
;    MsgBox "����� �������","������� ��",MB_OK+MB_ICONQUESTION
    ??RestoreReg

    push ebp
    mov  ebp,esp
    push ebx
a   equ  dword ptr [ebp+8]
b   equ  dword ptr [ebp+12]
    mov  eax,xPas; xPas �� TwoModul.pas
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
;    pause "����� a_2.asm"
    exit
    end   Start
