#include <stdio.h>

#define GPIO_OUT 0x40050000

void set_gpio(uint32_t pin, uint32_t value) { 
    volatile uint32_t* out = (volatile uint32_t*) GPIO_OUT;
    volatile uint32_t* ready = (volatile uint32_t*) GPIO_READY;

    while ((*ready & 1) == 0) {
    }
    
    if (value == 1) {
        *out = *out | (1 << pin);
    }
    else {
        *out = *out & ~(1 << pin);
    }
}
