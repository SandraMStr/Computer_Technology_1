.thumb_func
.global main

.equ LED1,    0
.equ LED2,    1
.equ BTN_ON,  2
.equ BTN_OFF, 3
.equ GPIO_OUT, 1
.equ GPIO_IN,  0

@ SIO-Register (RP2040 Datasheet / Buch Kapitel 9)
.equ SIO_BASE,         0xd0000000
.equ GPIO_IN_OFS,      0x004
.equ GPIO_OUT_SET_OFS, 0x014
.equ GPIO_OUT_CLR_OFS, 0x018

.equ BTN_MASK, 0x0C     @ Bit 2 + Bit 3 (GP2, GP3)
.equ LED_MASK, 0x03     @ Bit 0 + Bit 1 (GP0, GP1)

main:
    BL  stdio_init_all

    @ --- Initialisierung mit C-Funktionen (erlaubt) ---
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

    @ --- ab hier nur noch Registerzugriffe, keine C-Funktionen ---
    LDR R3, =SIO_BASE

loop:
    LDR R0, [R3, #GPIO_IN_OFS]  @ alle Pins auf einmal lesen
    MOV R1, #BTN_MASK
    AND R0, R1                  @ nur GP2 und GP3 behalten

    CMP R0, #0x08               @ GP2 = 0 (gedrückt), GP3 = 1
    BEQ leds_on
    CMP R0, #0x04               @ GP3 = 0 (gedrückt), GP2 = 1
    BEQ leds_off
    B   loop                    @ keiner (0x0C) oder beide (0x00) -> nichts tun

leds_on:
    MOV R1, #LED_MASK
    STR R1, [R3, #GPIO_OUT_SET_OFS]   @ GP0 + GP1 auf 1
    B   loop

leds_off:
    MOV R1, #LED_MASK
    STR R1, [R3, #GPIO_OUT_CLR_OFS]   @ GP0 + GP1 auf 0
    B   loop