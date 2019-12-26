#include "proto.h"
#include <stdio.h>

uint8_t mask(uint8_t n) {
    return (1 << n) - 1;
}

void proto_decoder_zero(proto_decoder_state_t* p) {
    p->bit_counter = 0;
    p->checksum = 0;
    p->byte_counter = 0;
}

void proto_decoder_init(proto_decoder_state_t* p, generator_t out, event_t end, event_t err) {
    p->out = out;
    p->end = end;
    p->err = err;
    proto_decoder_zero(p);
}

uint8_t proto_decoder_push(proto_decoder_state_t* p, uint8_t byte) {
    if (byte & 0x1) {
        // end bit is set - finalise the message
        if (byte == (0x1 | (uint8_t)(p->checksum << 1))) {
            p->end();
        } else {
            p->err();
        }
        proto_decoder_zero(p);
        return 1;
    } else {
        byte >>= 1;
        p->active_byte = (p->active_byte & mask(p->bit_counter))
            | byte << p->bit_counter;
        if (p->bit_counter != 0) {
            p->checksum += (p->byte_counter++ ^ p->active_byte);
            p->out(p->active_byte);
            p->active_byte = byte >> (8 - p->bit_counter);
        }
        p->bit_counter = (p->bit_counter + 7) % 8;
        return 0;
    }
}

void proto_decoder_push_bytes(proto_decoder_state_t* p, uint8_t* buf, size_t n) {
    for (size_t i = 0; i < n; i++) {
        proto_decoder_push(p, buf[i]);
    }
}

void proto_encoder_zero(proto_encoder_state_t* p) {
    p->active_byte = 0;
    p->bit_counter = 0;
    p->checksum = 0;
    p->byte_counter = 0;
}

void proto_encoder_init(proto_encoder_state_t* p, generator_t out) {
    p->out = out;
    proto_encoder_zero(p);
}

void proto_encoder_push(proto_encoder_state_t* p, uint8_t byte) {
    p->checksum += (p->byte_counter++ ^ byte);
    p->out(((p->active_byte & mask(p->bit_counter)) | (byte << p->bit_counter)) << 1);
    p->active_byte = byte >> (7 - p->bit_counter);
    p->bit_counter = (1 + p->bit_counter) % 7;
    if (p->bit_counter == 0) {
        p->out(p->active_byte << 1);
    }
}

void proto_encoder_end(proto_encoder_state_t* p) {
    uint8_t checksum = p->checksum;
    if (p->bit_counter != 0) {
        proto_encoder_push(p, 0);
    }
    p->out(0x1 | (checksum << 1));
    proto_encoder_zero(p);
}

void proto_encoder_push_bytes(proto_encoder_state_t* p, uint8_t* buf, size_t n) {
    for (size_t i = 0; i < n; i++) {
        proto_encoder_push(p, buf[i]);
    }
}
