@
@ Assembler program print out "Hello World"
@ using the Pico SDK.
@
@ R0 - first parameter to printf
@ R1 - second parameter to printer
@ R7 - index counter
@

.thumb_func		    @ Necessary because sdk uses BLX
.global main	            @ Provide program starting address to linker

main:
	BL	stdio_init_all	@ initialize uart or usb
	
loop1:
	MOV	R7, #101
	
loop2:
	LDR	R0, =helloworld	@ load address of helloworld string
	SUB	R7, #1		@ Increment counter
	MOV	R1, R7		@ Move the counter to second parameter
	BL	printf		@ Call pico_printf
	CMP R7, #0
	BNE loop2
	B	loop1		@ loop forever
		
.data
.align  4	@ necessary alignment
helloworld: .asciz   "Hello World %d\n"
