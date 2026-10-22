.thumb_func
.global main

.equ LED1,    0
.equ LED2,    1
.equ BTN_ON,  2
.equ BTN_OFF, 3
.equ GPIO_OUT, 1
.equ GPIO_IN,  0

main:
    BL  stdio_init_all

    @ --- LEDs als Ausgang ---
    MOV R0, #LED1
    BL  gpio_init
    MOV R0, #LED1
    MOV R1, #GPIO_OUT
    BL  link_gpio_set_dir

    MOV R0, #LED2
    BL  gpio_init
    MOV R0, #LED2
    MOV R1, #GPIO_OUT
    BL  link_gpio_set_dir

    @ --- Buttons als Eingang mit Pull-up ---
    MOV R0, #BTN_ON
    BL  gpio_init
    MOV R0, #BTN_ON
    MOV R1, #GPIO_IN
    BL  link_gpio_set_dir
    MOV R0, #BTN_ON
    BL  link_gpio_pull_up

    MOV R0, #BTN_OFF
    BL  gpio_init
    MOV R0, #BTN_OFF
    MOV R1, #GPIO_IN
    BL  link_gpio_set_dir
    MOV R0, #BTN_OFF
    BL  link_gpio_pull_up

loop:
    MOV R0, #BTN_ON
    BL  link_gpio_get
    MOV R4, R0              @ R4 = GP2 (0 = gedrückt)

    MOV R0, #BTN_OFF
    BL  link_gpio_get
    MOV R5, R0              @ R5 = GP3 (0 = gedrückt)

    CMP R4, #0
    BNE check_off           @ GP2 nicht gedrückt -> GP3 prüfen
    CMP R5, #0
    BEQ loop                @ beide gedrückt -> ignorieren

    @ LEDs einschalten
    MOV R0, #LED1
    MOV R1, #1
    BL  link_gpio_put
    MOV R0, #LED2
    MOV R1, #1
    BL  link_gpio_put
    B   loop

check_off:
    CMP R5, #0
    BNE loop                @ keiner gedrückt
    @ LEDs ausschalten
    MOV R0, #LED1
    MOV R1, #0
    BL  link_gpio_put
    MOV R0, #LED2
    MOV R1, #0
    BL  link_gpio_put
    B   loop
    
