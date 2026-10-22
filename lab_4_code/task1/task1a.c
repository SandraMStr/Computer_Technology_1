
#include "pico/stdlib.h"

#define LED     0
#define BTN_ON  1
#define BTN_OFF 2

int main() {
    stdio_init_all();

    gpio_init(LED);
    gpio_set_dir(LED, GPIO_OUT);

    gpio_init(BTN_ON);
    gpio_set_dir(BTN_ON, GPIO_IN);
    gpio_pull_up(BTN_ON);

    gpio_init(BTN_OFF);
    gpio_set_dir(BTN_OFF, GPIO_IN);
    gpio_pull_up(BTN_OFF);

    while (true) {
        bool on  = !gpio_get(BTN_ON);    // gedrückt = 0 wegen Pull-up
        bool off = !gpio_get(BTN_OFF);

        if (on && !off)       gpio_put(LED, 1);
        else if (off && !on)  gpio_put(LED, 0);
    }
}
