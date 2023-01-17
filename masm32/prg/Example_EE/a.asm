include console.inc

includelib wininet.lib
COMMENT * 
         Загрузка файла из сети
*

InternetGetConnectedState PROTO :DWORD,:DWORD
 
.data
  lpdwFlags  dd ?
  dwReserved dd 0

.code
Start:
   ClrScr
   ConsoleTitle "   Загрузка файла из сети"
   invoke InternetGetConnectedState,offset lpdwFlags,dwReserved
   cmp eax,0
   jne @F
   outstrln "Нет соединения с Интернетом !"
   exit
@@:outstrln "Есть соединение с Интернетом"
   outnumln lpdwFlags,,X,"Статус Интернета="
   outstrln "10h (INTERNET_RAS_INSTALLED) + 02h (INTERNET_CONNECTION_LAN)"
   outstrln "Имя файла=http://arch32.cs.msu.su/semestr2/Programm.pdf"
   outstrln "Загрузка в каталог=c:\temp\"
   DownloadFile "http://arch32.cs.msu.su/semestr2/Programm.pdf","c:\temp\Programm.pdf" 
   exit
   end Start