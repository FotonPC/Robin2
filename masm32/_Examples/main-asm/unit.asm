;unit.asm (вспомогательный модуль)

include console.inc

public ShiftR
extern D: dword, N: abs, Print: near

.code
ShiftR:
    mov ECX,N
    shr D,CL
    jmp Print

end 
