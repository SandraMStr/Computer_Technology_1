.thumb_func
.global main

main:
	BL	stdio_init_all
	
loop:
	LDR	R0, =my_array
	MOV	R1, #8			@ 8 elements in the array
	BL	average
	
	@Print string and average value
	MOV	R1, R0
	LDR R0, =message_str
	BL	printf
	B 	loop
	
@average takes two parameter:
@R0 - memory address of first element of array
@R1 - number of integers in the array
@R0 - return value (average)
average: 
	PUSH {R4, LR}	@ store base address
	MOV R2, #0		@ sum
	MOV	R4, R0		@ base address
	
sum:
	LDR	R3, [R4]	@ load number in register from memory
	ADD R4, R4, #4	@ update memory address
	ADD	R2, R2, R3	@ add to sum
	SUB R1, R1, #1	@ decrease counter
	CMP R1, #0		@ counter = 0 -> all 8 numbers are added
	BNE sum
	
	MOV R0, R2
	LSR	R0, #3		@divide by 2³ = 8
	
	POP {R4, PC}	@ go back to calling line
	
.data
	.align	4	
	message_str: .asciz	"Average value %d\n"
	.align 4
	my_array: .word 10, 20, 30, 40, 50, 60, 70, 80
