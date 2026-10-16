@
@ Assembler program to flash three LEDs connected to the
@ Raspberry Pi Pico GPIO port using the Pico SDK.
@

	.EQU	LED_PIN1, 0
	.EQU	LED_PIN2, 1
	.EQU	LED_PIN3, 2
	.EQU	GPIO_OUT, 1
	.EQU	sleep_time, 1000

.thumb_func	@ Necessary because sdk uses BLX
.global main    @ Provide program starting address

main:	@ initializing

	MOV	R0, #LED_PIN1
	BL	gpio_init
	MOV	R0, #LED_PIN1
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir
	
	MOV	R0, #LED_PIN2
	BL	gpio_init
	MOV	R0, #LED_PIN2
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir
	
	MOV	R0, #LED_PIN3
	BL	gpio_init
	MOV	R0, #LED_PIN3
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir
	
	MOV		R4, #0		@ start at 000, current num in dec
	MOV 	R5, #1 		@ counting upwards (1), counting down (0)
	
	
show_num:   
		@ first bit (LED)
	MOV		R0, #LED_PIN1
	MOV		R1, R4
	MOV 	R2, #1
	AND 	R1, R2
	BL		link_gpio_put
	
		@ second bit (LED)
	MOV 	R0, #LED_PIN2
    MOV     R1, R4
    LSR     R1, R1, #1
    MOV 	R2, #1
    AND     R1, R2
    MOV     R0, #LED_PIN2
    BL      link_gpio_put	
	
		@ third bit (LED)
	MOV 	R0, #LED_PIN3
    MOV     R1, R4
    LSR     R1, R1, #2
    MOV 	R2, #1
    AND     R1, R2
    MOV     R0, #LED_PIN3
    BL      link_gpio_put	

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
	CMP 	R4, #7
	BNE		show_num
	
	MOV 	R5, #0
	B 		show_num
