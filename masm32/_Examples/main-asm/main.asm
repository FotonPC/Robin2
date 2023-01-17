;main.asm (головной модуль)

include console.inc

public D, N, Print
extern ShiftR: near

.data
    D dd ?   ;б/зн 
    N = 5

.code
Start:
    inint D,"D = " 
    jmp ShiftR
Print:
    outwordln D,,"Shr D,N = "
    exit 
end Start