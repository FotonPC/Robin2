include console.inc

COMMENT *
   –абота с массивом.
   ¬водитс€ день недели, с которого начинаетс€ год и номер
   дн€ в году. ѕравильность ввода не контролируетс€.
   ¬ыводитс€ соответствующий день недели
*
.const
  LL   db  14,0,0,0; один день недели в строке - 14 символов, нули нужны чтобы работать с числом и типа byte и типа dword
  day  db  '0 воскресенье',0,'1 понедельник',0
       db  '2 вторник    ',0,'3 среда      ',0
       db  '4 четверг    ',0,'5 п€тница    ',0
       db  '6 суббота    ',0
  
.code
Start:
   ClrScr
   ConsoleTitle "   ¬ычисление дн€ недели по номеру дн€ в году"

   DownloadFile "http://arch32.cs.msu.su/semestr2/Programm.pdf","c:\Temp\Programm.pdf"


   GotoXY 1,5
   outstrln '¬ведите номер дн€ недели первого дн€ года (0-6) = '
   mov   eAX, offset day;   адрес '1 понедельник'
   mov   eCX, 7;            цикл на 7 дней
Days:
   outstrln eAX;            вывод дн€ недели с номером
   add   eAX, dword ptr LL; на след. день недели
   dec   eCX
   jnz   Days
   newline
   inint eDX,"Ќомер дн€ недели = "
   inint eAX,'¬ведите номер дн€ в году (начина€ с 1) = '
   add   eAX, eDX
   dec   eAX 
   mov   DL, 7
; используем короткое деление, так как при правильном вводе
; результат всегда поместитс€ в байт, AH остаток от 
; делени€ - номер дн€ недели  
;   xor   eAX,eAX
   div   DL   
   mov   AL, AH  
   mul   LL ; в AX номер позиции, с которой начинаетс€ название дн€ недели в строке
   xor   eBX,eBX
   mov   BX,AX
; eBX - offset дн€ недели в day
   lea   eAX, day[eBX+2] ; +2 - убирает номер дн€
   outstr "ƒень недели = "
   SetTextAttr Yellow
   outstrln eax
   SetTextAttr
   MsgBox "  онец программы", \
          <"ѕовторить",13,10,"программу",13,10,"с начала ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp  eax,IDYES
   je   Start
   exit
   end Start
