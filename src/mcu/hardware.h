#pragma once

#define F_CPU 12000000ull
#define BAUDRATE 19200

// 1 - out, 0 - in   v bits v
//                   76543210
#define DDRB_STATE 0b00001111
#define DDRD_STATE 0b00010110
