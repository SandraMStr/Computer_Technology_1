@
@ Assembler program to flash three LEDs connected to the
@ Raspberry Pi Pico GPIO port using the Pico SDK.
@

	.EQU	SEQ_PINA, 0
	.EQU	SEQ_PINB, 1
	.EQU	SEQ_PINC, 2
	.EQU	SEQ_PIND, 3
	.EQU	SEQ_PINE, 4
	.EQU	SEQ_PINF, 5
	.EQU	SEQ_PING, 6
	.EQU	GPIO_OUT, 1
	.EQU	sleep_time, 1000

.thumb_func	@ Necessary because sdk uses BLX
.global main    @ Provide program starting address

main:	@ initializing

	MOV	R0, #SEQ_PINA
	BL	gpio_init
	MOV	R0, #SEQ_PINA
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir
	
	MOV	R0, #SEQ_PINB
	BL	gpio_init
	MOV	R0, #SEQ_PINB
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir
	
	MOV	R0, #SEQ_PINC
	BL	gpio_init
	MOV	R0, #SEQ_PINC
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir
	
	MOV	R0, #SEQ_PIND
	BL	gpio_init
	MOV	R0, #SEQ_PIND
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir
	
	MOV	R0, #SEQ_PINE
	BL	gpio_init
	MOV	R0, #SEQ_PINE
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir
	
	MOV	R0, #SEQ_PINF
	BL	gpio_init
	MOV	R0, #SEQ_PINF
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir
	
	MOV	R0, #SEQ_PING
	BL	gpio_init
	MOV	R0, #SEQ_PING
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir
	
	MOV		R4, #0		@ start at 000, current num 
	MOV 	R5, #1 		@ counting upwards (1), counting down (0)
	
	
show_num:  
	CMP 	R4, #0
	BEQ 	digit0
	
	CMP 	R4, #1
	BEQ		digit1
	
	CMP 	R4, #2
	BEQ 	digit2
	
	CMP 	R4, #3
	BEQ		digit3
	
	CMP 	R4, #4
	BEQ 	digit4
	
	CMP 	R4, #5
	BEQ		digit5
	
	CMP 	R4, #6
	BEQ 	digit6
	
	CMP 	R4, #7
	BEQ		digit7

	CMP 	R4, #8
	BEQ 	digit8
	
	CMP 	R4, #9
	BEQ		digit9
	
digit0:
	MOV		R6, #0b00111111
	B 		display
	
digit1:
	MOV		R6, #0b00000110
	B		display
	
digit2:
	MOV		R6, #0b01011011
	B		display

digit3: 
	MOV 	R6, #0b01001111
	B 		display
	
digit4:
	MOV 	R6, #0b01100110
	B 		display
	
digit5:
	MOV		R6, #0b01101101
	B 		display
	
digit6:
	MOV		R6, #0b01111101
	B 		display
	
digit7:
	MOV		R6, #0b00000111
	B 		display

digit8:
	MOV 	R6, #0b01111111
	B       display
	
digit9:
	MOV		R6, #0b01101111
	B 		display
	
	
display:
	MOV		R0, #SEQ_PINA
	MOV		R1, R6
	MOV		R2, #1
	AND 	R1, R2
	BL		link_gpio_put	
	
	MOV		R0, #SEQ_PINB
	MOV		R1, R6
	LSR		R1, R1, #1
	MOV		R2, #1
	AND 	R1, R2
	BL		link_gpio_put		 
	
	MOV		R0, #SEQ_PINC
	MOV		R1, R6
	LSR		R1, R1, #2
	MOV		R2, #1
	AND 	R1, R2
	BL		link_gpio_put	
 
 	MOV		R0, #SEQ_PIND
	MOV		R1, R6
	LSR		R1, R1, #3
	MOV		R2, #1
	AND 	R1, R2
	BL		link_gpio_put		 
	
	MOV		R0, #SEQ_PINE
	MOV		R1, R6
	LSR		R1, R1, #4
	MOV		R2, #1
	AND 	R1, R2
	BL		link_gpio_put
	
	MOV		R0, #SEQ_PINF
	MOV		R1, R6
	LSR		R1, R1, #5
	MOV		R2, #1
	AND 	R1, R2
	BL		link_gpio_put		 
	
	MOV		R0, #SEQ_PING
	MOV		R1, R6
	LSR		R1, R1, #6
	MOV		R2, #1
	AND 	R1, R2
	BL		link_gpio_put


	LDR		R0, =sleep_time
	BL 		sleep_ms
	
		@ counting up or down
	CMP 	R5, #1
	BEQ		count_up
	
count_down:
	SUB 	R4, R4, #1
	CMP 	R4, #0
	BNE 	show_num
	
	MOV 	R5, #1		@ 000 reached, counting up again
	B       show_num
	
	
count_up:
	ADD 	R4, R4, #1
	CMP 	R4, #9
	BNE		show_num
	
	MOV 	R5, #0
	B 		show_num
