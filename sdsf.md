;          1         2         3         4         5         6         7
;01234567890123456789012345678901234567890123456789012345678901234567890
;=======================================================================
;+---------------------------------------------------------------------+
;|                                                                     |
;|    Example using FPU registers for floating point calculations.     |
;|                                                                     |
;|    The purpose of this source code is to demonstrate on how to      |
;|    do floating-point operations using FPU registers.                |
;|                                                                     |
;|    To understand this code, make sure you know IEEE-754 Standard    |
;|    and architecture of FPU registers, especially why it is called   |
;|    FPU stack.                                                       |
;|                                                                     |
;|    When debugging with GNU GDB, make sure you specify the type of   |
;|    architecture by executing the following command in GDB:          |
;|                                                                     |
;|    (gdb) set architecture i386                                      |
;|                                                                     |
;|    so that the GDB will display the correct value when using        |
;|    commands:                                                        |
;|                                                                     |
;|    (gdb) x/f &single_sum                                            |
;|    (gdb) x/fg &double_sum                                           |
;|                                                                     |
;|    to display the floating-point value from memory.                 |
;|                                                                     |
;|    There are 11 examples in this source code:                       |
;|    example_1: Moving single-precision value to FPU stack            |
;|    example_2: Moving double-precision value to FPU stack            |
;|    example_3: Moving extended-precision value to FPU stack          |
;|    example_4: Add Operation (single + single)                       |
;|    example_5: Add Operation (single + single + single)              |
;|    example_6: Add Operation (single + double + extended)            |
;|    example_7: Subtract Operation (single - single)                  |
;|    example_8: Multiply Operation (single * single)                  |
;|    example_9: Divide Operation (single / single)                    |
;|    example_10: Convert single to double                             |
;|    example_11: Compare float numbers (Find the largest value)       |
;|                                                                     |
;| Use these commands to assemble this code:                           |
;|                                                                     |
;| > @ml /c /coff _start.asm                                           |
;| > @link /MACHINE:x86 /SUBSYSTEM:console _start.obj                  |
;|                                                                     |
;+---------------------------------------------------------------------+
;|       AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi                     |
;|        EMAIL: nickaizuddin93@gmail.com                              |
;| DATE CREATED: 21/OCT/2014                                           |
;+---------------------------------------------------------------------+
;|     LANGUAGE: x86 Assembly Language                                 |
;|    ASSEMBLER: MASM32                                                |
;|       SYNTAX: Intel                                                 |
;| ARCHITECTURE: i386                                                  |
;|       KERNEL: Windows 32-bit                                        |
;|       FORMAT: COFF                                                  |
;+---------------------------------------------------------------------+
;| REVISION HISTORY:                                                   |
;|                                                                     |
;|  Rev # |    Date     |                Description                   |
;| -------+-------------+--------------------------------------------- |
;|  1.0.0 | 24/OCT/2014 | First release.                               |
;|  1.0.1 | 26/OCT/2014 | Fix st0 := st1 <operand> st0                 |
;|                                                                     |
;+---------------------------------------------------------------------+
;| Do whatever you want with this source code :)                       |
;+---------------------------------------------------------------------+
;=======================================================================

;---- configurations ---------------------------------------------------
.386                  ; assemble instructions up to 386 instruction sets
.model flat, stdcall  ; 32-bit memory model (flat memory model)
option casemap:none   ; case sensitive

include \masm32\include\windows.inc
include \masm32\macros\macros.asm

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

;---- section uninitialized data ---------------------------------------
.data?

single_sum      dd ?
single_sub      dd ?
single_mul      dd ?
single_div      dd ?
single2double   dq ?
double_sum      dq ?

;---- section read/write data ------------------------------------------
.data

single_value1   dd 12.34
single_value2   dd 102.35
single_value3   dd -52.02

double_value1   dq 12.34
double_value2   dq 102.35
double_value3   dq -52.02

extended_value1 dt 12.34
extended_value2 dt 102.35
extended_value3 dt -52.02

;---- section instruction codes ----------------------------------------
.code

_start:

