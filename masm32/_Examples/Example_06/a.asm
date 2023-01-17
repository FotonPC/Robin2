include console.inc

Comment & 
    Заготовка для программы "Делится ли одно число на другое"
    Данная программа осуществляет короткое деление и работает
    только с маленьким делителем
    Задание
    =======
    Вводится "большое" число (любого допустимого размера) и
    "маленькое", байтовое. Вывести, делится ли большое на
    маленькое. Сделайте проверку, не равно ли "маленькое"
    нулю или единице.
    Дополнение. "делится" вывести зеленым цветом,
    а "не делится" - красным. Другие цвета не менять.
    Сделать, чтобы программа запрашивала, проверить ли еще пару чисел 
&

.const 
   otvet db 'не делится',0
.data 
   X dd ?
   Y db ?

.code	
Start:
   ClrScr
   ConsoleTitle "   Проверка делимости X (dd) на Y (db)"
   newline 3
   inint X,"Ведите целое X = "
   inint Y,"Ведите целое Y (от -128 до +127) = "
   cmp   Y,0
   jne   @F
   outstrln "Y = 0"
   je    Povtor
@@:
   cmp   Y,1
   jne   @F
   outstrln "Y = 1"
   je    Povtor
@@:
   cmp   Y,-1
   jne   @F
   outstrln "Y = -1"
   je    Povtor
@@:
   mov   eax,X
   cdq;        <edx,eax>:=itn64(X)
   movsx ebx,Y; ebx:=Longint(Y) 
   idiv  ebx
   cmp   edx,0
   jne   @F
   SetTextAttr LightGreen
   outstrln "X делится на Y"
   SetTextAttr
   jmp   Povtor
@@:
   SetTextAttr LightRed
   outstrln "X не делится на Y"
   SetTextAttr
Povtor:
   MsgBox " Конец программы","Повторить ?", \
          MB_YESNO+MB_ICONQUESTION
   cmp  eax,IDYES
   je   Start
   exit
   end Start