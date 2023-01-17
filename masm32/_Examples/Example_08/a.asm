include console.inc

COMMENT *
   Макроопределения и макрокоманды
*
option nokeyword: <c>

;----------- Макроопределения ----------------   
;*********************************************
; Макрофункция Revers перевёрнутый список из
; своего аргумента, Revers(a,b,c)=<c,b,a>
;*********************************************
Revers macro x:vararg
   Local L
   echo Input List=x;   echo КОНСТАНТЫ
L  textequ <>
 for i,<x>
L  CatStr <i>,<,>,L
 endm
L  SubStr L,1,@SizeStr(%L)-1; убрать послед. запятую
   %echo  Output List=L;  echo СТРОКОВОЙ МАКРОПЕРЕМЕННОЙ
   exitm  <L>
endm
;---------------------------------------------------   
; Рекурсивная макрофункция вычисления факториала N!
;---------------------------------------------------   
Fact  macro N:req
      Local F
      F=1
  if N GT 1
      F=(N)*Fact(N-1)
  endif
      exitm <F>
endm

;---------------------------------------------
;  Вывод по директиве echo на этапе компиляции
;---------------------------------------------

echo -------------------------------------------
echo ‚лў®¤ Ї® ¤ЁаҐЄвЁўҐ echo ­  нв ЇҐ Є®¬ЇЁ«пжЁЁ
echo -------------------------------------------

%echo Date=@Date, Time=@Time
A     CatStr <Data=>,<@Date>,<, Time=>,<@Time>
echo  CatStr <Data=>,<@Date>,<, Time=>,<@Time>
%echo A
echo  SubStr A,16,8 - Time Only :
B     SubStr A,16;       Только Time
%echo B
echo
echo Pos('s') in "123asdfgs" = @InStr(6,123asdfgs,s)
%echo Pos('s') in "123asdfgs" = @InStr(6,123asdfgs,s)
echo Pos('s') in "123asdfgs" = @InStr(1,123asdfgs,s)
%echo Pos('s') in "123asdfgs" = @InStr(1,123asdfgs,s)
echo

C     = 10101;           Числовая Макропеременная
echo  %echo @CatStr(%C)  - Numeric MacroVariable C=10101
%echo @CatStr(C=,%C);    Целое C в строку
D     TextEqu <ABCD>;    Строковая Макропеременная
echo  D TextEqu <ABCD>   - String MacroVariable D="ABCD"
%echo D
D     TextEqu <KLNMOP>
echo  D TextEqu <KLNMOP> - String MacroVariable D="KLNMOP"
%echo D
E     equ ABCD;          Строковая Макропеременная E equ ABCD
echo  E equ ABCD         - String MacroVariable E="ABCD"
%echo E
E     equ KLNMOP;        Строковая Макропеременная E equ KLNMOP
echo  E equ KLNMOP       - String MacroVariable E="KLNMOP"
%echo E
E     equ 999;           Строковая Макропеременная E equ 999
echo  E equ 999          - String MacroVariable E="999"
%echo E
F     equ 123;           Строковая Макророконстанта F equ 123
echo  F equ 123          - Numeric MacroConstant F equ 123
%echo @CatStr(F=,%F);    Целое F в строку
echo  F equ 4567         - ERROR - Numeric MacroConstant !
echo

%echo @CatStr(<Version MASM = >,%@Version/100,.,%@Version mod 100)
%echo Current Line in File = @CatStr(%@Line)
%echo Name of Current Section = @CurSeg
echo

.data
  X   db @CatStr(!",%A,!"),0; CatStr <Data=>,<@Date>,<, Time=>,<@Time>
  Lst db @CatStr(!",%Revers(a,b,c,1,2,3),!"),0;

.code
Start:
   ConsoleTitle "   Макроопределения и макрокоманды"
   pause "Перейдём к выводу во время счёта программы..."
   clrscr
   newline
   outstr   'X db @CatStr(!",%A,!") = '
   outstrln offset X
   newline
   mov       ax,@Version; Версия MASM
   mov       bl,100
   div       bl
   outword   al,,"Наша версия Ассемблера MASM="
   outwordln ah,,"."
   newline
   outstr "Имя текущего файла = "
   outstrln @CatStr(!',!",%@FileCur,!",!')
; ------------------------------------------
   outstrln "     Исходный список=a,b,c,1,2,3"
   outstr   " Перевёрнутый список="
   outstrln offset Lst
   newline
; ------------------------------------------
   outwordln Fact(4),," Факториал (4)  = "
   outwordln Fact(20),," Факториал (20) = "
   newline
   
   exit

Comment &
   FILD  Q
   FIMUL Q
;   FIADD Q
   FISTP Q
   outintln Q,,"Q="
&

;if1
;   echo Pass1
;else
;   echo Pass2
;endif

exit

;-----------------------

je  near ptr L1; 74 XX
nop
jne L2; 75 XX
L1:   
   pause "Press any key ..."
   clrscr
   newline 2
   outdate   "Дата="
   outtimeln " Время="
   
L2:
   exit
   end Start