include console.inc

COMMENT *
   Вычисления дня недели по введённой дате (day month year).
   На основе алгоритма Tomohiko Sakamoto
   year:=year-m<3;
   day_of_week:=(year+year div 4-year div 100+year div 400+Tab[month-1]+day) mod 7;
*

.const
  Names db  'воскресенье    ',0,'понедельник    ',0
        db  'вторник        ',0,'среда          ',0
        db  'четверг        ',0,'пятница        ',0
        db  'суббота        ',0
  Tab   dd  0,3,2,5,0,3,5,1,4,6,2,4
  Days  dd  31,28,31,30,31,30,31,31,30,31,30,31

.data
  day   dd  ?
  month dd  ?
  year  dd  ?
   
.code
Start:
   ClrScr
   ConsoleTitle "   Вычисление дня недели по дате (day month year)"
   Newline 4
   outstr 'Введите дату '
   SetTextAttr White
   outstr 'day month year = '
   SetTextAttr
   inint day 
   inint month
   inint year

   mov   eax,day
   cmp   eax,1
   jl    Error
   cmp   eax,Days[4*eax-4]
   jg    Error
   cmp   month,1
   jl    Error
   cmp   month,12
   jg    Error
 
   mov   ecx,month
   mov   edx,year
   cmp   ecx,3
   sbb   edx,0
   mov   ecx,Tab[ecx*4-4]
   mov   eax,edx
   imul  edx,0A3D8h
   shr   edx,22
   add   ecx,day
   add   ecx,eax
   shr   eax,2
   add   eax,ecx
   sub   eax,edx
   shr   edx,2
   add   eax,edx
   mov   ecx,eax
   mov   edx,24924925h
   mul   edx
   mov   eax,ecx
   lea   ecx,[edx+edx*2]
   lea   edx,[ecx+edx*4]
   sub   eax,edx; eax=0..6 - день недели

   outint day,,'Дата '
   outint month,,'.'
   outint year,,'.'
   outstr ' это '
   shl    eax,4; eax*16
   lea    eax,Names[eax]
   SetTextAttr Yellow
   outstrln eax
   SetTextAttr
Ques:
   MsgBox " Конец программы", \
          <"Повторить",13,10,"программу",13,10,"с начала ?">, \
          MB_YESNO+MB_ICONQUESTION
   cmp  eax,IDYES
   je   Start
   exit
Error:
   SetTextAttr LightRed
   outstrln 'Ошибка в дате !'
   SetTextAttr
   jmp   Ques 
  end Start
