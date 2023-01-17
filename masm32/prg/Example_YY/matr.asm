include console.inc

COMMENT *

   Работа с матрицей.
Матрица задается константами - размеры и числа в переменной matr
Можно менять числовые значения констант и тип переменной - программа будет работать правильно.

*
.const
 d equ 5  ;  количество столбцов матрицы 
 h equ 3  ;  количество строк 
.data
matr dd 1, 2, 3, 4, 5
     dd 0, 0, 9, 8, 7
     dd 6,-5,-4,-3,-2 ; можно задать все элементы в одной строке
.code
Start:
   ClrScr
   ConsoleTitle "Матрица"

; Работа со всеми элементами матрицы. Матрица как линейный массив, использование одного индекса
     xor eax,eax   ;  здесь будет сумма
     xor ebx, ebx  ; обнуляется индексный регистр, чтобы начать работу с первым элементом 
     mov ecx, d*h ; количество элементов в матрице
  sum:   add eax, matr[ebx*type matr]
         inc ebx
         loop sum
     outintln  eax   ,,'сумма элементов матрицы '


; Работа со всеми элементами матрицы, использование двух индексов   
    outstrln 'печать матрицы'
    xor ebp, ebp ; для движения вниз  ( индекс строки)
 r0 :   xor ebx, ebx ; для движения по строке вправо (индекс столбца)
   r1:  outint matr[ebp][ebx],9
         add ebx, type matr; индекс столбца увеличивается на размер элемента 
         cmp ebx, d*type matr 
          jne r1
       newline 
       add ebp, d*type matr ; индекс строки увеличивается на размер строки
       cmp ebp, d*h*type matr
       jne r0

; Вычисление адреса элемента по его позиции
     inint  eax, 'номер строки '
     dec ax
     mov edx, d*type matr
     mul edx
     inint ebx,'номер столбца '
     dec ebx
     outintln  matr[eax][ebx*type matr] , , 'на этом месте стоит '


; Работа с элементами столбца. Загрузка адреса в регистр   
     inint ebx, 'введите номер столбца, который надо напечатать  '
     lea ebx, matr[ebx* type matr -type matr]; загрузка первого элемента заданного столбца
     mov ecx, h
     xor edx,edx
     sta: outint <dword ptr [ebx] [edx*type matr]>,8
          add edx,d ; перехд к элементу следующей строки
          loop sta  
       newline 
   exit
   end Start