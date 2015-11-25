#include <avr/io.h>

#define F_CPU 12000000ul

#include <util/delay.h>

static inline void init(void)
// main init
{
    DDRD = 0x00;    // all outputs
}

int main(void)
{
    init();

    // main loop
    for (;;) {
        PORTD = 0xFF;
        _delay_us(1000000);
        PORTD = 0x00;
        _delay_us(1000000);
    }
    return 0;
}
