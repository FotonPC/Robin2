include console.inc

.data
buf db 0,0,0
_10 dd 10

.code
inint_proc proc
; �奬� ��୥�
     push  ebx
     push  ecx
     push  edx
     mov   buf+1,0;   ��� �� �뫮 ᨬ����� �᫠
     mov   buf+2,0;   ��訩 ����� ���ᥬ� (spaces,CR,LF)
     xor   ebx,ebx;   ����� �ନ�㥬 x
@MM: invoke StdIn,offset buf,1; ���� ᨬ���
     cmp   buf,' '
     jne   @M1
     cmp   buf+1,0
     je    @MM;       ��� �� �뫮 ᨬ����� �᫠
     jmp   KOH;       �஡�� - ����� ���ᥬ�
@M1: cmp   buf,13;    CR
     jne   @M11
     cmp   buf+1,0
     je    @MM;       CR, �� ��� �� �뫮 ᨬ����� �᫠
     jmp   KOH;       CR - ����� �᫠
@M11:cmp   buf,10;    LF
     jne   @M2
     cmp   buf+1,0
     je    @MM;       LF, �� ��� �� �뫮 ᨬ����� �᫠
     jmp   KOH;       LF - ����� ��ப� � �᫠ (⠪ �� �뢠��!)
@M2: cmp   buf,'-'
     jne   @M3
     cmp   buf+1,0
     jne   KOH1;      ����� ����� �᫠ - ���宩 ����� ���ᥬ�
     mov   buf+1,'-'; ����� ��। �᫮�
     jmp   @MM
@M3: cmp   buf,'+' 
     jne   @M4
     cmp   buf+1,0
     jne   KOH1;      ���� ����� �᫠ - ���宩 ����� ���ᥬ�
     mov   buf+1,'+'; ���� ��। �᫮�
     jmp   @MM
@M4: cmp   buf,'0'
     jb    KOH1;      �� ��� - ���宩 ����� ���ᥬ�
     cmp   buf,'9'
     ja    KOH1;      �� ��� - ���宩 ����� ���ᥬ�
     cmp   buf+1,0
     jne   @M5
     mov   buf+1,'+'; ��ࢠ� ��� �᫠, ����� �� �뫮
;    ���
@M5: mov   eax,ebx
     mul   _10
     jc    Error
     mov   ebx,eax;   x:=10*x 
     movzx eax,buf
     sub   eax,'0'
     add   ebx,eax;   x:=x*10+digit
     jc    Error
     cmp   buf+1,'-'; �� ����� ��। �᫮�
     jne   @MM;        �� �뫮 ����� ��। �᫮�
     cmp   ebx,80000000h;  
     jbe   @MM
;    ���宥 �᫮ � ������ �����
     jmp   Error
KOH1:mov   buf+2,1;   ���宩 ����� ���ᥬ� �᫠     
KOH: mov   eax,ebx
     cmp   buf+1,'-'
     jne   @M6
     neg   eax
@M6: cmp   buf+1,'-'; ZF:=1 => ���� "-", ���� ZF:=0
     clc            ; CF:=0 - �᫮ � ��������� dword
     pushfd
     and   byte ptr [esp],7Fh; SF:=0
     cmp   buf+2,0;   ���� ���ᥬ� ?  
     je    @M7
     or    byte ptr [esp],80h; SF:=1
@M7: popfd;         ���� 䫠�� CF=0, ZF � SF
@M8: pop   edx
     pop   ecx
     pop   ebx
     ret
Error:
     SetTextAttr Yellow
     outstrln "** inint: Number too big:=MaxLongint, CF:=1 **"
     SetTextAttr
     mov   eax,7FFFFFFFh; MaxLongint
     push  eax
     flush
     pop   eax
     stc;           CF:=1 - �訡��, ZF � SF �� ��।�����
     jmp  @M8
inint_proc endp
;---------------------------------

     end
