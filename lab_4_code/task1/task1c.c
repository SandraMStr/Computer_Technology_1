
#include "pico/stdlib.h"

#define SIO_BASE          0xd0000000
#define SIO_GPIO_IN       (*(volatile uint32_t *)(SIO_BASE + 0x004))
#define SIO_GPIO_OUT_SET  (*(volatile uint32_t *)(SIO_BASE + 0x014))
#define SIO_GPIO_OUT_CLR  (*(volatile uint32_t *)(SIO_BASE + 0x018))


#define LED     0
#define LED2    6                                   // NEU
#define BTN_ON  1
#define BTN_OFF 2

#define LED_MASK  ((1u << LED) | (1u << LED2))      // GEÄNDERT

int main() {
    stdio_init_all();

    gpio_init(LED);     gpio_set_dir(LED, GPIO_OUT);
    gpio_init(LED2);    gpio_set_dir(LED2, GPIO_OUT);   // NEU
    gpio_init(BTN_ON);  gpio_set_dir(BTN_ON, GPIO_IN);  gpio_pull_up(BTN_ON);
    gpio_init(BTN_OFF); gpio_set_dir(BTN_OFF, GPIO_IN); gpio_pull_up(BTN_OFF);

    while (true) {
        uint32_t in = SIO_GPIO_IN;
        bool on  = !(in & (1u << BTN_ON));
        bool off = !(in & (1u << BTN_OFF));

        if (on && !off)       SIO_GPIO_OUT_SET = LED_MASK;
        else if (off && !on)  SIO_GPIO_OUT_CLR = LED_MASK;
    }
}