example_1:
;+---------------------------------------------------------------------+
;| Moving single-precision value to FPU stack.                         |
;|                                                                     |
;| This example 1 will show how to move/copy the single-precision      |
;| value from memory to fpu stacks.                                    |
;|                                                                     |
;| This example will perform these 3 instructions:                     |
;|   STEP 1: push single_value1 to fpu stack                           |
;|   STEP 2: push single_value2 to fpu stack                           |
;|   STEP 3: push single_value3 to fpu stack                           |
;|                                                                     |
;| Below are the observations on FPU stacks during these 3 steps:      |
;|   AT STEP 1: st0 = single_value1                                    |
;|              st1 = 0                                                |
;|              st2 = 0                                                |
;|              st4 = 0                                                |
;|              st5 = 0                                                |
;|              st6 = 0                                                |
;|              st7 = 0                                                |
;|                                                                     |
;|   AT STEP 2: st0 = single_value2                                    |
;|              st1 = single_value1                                    |
;|              st2 = 0                                                |
;|              st4 = 0                                                |
;|              st5 = 0                                                |
;|              st6 = 0                                                |
;|              st7 = 0                                                |
;|                                                                     |
;|   AT STEP 3: st0 = single_value3                                    |
;|              st1 = single_value2                                    |
;|              st2 = single_value1                                    |
;|              st4 = 0                                                |
;|              st5 = 0                                                |
;|              st6 = 0                                                |
;|              st7 = 0                                                |
;|                                                                     |
;| Note: Before using fpu stacks, make sure to reset them to their     |
;|       default value. This practice can prevent bugs in the program. |
;+---------------------------------------------------------------------+

    finit                            ;reset fpu registers to default
    fld    dword ptr [single_value1] ;push value 12.34 to fpu stack
    fld    dword ptr [single_value2] ;push value 102.35 to fpu stack
    fld    dword ptr [single_value3] ;push value -52.02 to fpu stack

example_2:
;+---------------------------------------------------------------------+
;| Moving double-precision value to FPU stack.                         |
;|                                                                     |
;| This example 2 will show how to move/copy the double-precision      |
;| value from memory to fpu stacks.                                    |
;|                                                                     |
;| This example will perform these 3 instructions:                     |
;|   STEP 1: push double_value1 to fpu stack                           |
;|   STEP 2: push double_value2 to fpu stack                           |
;|   STEP 3: push double_value3 to fpu stack                           |
;|                                                                     |
;| Below are the observations on FPU stacks during these 3 steps:      |
;|   AT STEP 1: st0 = double_value1                                    |
;|              st1 = 0                                                |
;|              st2 = 0                                                |
;|              st4 = 0                                                |
;|              st5 = 0                                                |
;|              st6 = 0                                                |
;|              st7 = 0                                                |
;|                                                                     |
;|   AT STEP 2: st0 = double_value2                                    |
;|              st1 = double_value1                                    |
;|              st2 = 0                                                |
;|              st4 = 0                                                |
;|              st5 = 0                                                |
;|              st6 = 0                                                |
;|              st7 = 0                                                |
;|                                                                     |
;|   AT STEP 3: st0 = double_value3                                    |
;|              st1 = double_value2                                    |
;|              st2 = double_value1                                    |
;|              st4 = 0                                                |
;|              st5 = 0                                                |
;|              st6 = 0                                                |
;|              st7 = 0                                                |
;|                                                                     |
;| Note: Before using fpu stacks, make sure to reset them to their     |
;|       default value. This practice can prevent bugs in the program. |
;+---------------------------------------------------------------------+

    finit                            ;reset fpu registers to default
    fld    qword ptr [double_value1] ;push value 12.34 to fpu stack
    fld    qword ptr [double_value2] ;push value 102.35 to fpu stack
    fld    qword ptr [double_value3] ;push value -52.02 to fpu stack

