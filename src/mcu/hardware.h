#pragma once

#define F_CPU 12000000ull

// 1 - out, 0 - in   v bits v
//                   76543210
#define DDRB_STATE 0b01000000
#define DDRD_STATE 0b11111100

#define MISO_PORT PORTB
#define MISO_PIN 6

#define MOSI_IN PINB
#define MOSI_PIN 5

#define SCK_IN PINB
#define SCK_PIN 7
