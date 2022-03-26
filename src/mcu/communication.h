#pragma once

#include "hardware.h"

typedef void (*msg_processor_t)(uint8_t*, uint8_t);
void communication_init(msg_processor_t);
void communication_send(uint8_t*, uint8_t);
