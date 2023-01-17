include console.inc

COMMENT *
   Ввод строк символов до тех пор, пока не будет введена
   пустая строка. Каждая строка сортируется по
   возрастанию и выводится. Сортировка выполняется
   процедурой
   procedure Sort(var X:array of char; N:byte); 
   begin { Простейшая сортировка }
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
  Автоматически вставляются команды:
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
     mov   cl,N;     длина строки
     cmp   cl,1     
     jbe   @KON;     N<=1
     mov   ebx,X;    адрес X[1]
     dec   ecx;      N-1
@L1: push  ecx;      старое ecx
     mov   edi,ebx
     inc   edi;      edi:=адрес X[i+1]
@L2: mov   al,[ebx]; al:=x[i]
     cmp   al,[edi]
     jbe   @L3;      if x[i]<=X[j] then goto @L3
     xchg  al,[edi]
     mov   [ebx],al; xchg (x[i],X[j])
@L3: inc   edi;      j:=j+1
     loop  @L2;      цикл по j
     pop   ecx;      для цикла по i
     inc   ebx;      i:=i+1
     loop  @L1;      цикл по i
@KON:
     ret
Comment &
  ВМЕСТО команды ret автоматически вставляются
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
     ConsoleTitle "      Сортировка каждой введённой строки по возрастанию символов"
     newline 2
     outstrln "Ввод строк до пустой строки:"
     newline
L:   
     inputstr offset buf,128,<"Ввод ",62>; Ввод >
     cmp    eax,0
     je     KOH
     invoke Sort,offset buf,al
Comment &
 invoke автоматически заменяется на команды
     push   offset buf
     movsx  eax,al; eax:=Longint(al)
     push   eax
     call   Sort
&
     SetTextAttr Yellow
     outstr <"Вывод",62>; Вывод>
     ConsoleMode; Не перекодировать введённый текст при выводе
     outstrln offset buf
     ConsoleMode; Перекодировать введённый текст при выводе
     SetTextAttr
     jmp    L
KOH:
     MsgBox "  Конец задачи", \
            <"Попробуем",13,10,"ещё раз ?">, \
            MB_YESNO+MB_ICONQUESTION
     cmp  eax,IDYES
     je   Start
     exit
     end Start