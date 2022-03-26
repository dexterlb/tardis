#include "hardware.h"

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#include "bit_operations.h"
#include "communication.h"

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

typedef struct {
    uint8_t selmask;
    uint16_t pwm;
    uint8_t speed;
} msg_t;

void process_message(uint8_t* msg, uint8_t n) {
    char bla[] = "[.]";
    bla[1] = msg[0];
    communication_send((uint8_t*)bla, 3);
}

static inline void init(void)
{
    DDRB = DDRB_STATE;
    DDRD = DDRD_STATE;

    timer1_init();
    communication_init(process_message);
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
