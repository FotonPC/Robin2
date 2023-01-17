include console.inc
;12.21
COMMENT *  
   Заготовка программы
*
.data
 	
params	macro p1,p2,p3,p4,p5
	ifnb <p1>
p1	equ dword ptr [ebp]+8
	endif
	ifnb <p2>
p2	equ dword ptr [ebp]+12
	endif
	ifnb <p3>
p3	equ dword ptr [ebp]+16
	endif
	ifnb <p4>
p4	equ dword ptr [ebp]+20
	endif
	ifnb <p5>
p5	equ dword ptr [ebp]+24
	endif
	endm

params0	macro p1,p2,p3,p4,p5
	local l1
        l1=4
for p,<p1,p2,p3,p4,p5>
  ifnb <p>
        l1=l1+4  
;p	textequ <dword ptr [ebp]+>,@CatStr(%l1)
;p	textequ <dword ptr [ebp+>,%l1,<]>
p	textequ <dword ptr [ebp]+>,%l1
;echo p
;%echo p
;echo dword ptr [ebp]+l1
  endif
endm
	endm

.code
pp	proc 
	params0 x,y,z
	push ebp
	mov ebp, esp	
;echo x
;%echo x
	outwordln x
	outwordln y
	outwordln z
	pop ebp
	ret 12
pp	endp

Start:
        ClrScr
        ConsoleTitle "   Заготовка программы"
	push 111
	push 222
	push 333
	call pp
                    exit
   end Start