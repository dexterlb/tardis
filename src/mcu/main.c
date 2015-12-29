#include "hardware.h"

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#include "bit_operations.h"


uint8_t spi_readWrite(uint8_t data)
{
    uint8_t result = 0;
    while (bitset(PIND, 0));
    for (int8_t i = 7; i >= 0; i--) {
        setbitval(PORTB, 6, data & (1 << i));
        while (bitclear(PINB, 7));
        result |= (!bitclear(PINB, 5) << i);
        while (bitset(PINB, 7));
    }
    return result;
}

static inline void init(void)
// main init
{
    DDRB = DDRB_STATE;
    DDRD = DDRD_STATE;

	// sei();
}


int main(void)
{
    init();
    PORTD = 0;
    // main loop
    uint8_t data;

    // setbit(MISO_PORT, MISO_PIN);
    // PORTB |= (1 << 6);
    // setbit(PORTB, 6);
    // setbit(MISO_PORT, MISO_PIN);    // WTF?! this doesn't work?????
    for (;;) {
        /*
        _delay_ms(3000);
        PORTD = 0xFF;
        _delay_ms(3000);
        PORTD = 0x00;
        */
        data = spi_readWrite(42);
        data = spi_readWrite(data + 1);
        if (data) {
            PORTD = data;
        }
    }
    return 0;
}
