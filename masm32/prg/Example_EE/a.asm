include console.inc

includelib wininet.lib
COMMENT * 
         �������� ����� �� ����
*

InternetGetConnectedState PROTO :DWORD,:DWORD
 
.data
  lpdwFlags  dd ?
  dwReserved dd 0

.code
Start:
   ClrScr
   ConsoleTitle "   �������� ����� �� ����"
   invoke InternetGetConnectedState,offset lpdwFlags,dwReserved
   cmp eax,0
   jne @F
   outstrln "��� ���������� � ���������� !"
   exit
@@:outstrln "���� ���������� � ����������"
   outnumln lpdwFlags,,X,"������ ���������="
   outstrln "10h (INTERNET_RAS_INSTALLED) + 02h (INTERNET_CONNECTION_LAN)"
   outstrln "��� �����=http://arch32.cs.msu.su/semestr2/Programm.pdf"
   outstrln "�������� � �������=c:\temp\"
   DownloadFile "http://arch32.cs.msu.su/semestr2/Programm.pdf","c:\temp\Programm.pdf" 
   exit
   end Start