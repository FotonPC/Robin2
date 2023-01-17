include console.inc

COMMENT *
   ���� ����� �������� �� ��� ���, ���� �� ����� �������
   ������ ������. ������ ������ ����������� ��
   ����������� � ���������. ���������� �����������
   ����������
   procedure Sort(var X:array of char; N:byte); 
   begin { ���������� ���������� }
     for i{ebx}:=1 to N-1 do
       for j{edi}:=i+1 to N do
         if X[i]>X[j] then xchg(X[i],X[j])
   end;
*

.data?
   buf  db 256 dup (?)

.code
Sort proc uses eax ebx ecx edi, X:dword, N:byte
Comment &
  ������������� ����������� �������:
     push  ebp
     mov   ebp,esp
     push  eax   
     push  ebx   
     push  ecx   
     push  edi
X    equ   dword ptr [ebp+8]
N    equ   byte ptr  [ebp+12]   
&
     xor   ecx,ecx
     mov   cl,N;     ����� ������
     cmp   cl,1     
     jbe   @KON;     N<=1
     mov   ebx,X;    ����� X[1]
     dec   ecx;      N-1
@L1: push  ecx;      ������ ecx
     mov   edi,ebx
     inc   edi;      edi:=����� X[i+1]
@L2: mov   al,[ebx]; al:=x[i]
     cmp   al,[edi]
     jbe   @L3;      if x[i]<=X[j] then goto @L3
     xchg  al,[edi]
     mov   [ebx],al; xchg (x[i],X[j])
@L3: inc   edi;      j:=j+1
     loop  @L2;      ���� �� j
     pop   ecx;      ��� ����� �� i
     inc   ebx;      i:=i+1
     loop  @L1;      ���� �� i
@KON:
     ret
Comment &
  ������ ������� ret ������������� �����������
     pop   edi
     pop   ecx
     pop   ebx
     pop   eax
     ret   8
&
Sort endp
;----------------------------------
Start:
     clrscr
     GotoXY 10,3
     ConsoleTitle "      ���������� ������ �������� ������ �� ����������� ��������"
     newline 2
     outstrln "���� ����� �� ������ ������:"
     newline
L:   
     inputstr offset buf,128,<"���� ",62>; ���� >
     cmp    eax,0
     je     KOH
     invoke Sort,offset buf,al
Comment &
 invoke ������������� ���������� �� �������
     push   offset buf
     movsx  eax,al; eax:=Longint(al)
     push   eax
     call   Sort
&
     SetTextAttr Yellow
     outstr <"�����",62>; �����>
     ConsoleMode; �� �������������� �������� ����� ��� ������
     outstrln offset buf
     ConsoleMode; �������������� �������� ����� ��� ������
     SetTextAttr
     jmp    L
KOH:
     MsgBox "  ����� ������", \
            <"���������",13,10,"��� ��� ?">, \
            MB_YESNO+MB_ICONQUESTION
     cmp  eax,IDYES
     je   Start
     exit
     end Start