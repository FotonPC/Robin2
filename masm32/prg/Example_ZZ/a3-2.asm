include console.inc


        public N
        N = 10101

        public Qdb,Qdw,Qdd,Qi32,Qtxt
Qi32    equ  2020202

.data
   Qdb  db  -11
   Qdw  dw  -2222
   Qdd  dd  -33333333
   Qtxt db  "Привет из модуля a3-2.asm !!!",0

; Внешние имена из a3-1.asm 
      extrn Pdb:byte, Pdw:word, Pdd:dword
      extrn Pi32:abs; abs - ТОЛЬКО i32
      
.code
 
     public QQ

QQ proc
      SetTextAttr White
      outstrln "Вывод из процедуры QQ модуля a3.2.asm"
      mov  al,-111
      SetTextAttr
      ret
QQ endp

      public Q
Q     proc uses eax ebx, x:dword,y:word
      local z:dword 
; автоматически вставляются команды:
;     push ebp
;     mov  ebp,esp
;     sub  esp,4; local z:dword = [ebp-4]
;     push eax
;     push ebx
; действуют неявные директивы:
;z    equ  dword ptr [ebp-4]
;x    equ  dword ptr [ebp+8]
;y    equ  dword ptr [ebp+12]

; перед ret автоматически вставляются команды:
;     pop  ebx
;     pop  eax
;     mov  esp,ebp
;     pop  ebp
;     ret  8

     ret;  8
Q    endp

     end
