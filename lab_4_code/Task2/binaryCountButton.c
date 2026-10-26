#include <stdio.h>
#include "pico/stdio.h"
#include "hardware/gpio.h"
#include "hardware/timer.h"
#include "hardware/irq.h"
#include "pico/time.h"

#define LED1 1
#define LED2 2
#define LED3 3
#define LED4 4

#define BUTTON_UP 5
#define BUTTON_DOWN 6

volatile int counter = 0;


void button_callback(uint gpio, uint32_t events)
{
	if (events & GPIO_IRQ_EDGE_FALL)
	{
		if (gpio == BUTTON_UP)
		{
			if (counter < 15)
			{ 
				counter++;
			}
		}
		
		else if (gpio == BUTTON_DOWN)
		{
			if (counter > 0)
			{
				counter--;
			}
		}
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
	
	gpio_init(BUTTON_UP);
	gpio_set_dir(BUTTON_UP, GPIO_IN);
	gpio_pull_up(BUTTON_UP);
	
	gpio_init(BUTTON_DOWN);
	gpio_set_dir(BUTTON_DOWN, GPIO_IN);
	gpio_pull_up(BUTTON_DOWN);
	
	gpio_set_irq_enabled_with_callback(
		BUTTON_UP,
		GPIO_IRQ_EDGE_FALL,
		true,
		&button_callback
	);
	
	gpio_set_irq_enabled_with_callback(
		BUTTON_DOWN,
		GPIO_IRQ_EDGE_FALL,
		true,
		&button_callback
	);
	
	
	while(true)
	{
		int value = counter;
		
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
