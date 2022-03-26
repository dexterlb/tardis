#pragma once

#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>

typedef void (*generator_t)(void*, uint8_t);
typedef void (*event_t)(void*);

typedef struct proto_encoder_state {
    generator_t out;
    uint8_t bit_counter;
    uint8_t active_byte;
    uint8_t checksum;
    uint8_t byte_counter;
    void* user_state;
} proto_encoder_state_t;

typedef struct proto_decoder_state {
    generator_t out;
    event_t end;
    event_t err;
    uint8_t bit_counter;
    uint8_t active_byte;
    uint8_t checksum;
    uint8_t byte_counter;
    void* user_state;
} proto_decoder_state_t;

typedef struct proto_sync_output {
    size_t n;
    uint8_t buf[3];
    bool end;
    bool err;
} proto_sync_output_t;


void proto_decoder_init(proto_decoder_state_t* p, void* user_state, generator_t out, event_t end, event_t err);
void proto_decoder_init_sync(proto_decoder_state_t* p, proto_sync_output_t* out);
uint8_t proto_decoder_push(proto_decoder_state_t* p, uint8_t byte);
void proto_decoder_push_bytes(proto_decoder_state_t* p, uint8_t* buf, size_t n);

void proto_encoder_init(proto_encoder_state_t* p, void* user_state, generator_t out);
void proto_encoder_init_sync(proto_encoder_state_t* p, proto_sync_output_t* out);
void proto_encoder_push(proto_encoder_state_t* p, uint8_t byte);
void proto_encoder_end(proto_encoder_state_t* p);
void proto_encoder_push_bytes(proto_encoder_state_t* p, uint8_t* buf, size_t n);

bool proto_sync_pop(proto_sync_output_t* out, uint8_t* byte);
bool proto_sync_end(proto_sync_output_t* out);
bool proto_sync_err(proto_sync_output_t* out);
void proto_sync_clear(proto_sync_output_t* out);
