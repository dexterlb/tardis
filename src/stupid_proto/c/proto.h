#pragma once

#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>

typedef void (*generator_t)(uint8_t);
typedef void (*event_t)();

typedef struct {
    generator_t out;
    uint8_t bit_counter;
    uint8_t active_byte;
    uint8_t checksum;
    uint8_t byte_counter;
} proto_encoder_state_t;

typedef struct {
    generator_t out;
    event_t end;
    event_t err;
    uint8_t bit_counter;
    uint8_t active_byte;
    uint8_t checksum;
    uint8_t byte_counter;
} proto_decoder_state_t;


void proto_decoder_init(proto_decoder_state_t* p, generator_t out, event_t end, event_t err);
uint8_t proto_decoder_push(proto_decoder_state_t* p, uint8_t byte);
void proto_decoder_push_bytes(proto_decoder_state_t* p, uint8_t* buf, size_t n);

void proto_encoder_init(proto_encoder_state_t* p, generator_t out);
void proto_encoder_push(proto_encoder_state_t* p, uint8_t byte);
void proto_encoder_end(proto_encoder_state_t* p);
void proto_encoder_push_bytes(proto_encoder_state_t* p, uint8_t* buf, size_t n);