example_3:
;+---------------------------------------------------------------------+
;| Moving extended-precision value to FPU stack.                       |
;|                                                                     |
;| This example 2 will show how to move/copy the extended-precision    |
;| value from memory to fpu stacks.                                    |
;|                                                                     |
;| This example will perform these 3 instructions:                     |
;|   STEP 1: push extended_value1 to fpu stack                         |
;|   STEP 2: push extended_value2 to fpu stack                         |
;|   STEP 3: push extended_value3 to fpu stack                         |
;|                                                                     |
;| Below are the observations on FPU stacks during these 3 steps:      |
;|   AT STEP 1: st0 = extended_value1                                  |
;|              st1 = 0                                                |
;|              st2 = 0                                                |
;|              st4 = 0                                                |
;|              st5 = 0                                                |
;|              st6 = 0                                                |
;|              st7 = 0                                                |
;|                                                                     |
;|   AT STEP 2: st0 = extended_value2                                  |
;|              st1 = extended_value1                                  |
;|              st2 = 0                                                |
;|              st4 = 0                                                |
;|              st5 = 0                                                |
;|              st6 = 0                                                |
;|              st7 = 0                                                |
;|                                                                     |
;|   AT STEP 3: st0 = extended_value3                                  |
;|              st1 = extended_value2                                  |
;|              st2 = extended_value1                                  |
;|              st4 = 0                                                |
;|              st5 = 0                                                |
;|              st6 = 0                                                |
;|              st7 = 0                                                |
;|                                                                     |
;| Note: Before using fpu stacks, make sure to reset them to their     |
;|       default value. This practice can prevent bugs in the program. |
;+---------------------------------------------------------------------+

    finit                              ;reset fpu registers to default
    fld    tbyte ptr [extended_value1] ;push value 12.34 to fpu stack
    fld    tbyte ptr [extended_value2] ;push value 102.35 to fpu stack
    fld    tbyte ptr [extended_value3] ;push value -52.02 to fpu stack

example_4:
;+---------------------------------------------------------------------+
;| Add Operation (single + single)                                     |
;|                                                                     |
;| The following equation will be executed in this example_4:          |
;|                                                                     |
;| p = x + y                                                           |
;|                                                                     |
;| where,                                                              |
;|   x = single_value1                                                 |
;|   y = single_value2                                                 |
;|   p = single_sum                                                    |
;|                                                                     |
;| Behaviour of fpu stacks before and after FAdd:                      |
;|   Before fadd: st0 = 102.34999847412109375                          |
;|                st1 = 12.340000152587890625                          |
;|                                                                     |
;|   After fadd:  st0 = 114.689998626708984375                         |
;|                st1 = 0                                              |
;+---------------------------------------------------------------------+

    finit                            ;reset fpu stacks to default
    fld    dword ptr [single_value1] ;push single_value1 to fpu stack
    fld    dword ptr [single_value2] ;push single_value2 to fpu stack
    fadd                             ;st0 := st1 + st0
    fstp   dword ptr [single_sum]    ;store the sum result into mem

example_5:
;+---------------------------------------------------------------------+
;| Add Operation (single + single + single)                            |
;|                                                                     |
;| The following equation will be executed in this example_5:          |
;|                                                                     |
;| p = x + y + z                                                       |
;|                                                                     |
;| where,                                                              |
;|   x = single_value1                                                 |
;|   y = single_value2                                                 |
;|   z = single_value3                                                 |
;|   p = single_sum                                                    |
;+---------------------------------------------------------------------+

    finit                            ;reset fpu stacks to default
    fld    dword ptr [single_value1] ;push single_value1 to fpu stack
    fld    dword ptr [single_value2] ;push single_value2 to fpu stack
    fadd                             ;st0 := st1 + st0
    fld    dword ptr [single_value3] ;push single_value3 to fpu stack
    fadd                             ;st0 := st1 + st0
    fstp   dword ptr [single_sum]    ;store the sum result into mem

