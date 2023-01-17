include ..\..\include\console.inc

COMMENT *
   Получение и вывод списка загруженных DLL процесса
   http://www.manhunter.ru/assembler/1145_poluchenie_spiska_dll_zagruzhennih_v_tekuschiy_process.html
*

UNICODE_STRING struc
  Len           dw ?
  MaximumLength dw ?
  Buffer        dd ?
UNICODE_STRING ends
 
LIST_ENTRY struc
  Flink         dd ?
  Blink         dd ?
LIST_ENTRY ends
 
LDR_DATA_ENTRY struc
  InMemoryOrderModuleList LIST_ENTRY
  BaseAddress   dd ?
  EntryPoint    dd ?
  SizeOfImage   dd ?
  FullDllName   UNICODE_STRING
  BaseDllName   UNICODE_STRING
  Flags         dd ?
  LoadCount     dw ?
  TlsIndex      dw ?
  HashTableEntry LIST_ENTRY
  TimeDateStamp dd ?
LDR_DATA_ENTRY ends 

.data
  buf  db 128 dup (?)

.code
Start:
   ConsoleTitle " Список загруженных DLL процесса"
   clrscr

   mov  eax,[fs:30h];  EAX -> PEB (Process Enviroment Block)
   mov  eax,[eax+0Ch]; EAX -> PEB_LDR_DATA массив структур
        
   mov  ebx,[eax+1Ch]; EBX -> InInitializationOrderModuleList
@@:
; Последняя запись?
   cmp  [ebx+LDR_DATA_ENTRY.BaseAddress],0
   je   @f; Остановить обработку
; EBX -> LDR_DATA_ENTRY 
   lea  edx,[ebx+4].LDR_DATA_ENTRY.BaseDllName
   mov  esi,offset buf
L: mov  al,[edx]
   mov  [esi],al
   inc  esi
   add  edx,2
   cmp  al,0
   jne  L
   outstrln offset buf
; Указатель на следующую запись
   mov  ebx,[ebx+LDR_DATA_ENTRY.InMemoryOrderModuleList.Flink]
   jmp     @b
@@:
   pause "Конец задачи..."
   exit  
   end Start