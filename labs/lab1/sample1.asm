
	.ORIG x3000
	LEA R0, DATA
	LDW R1, R0, #0
	LDW R2, R0, #1
	AND R3, R3, #0
LOOP    BRz DONE
	ADD R3, R3, R1
	ADD R2, R2, x-1    ; your code should support negative hex constants 
	BR LOOP
DONE    HALT
DATA    .FILL x0010
	.FILL x0008
	.END
	