example_6:
;+---------------------------------------------------------------------+
;| Add Operation (single + double + extended)                          |
;|                                                                     |
;| The following equation will be executed in this example_6:          |
;|                                                                     |
;| p = x + y + z                                                       |
;|                                                                     |
;| where,                                                              |
;|   x = single_value1                                                 |
;|   y = double_value2                                                 |
;|   z = extended_value3                                               |
;|   p = double_sum                                                    |
;+---------------------------------------------------------------------+

    finit                              ;reset fpu stacks to default
    fld    dword ptr [single_value1]   ;push single_value1 to fpu stack
    fld    qword ptr [double_value2]   ;push double_value2 to fpu stack
    fadd                               ;st0 := st1 + st0
    fld    tbyte ptr [extended_value3] ;psh extended_value3 to fpu stack
    fadd                               ;st0 := st1 + st0
    fstp   qword ptr [double_sum]      ;store the sum result into mem

example_7:
;+---------------------------------------------------------------------+
;| Subtract Operation (single - single)                                |
;|                                                                     |
;| The following equation will be executed in this example_7:          |
;|                                                                     |
;| p = x - y                                                           |
;|                                                                     |
;| where,                                                              |
;|   x = single_value1                                                 |
;|   y = single_value2                                                 |
;|   p = single_sum                                                    |
;+---------------------------------------------------------------------+

    finit                            ;reset fpu stacks to default
    fld    dword ptr [single_value1] ;single_value1 to fpu stack(st1)
    fld    dword ptr [single_value2] ;single_value2 to fpu stack(st0)
    fsub                             ;st0 := st1 - st0
    fstp   dword ptr [single_sub]    ;store the subtract result into mem

example_8:
;+---------------------------------------------------------------------+
;| Multiply Operation (single * single)                                |
;|                                                                     |
;| The following equation will be executed in this example_8:          |
;|                                                                     |
;| p = x * y                                                           |
;|                                                                     |
;| where,                                                              |
;|   x = single_value1                                                 |
;|   y = single_value2                                                 |
;|   p = single_mul                                                    |
;+---------------------------------------------------------------------+

    finit                            ;reset fpu stacks to default
    fld    dword ptr [single_value1] ;single_value1 to fpu stack(st1)
    fld    dword ptr [single_value2] ;single_value2 to fpu stack(st0)
    fmul                             ;st0 := st1 * st0
    fstp   dword ptr [single_mul]    ;store the mult. result into mem

example_9:
;+---------------------------------------------------------------------+
;| Divide Operation (single / single)                                  |
;|                                                                     |
;| The following equation will be executed in this example_9:          |
;|                                                                     |
;| p = x / y                                                           |
;|                                                                     |
;| where,                                                              |
;|   x = single_value1                                                 |
;|   y = single_value2                                                 |
;|   p = single_div                                                    |
;+---------------------------------------------------------------------+

    finit                            ;reset fpu stacks to default
    fld    dword ptr [single_value1] ;single_value1 to fpu stack(st1)
    fld    dword ptr [single_value2] ;single_value2 to fpu stack(st0)
    fdiv                             ;st0 := st1 / st0
    fstp   dword ptr [single_div]    ;store the div result into mem

example_10:
;+---------------------------------------------------------------------+
;| Convert single to double                                            |
;|                                                                     |
;| This example shows how to convert/promote single to double.         |
;| These steps will be executed for conversion:                        |
;|   STEP 1: Push single_value1 to FPU stack                           |
;|   STEP 2: Store the double value of single_value1 to memory         |
;+---------------------------------------------------------------------+

    finit                            ;reset fpu stacks to default
    fld    dword ptr [single_value1] ;single_value1 to fpu stack(st0)
    fstp   qword ptr [single2double] ;store the double value into mem

