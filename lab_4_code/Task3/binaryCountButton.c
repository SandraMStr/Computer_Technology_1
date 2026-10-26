#include <stdio.h>
#include "pico/stdio.h"
#include "hardware/gpio.h"
#include "hardware/timer.h"
#include "hardware/irq.h"
#include "pico/time.h"

#define BUTTON_RESET 0

#define LED1 1
#define LED2 2
#define LED3 3
#define LED4 4


volatile int counter = 0;


bool timer_callback(struct repeating_timer *t)
{
	if (counter < 15)
	{
		counter++;
	}	
	
	return true;
}	
	


void button_callback(uint gpio, uint32_t events)
{
	if (gpio == BUTTON_RESET && (events & GPIO_IRQ_EDGE_FALL))
	{
		counter = 0;
	}	
	
}


int main()
{
	gpio_init(LED1);
	gpio_set_dir(LED1, GPIO_OUT); 

	gpio_init(LED2);
	gpio_set_dir(LED2, GPIO_OUT);
	
	gpio_init(LED3);
	gpio_set_dir(LED3, GPIO_OUT);
	
	gpio_init(LED4);
	gpio_set_dir(LED4, GPIO_OUT);
	
	gpio_init(BUTTON_RESET);
	gpio_set_dir(BUTTON_RESET, GPIO_IN);
	gpio_pull_up(BUTTON_RESET);
	
	gpio_set_irq_enabled_with_callback(
		BUTTON_RESET,
		GPIO_IRQ_EDGE_FALL,
		true,
		&button_callback
	);
	
	struct repeating_timer timer;
	
	add_repeating_timer_ms(
		1000,
		timer_callback,
		NULL,
		&timer
	);
	
	while(true)
	{
		int value = counter;
			

		printf("counter: %d\n", value);

		
		//bitshift um 0, nur niedrigstes Bit durch (& 1)
		gpio_put(LED1, (value >> 0) & 1);	
		//bitshift um 1, nur niedrigstes Bit durch (& 1)
		gpio_put(LED2, (value >> 1) & 1);
		gpio_put(LED3, (value >> 2) & 1);
		gpio_put(LED4, (value >> 3) & 1);
		
		sleep_ms(10);
	}
	
	return 0;
}
