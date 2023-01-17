include console.inc

;Comment @
MSGBOXPARAMSA STRUCT
  cbSize                DWORD      ?
  hwndOwner             DWORD      ?
  hInstance             DWORD      ?
  lpszText              DWORD      ?
  lpszCaption           DWORD      ?
  dwStyle               DWORD      ?
  lpszIcon              DWORD      ?
  dwContextHelpId       DWORD      ?
  lpfnMsgBoxCallback    DWORD      ?
  dwLanguageId          DWORD      ?
MSGBOXPARAMSA ENDS

MSGBOXPARAMS EQU <MSGBOXPARAMSA>
;@

.data
   txt  db  "Привет",0
   cap  db  "Заголовок",0
   params MSGBOXPARAMS <SIZEOF MSGBOXPARAMS,0,,offset txt,offset cap, \
          MB_USERICON+MB_ABORTRETRYIGNORE+MB_SYSTEMMODAL,IDI_ICON,0,0,\
          LANG_NEUTRAL>
   ICON dd  1004
   Nam  db  "a_shell.exe",0

.code
Start:
   clrscr
   ConsoleTitle " Работа с пиктограммами"
   gotoXY 10,10

IDI_ICON EQU 1004
   
;  mov params.cbSize,SIZEOF MSGBOXPARAMS;  размер структуры
;  mov params.hwndOwner,0;                 дескриптор окна владельца
   invoke GetModuleHandle,0;               получение дескриптора программы
   mov params.hInstance,eax;               сохранение дескриптора программы
;  lea eax,txt;                            адрес сообщения
;  mov params.lpszText,eax
;  lea eax,cap;                            адрес заглавия окна
;  mov params.lpszCaption,eax
;  mov params.dwStyle, \
;      MB_USERICON+MB_ABORTRETRYIGNORE+ \
;      MB_SYSTEMMODAL;                     стиль окна
;  mov params.lpszIcon,ICON_ICON;          номер ресурса значка
;  mov params.dwContextHelpId,0;           контекст справки
;  mov params.lpfnMsgBoxCallback,0;
;  mov params.dwLanguageId,LANG_NEUTRAL;   язык сообщения
;  lea ecx,params;                         адрес структуры параметров

L0:
   inint eax,"Номер пиктограммы (0 - выход) = "
   cmp   eax,0
   je    L1
   add   eax,1000
   mov params.lpszIcon,eax
   invoke MessageBoxIndirect,offset params; eax - код кнопки
   outintln eax,,"Нажата кнопка с кодом="
   jmp L0

L1:
   settextattr Yellow
   outstrln 'Вызов подчинённой задачи "a_shell.exe"'
   RunExe "a_shell.exe"
   outstrln "Возврат в старую консоль"
   settextattr
   pause
   
   exit
  end Start