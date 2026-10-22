
#include "hardware/gpio.h"

void link_gpio_set_dir(int pin, int dir) { gpio_set_dir(pin, dir); }
void link_gpio_pull_up(int pin)          { gpio_pull_up(pin); }