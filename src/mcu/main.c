#include "hardware.h"

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#include "bit_operations.h"


void spi_init() {
    // we are clocked externally by the master
    USICR = (1 << USIWM0) | (1 << USICS1);
}

uint8_t spi_readWrite(uint8_t data)
{
    while (bitset(PIND, 3));    // we are a slave, so wait for Slave Select
    USIDR = data;
    setbit(USISR, USIOIF);
    while (bitclear(USISR, USIOIF));
    return USIDR;
}

static inline void init(void)
// main init
{
    DDRB = DDRB_STATE;
    DDRD = DDRD_STATE;

    spi_init();
	// sei();
}


int main(void)
{
    init();
    PORTD = 0;
    // main loop
    uint8_t data = 42;

    for (;;) {
        data = spi_readWrite(data * 2);
        if (data) {
            PORTD = data;
        }
    }
    return 0;
}
