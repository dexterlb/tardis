#include "hardware.h"

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#include "simple_uart.h"
#include "bit_operations.h"

ISR(USART_RX_vect) {
    char x = uart_read_byte();

    if (x == 'a') {
        setbitval(PORTB, 1, bitclear(PORTB, 1));
    }
    if (x == 's') {
        setbitval(PORTB, 2, bitclear(PORTB, 2));
    }
    if (x == 'd') {
        setbitval(PORTB, 0, bitclear(PORTB, 0));
    }
    if (x == 'f') {
        setbitval(PORTB, 3, bitclear(PORTB, 3));
    }
    char bla[] = "[.]";
    bla[1] = x;
    uart_write_string(bla);
}

const uint16_t pwm_top = 0xffff;

static inline void timer1_init(void) {
    // use OC1A for fast PWM, no prescaler
    TCCR1A = (1 << COM1A0) | (1 << COM1A1) |
             (0 << COM1B0) | (0 << COM1B1) |
             (0 << WGM10)  | (1 << WGM11);

    TCCR1B = (1 << WGM12) | (1 << WGM13) |
             (1 << CS10)  | (0 << CS11)  | (0 << CS12);

    // Top value
    ICR1 = pwm_top;

    // PWM value
    OCR1A = 0xfffe;
}

static inline void init(void)
{
    DDRB = DDRB_STATE;
    DDRD = DDRD_STATE;

    timer1_init();
    uart_init();
    uart_enable_interrupt();
	sei();
}


int main(void)
{
    init();

    for (int i = 0; i < 3; i++) {
        _delay_ms(500);
        setbit(PORTB, 1);
        _delay_ms(500);
        clearbit(PORTB, 1);
    }

    for (;;) {
        _delay_ms(1);
        OCR1A = OCR1A + 10;
    }
    return 0;
}
