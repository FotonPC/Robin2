{$OUTPUT_FORMAT MASM}
Program TwoModul;
{  call function Q from modul a_2.asm  }
   uses Crt,Windows;

{ $OBJECTPATH 'd:\masm 6.14\prg\TwoModul'}
{ $LIBRARYPATH 'd:\Free Pascal 2.6.4\bin\i386-win32\Connect'}
{ $LINKLIB user32.lib}
{ $LINKLIB masm32.lib}

{;kernel32.lib;msvcrt.lib;io_proc.lib}

var ss:Longint;
    xPas: Longint public name '_xPas';
    xAsm: Longint external name '_xAsm';
    handle: integer; ButtonCode: word;
    sCap: pChar='Заголовок'; { строка с нулём как в C }
    sText: pChar='Hi! Привет!'+#13+#10+'Вторая строка';
    TwoMod:pChar='TwoModul: вызывает функция Q из a_2.asm';

Function Q(a,b:Longint):Longint;
   stdcall; external name '_Q@0';
{$L a_2.obj}

Function F:Longint;
   stdcall; public name '_F@0';
begin F:=-11111 end;

begin
{   ClrScr; }
   
   CharToOem(TwoMod,TwoMod); SetConsoleTitle(TwoMod);
{   OemToChar(TwoMod,TwoMod);}
   Writeln('Proramm TwoModul');
   xPas:=33333;
   Writeln('xAsm from _2.asm=',xAsm);
   Writeln('Перед входом в a_2.asm');
   ss:=Q(11111,22222);
   Writeln('From Q: a+b+xPas=',ss);
{   OemToChar(sText,sText);}
   ButtonCode:=MessageBox(handle,sText,sCap,
                          MB_YESNOCANCEL+MB_ICONQUESTION+MB_HELP+MB_SYSTEMMODAL);
   Readln;

end.