example_11:
;+---------------------------------------------------------------------+
;| Compare float numbers (Find the largest value)                      |
;|                                                                     |
;| This example shows how to compare 2 floating-point numbers.         |
;|                                                                     |
;| Given single_value1 and single_value2,                              |
;| If single_value1 > single_value2 then                               |
;|     Print "single_value1 is bigger than single_value2"              |
;| Else If single_value1 < single_value2 Then                          |
;|     Print "single_value1 is less than single_value2"                |
;| Else                                                                |
;|     Print "single_value1 is equal to single_value2"                 |
;|                                                                     |
;|                                                                     |
;| The picture below shows                                             |
;| FPU Status Word 16-bit register (stores general condition of FPU):  |
;|                                                                     |
;|            +-----+                                                  |
;|     Bit 0  | IE  | --> Invalid operation exception                  |
;|            +-----+                                                  |
;|     Bit 1  | DE  | --> Denormalized exception                       |
;|            +-----+                                                  |
;|     Bit 2  | ZE  | --> Zero divide exception                        |
;|            +-----+                                                  |
;|     Bit 3  | OE  | --> Overflow exception                           |
;|            +-----+                                                  |
;|     Bit 4  | UE  | --> Underflow exception                          |
;|            +-----+                                                  |
;|     Bit 5  | PE  | --> Precision exception                          |
;|            +-----+                                                  |
;|     Bit 6  | SF  | --> Stack Fault exception                        |
;|            +-----+                                                  |
;|     Bit 7  | IR  | --> Interupt Request                             |
;|            +-----+                                                  |
;|     Bit 8  | C0  | --> CF (carry flag) [CONDITION CODE]             |
;|            +-----+                                                  |
;|     Bit 9  | C1  | --> =1 (stack overflow), =0 (stack underflow)    |
;|            +-----+                                                  |
;|     Bit 10 | C2  | --> PF (parity flag) [CONDITION CODE]            |
;|            +-----+                                                  |
;|     Bit 11 |     |                                                  |
;|     Bit 12 | TOP | --> Top of stack pointer                         |
;|     Bit 13 |     |                                                  |
;|            +-----+                                                  |
;|     Bit 14 | C3  | --> ZF (zero flag) [CONDITION CODE]              |
;|            +-----+                                                  |
;|     Bit 15 |  B  | --> B=1 (busy), B=0 (idle)                       |
;|            +-----+                                                  |
;|                                                                     |
;| This table shows FPU Condition Code Bits:                           |
;| +-------------+-------------------+-------------------------------+ |
;| |             |Condition Code bits|                               | |
;| | Instruction +----+----+----+----+           Condition           | |
;| |             | C3 | C2 | C1 | C0 |                               | |
;| +-------------+----+----+----+----+-------------------------------+ |
;| | fcom,       | 0  | 0  |    | 0  | st0 > source                  | |
;| | fcomp,      +----+----+----+----+-------------------------------+ |
;| | fcompp,     | 0  | 0  |    | 1  | st0 < source                  | |
;| | ficom,      +----+----+----+----+-------------------------------+ |
;| | ficomp      | 1  | 0  |    | 0  | st0 = source                  | |
;| |             +----+----+----+----+-------------------------------+ |
;| |             | 1  | 1  |    | 1  | st0 or source are undefined   | |
;| +-------------+----+----+----+----+-------------------------------+ |
;| reference: http://www.plantation-productions.com/Webster/           |
;|            www.artofasm.com/Linux/HTML/RealArithmetic.html          |
;|                                                                     |
;+---------------------------------------------------------------------+

    finit                            ;reset fpu stacks to default
    fld    dword ptr [single_value2] ;single_value2 to fpu stack(st1)
    fld    dword ptr [single_value1] ;single_value1 to fpu stack(st0)
    fcom                             ;compare st0 with st1
    fstsw  ax                        ;ax := fpu status register

    and    eax, 0100011100000000B ;take only condition code flags
    cmp    eax, 0000000000000000B ;is st0 > source ?
    je     example_11_greater
    cmp    eax, 0000000100000000B ;is st0 < source ?
    je     example_11_less
    cmp    eax, 0100000000000000B ;is st0 = source ?
    je     example_11_equal
    jmp    example_11_error      ;else, st0 or source are undefined

example_11_greater:
    print chr$("single_value1 is more than single_value2", 0aH, 00H)
    jmp    _exit

example_11_less:
    print chr$("single_value1 is less than single_value2", 0aH, 00H)
    jmp    _exit

example_11_equal:
    print chr$("single_value1 is equal to single_value2", 0aH, 00H)
    jmp    _exit

example_11_error:
    print chr$("st(0) and source are undefined!", 0aH, 00H)

;+---------------------------------------------------------------------+
;| Thats all folks :) Now exit the program!                            |
;+---------------------------------------------------------------------+
_exit:
    invoke ExitProcess, 0

end _start