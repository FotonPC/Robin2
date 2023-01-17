include ..\..\include\console.inc

COMMENT *
   Обработка исключений с помощью своей функции
   https://vxlab.info/wasm/article.php-article=GordonExcept.htm
   http://xaknotdie.org/defaced/5/d5%5B0x0e%5D.html
*

SetUnhandledExceptionFilter proto :dword

EXCEPTION_RECORD struc
   ExceptionCode         dd ?; Код исключения
   ExceptionFlag         dd ?
; ExceptionFlag=0 - можно продолжить счёт, 
; =1 - нельзя продолжить счёт,
; =2 - не надо (опасно) реагировать на эту ошибку (испорчен стек и т.д)
   NestedExceptionRecord dd ?
   ExceptionAddress      dd ?; Адрес команды, вызвавшей исключение
   NumberParameters      dd ?; число dd в поле AdditionalData
   AdditionalData        dd 5 dup (?)
EXCEPTION_RECORD ends

COMMENT * Коды некоторых исключений
  C0000005h (EXCEPTION_ACCESS_VIOLATION)
		Попытка считать или записать в память, не имея на то необходимых прав
  C000001Dh – Попытка передать управление в страницы сегмента данных
  C000008Ch (STATUS_ARRAY_BOUNDS_EXCEEDED)
            – Попытка использовать значение регистра за границами BOUND
  C0000094h (EXCEPTION_INT_DIVIDE_BY_ZERO)
		Попытка поделить число целого типа на 0
  C0000095h (EXCEPTION_INT_OVERFLOW)– Попытка поделить с целочисленным переполнением (ax=20000 div bl=2)
  C00000FDh (EXCEPTION_STACK_OVERFILOW)
		Стек, отведенный потоку, исчерпан
  80000001h – Попытка обратиться к странице памяти с атрибутом защиты PAGE_GUARD
              Страница становится доступной, и генерируется данное исключение
  80000003h (EXCEPTION_BREAKPOINT)
		Точка прерывания, инициированная командой INT3
  80000004h - EXCEPTION_SINGLE_STEP по TF=1 (выполнена очередная команда)

	    (EXCЕPTION_ILLEGAL_INSTRUCTION)
		Команда с несуществуюшим кодом операции
	    (EXCEPTION_PRIV_INSTRUCTION)
		Попытка выполнить привилегированную команда
	    (EXCEPTION_SINGLE_STEP)
		Установлен TF=1
  .........   Другие коды в Интернете или получить, сделав нужное исключение
*

; Контекст нашего прерванного потока
CONTEXT struc
   Context_flags dd ?;                 нас не интересует
   DEBUG_REGS    dd 6 dup (?);         нас не интересует
   FPU_regs      db (8Ch-1Ch) dup (?); нас не интересует
; Значения всех регистров в точке прерывания
   gs_reg     dd ?
   fs_reg     dd ?
   es_reg     dd ?
   ds_reg     dd ?
   edi_reg    dd ?
   esi_reg    dd ?
   ebx_reg    dd ?
   edx_reg    dd ?
   ecx_reg    dd ?
   eax_reg    dd ?
   ebp_reg    dd ?
   EIP_reg    dd ?
   cs_reg     dd ?
   EFLAGS_reg dd ?
   esp_reg    dd ?
   ss_reg     dd ?
CONTEXT ends

.data
   X  dd ?

.code
Start:
   ConsoleTitle " Перехват и обработка исключений"
   clrscr
   
   push MyException;    Наш обработчик !!!
   call SetUnhandledExceptionFilter
   
;  сделаем исключение

   mov  ax,10
   mov  cl,0
   newline
   outint ax,,"ax="
   outint cl,,", cl="
   outstrln ". Команда div cl"
   pause "Будем делить на ноль ! ..."
   div  cl
   outintln cl,,"cl="
   outintln al,,"ax div cl="
   newline
   pause "Конец задачи..."
   exit  

CONT:
   newline
   outstrln " После деления на ноль перешли на метку CONT"
   newline
   pause "Конец задачи..."
   exit  
; ---------------------------------------------------------
; Обработчик финального исключений UnhandledExceptionFilter
; Он один на все потоки задачи

MyException proc 
   newline 2
   SetTextAttr Yellow
   outstrln " Произошло исключение !"
   mov  ebx,[esp+4];    адрес EXCEPTION_POINTERS
   mov  eax,[ebx];      адрес EXCEPTION_RECORD
   mov  eax,[eax];      ExceptionCode
   outnumln eax,,X," Код исключения = "
   cmp  eax,0C0000094h; деление на ноль ?
   jne  @F
   outstrln " Деление на ноль !"
   newline
@@:   
   SetTextAttr
   mov  ebx,[ebx+4];    адрес CONTEXT
   outnumln [ebx].CONTEXT.EIP_reg,,X, \
            " Регистр EIP указывает на (div cl) = "
   newline
   
   MsgBox "Деление на cl=0 !","Продолжить счёт с cl=5 ?", \
          MB_YESNO+MB_ICONEXCLAMATION
   cmp eax,IDYES
   jne @F
   mov  [ebx].CONTEXT.ecx_reg,5; cl:=5
   mov eax,-1; Продолжить счёт с прерванного места
   ret 4
@@:
   MsgBox "Деление на ноль !","Продолжить счёт с метки CONT ?", \
          MB_YESNO+MB_ICONEXCLAMATION
   cmp eax,IDYES
   jne @F
   mov [ebx].CONTEXT.EIP_reg,CONT; EIP:=offset CONT
   mov eax,-1; Восстановить контекст и возобновить счёт
   ret 4
@@:
   mov eax,0; показывать сообщение о предстоящем закрытии программы

; eax=-1 перезагрузить контекст и продолжить выполнение программы.
; eax= 1 не показывать сообщение о предстоящем закрытии программы.
; eax= 0 показывать сообщение о предстоящем закрытии программы.

   ret 4; Был один параметр, ссылка на EXCEPTION_POINTERS

MyException endp

   end Start