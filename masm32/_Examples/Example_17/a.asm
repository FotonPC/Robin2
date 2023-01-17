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
   txt  db  "������",0
   cap  db  "���������",0
   params MSGBOXPARAMS <SIZEOF MSGBOXPARAMS,0,,offset txt,offset cap, \
          MB_USERICON+MB_ABORTRETRYIGNORE+MB_SYSTEMMODAL,IDI_ICON,0,0,\
          LANG_NEUTRAL>
   ICON dd  1004
   Nam  db  "a_shell.exe",0

.code
Start:
   clrscr
   ConsoleTitle " ������ � �������������"
   gotoXY 10,10

IDI_ICON EQU 1004
   
;  mov params.cbSize,SIZEOF MSGBOXPARAMS;  ������ ���������
;  mov params.hwndOwner,0;                 ���������� ���� ���������
   invoke GetModuleHandle,0;               ��������� ����������� ���������
   mov params.hInstance,eax;               ���������� ����������� ���������
;  lea eax,txt;                            ����� ���������
;  mov params.lpszText,eax
;  lea eax,cap;                            ����� �������� ����
;  mov params.lpszCaption,eax
;  mov params.dwStyle, \
;      MB_USERICON+MB_ABORTRETRYIGNORE+ \
;      MB_SYSTEMMODAL;                     ����� ����
;  mov params.lpszIcon,ICON_ICON;          ����� ������� ������
;  mov params.dwContextHelpId,0;           �������� �������
;  mov params.lpfnMsgBoxCallback,0;
;  mov params.dwLanguageId,LANG_NEUTRAL;   ���� ���������
;  lea ecx,params;                         ����� ��������� ����������

L0:
   inint eax,"����� ����������� (0 - �����) = "
   cmp   eax,0
   je    L1
   add   eax,1000
   mov params.lpszIcon,eax
   invoke MessageBoxIndirect,offset params; eax - ��� ������
   outintln eax,,"������ ������ � �����="
   jmp L0

L1:
   settextattr Yellow
   outstrln '����� ���������� ������ "a_shell.exe"'
   RunExe "a_shell.exe"
   outstrln "������� � ������ �������"
   settextattr
   pause
   
   exit
  end Start