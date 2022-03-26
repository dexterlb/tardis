#include "proto.h"
#include <stdio.h>

uint8_t mask(uint8_t n) {
    return (1 << n) - 1;
}

void proto_sync_push(proto_sync_output_t* out, uint8_t x) {
    if (out->n < sizeof(out->buf)) {
        out->buf[out->n] = x;
        for (int i = out->n - 1; i >= 0; i--) {
            x = out->buf[i + 1];
            out->buf[i + 1] = out->buf[i];
            out->buf[i] = x;
        }
        out->n++;
    } else {
        out->err = true;
    }
}

void proto_decoder_zero(proto_decoder_state_t* p) {
    p->bit_counter = 0;
    p->checksum = 0;
    p->byte_counter = 0;
}

void proto_decoder_init(proto_decoder_state_t* p, void* user_state, generator_t out, event_t end, event_t err) {
    p->out = out;
    p->end = end;
    p->err = err;
    p->user_state = user_state;
    proto_decoder_zero(p);
}

void proto_decoder_generator_sync_out(void* user_state, uint8_t x) {
    proto_sync_push((proto_sync_output_t*)user_state, x);
}

void proto_decoder_generator_sync_end(void* user_state) {
    ((proto_sync_output_t*)user_state)->end = true;
}

void proto_decoder_generator_sync_err(void* user_state) {
    ((proto_sync_output_t*)user_state)->err = true;
}

void proto_decoder_init_sync(proto_decoder_state_t* p, proto_sync_output_t* out) {
    proto_sync_clear(out);
    out->n = 0;

    proto_decoder_init(p,
        (void*)out,
        proto_decoder_generator_sync_out,
        proto_decoder_generator_sync_end,
        proto_decoder_generator_sync_err
    );
}

uint8_t proto_decoder_push(proto_decoder_state_t* p, uint8_t byte) {
    if (byte & 0x1) {
        // end bit is set - finalise the message
        if (byte == (0x1 | (uint8_t)(p->checksum << 1))) {
            p->end(p->user_state);
        } else {
            p->err(p->user_state);
        }
        proto_decoder_zero(p);
        return 1;
    } else {
        byte >>= 1;
        p->active_byte = (p->active_byte & mask(p->bit_counter))
            | byte << p->bit_counter;
        if (p->bit_counter != 0) {
            p->checksum += (p->byte_counter++ ^ p->active_byte);
            p->out(p->user_state, p->active_byte);
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

void proto_encoder_init(proto_encoder_state_t* p, void* user_state, generator_t out) {
    p->out = out;
    p->user_state = user_state;
    proto_encoder_zero(p);
}

void proto_encoder_generator_sync_out(void* user_state, uint8_t x) {
    proto_sync_push((proto_sync_output_t*)user_state, x);
}

void proto_encoder_init_sync(proto_encoder_state_t* p, proto_sync_output_t* out) {
    proto_sync_clear(out);
    out->n = 0;

    proto_encoder_init(p, (void*)out, proto_encoder_generator_sync_out);
}

void proto_encoder_encode(proto_encoder_state_t* p, uint8_t byte, bool pad) {
    p->checksum += (p->byte_counter++ ^ byte);
    p->out(
        p->user_state,
        ((p->active_byte & mask(p->bit_counter)) | (byte << p->bit_counter)) << 1
    );
    p->active_byte = byte >> (7 - p->bit_counter);
    p->bit_counter = (1 + p->bit_counter) % 7;
    if (pad && p->bit_counter == 0) {
        p->out(p->user_state, p->active_byte << 1);
    }
}

void proto_encoder_push(proto_encoder_state_t* p, uint8_t byte) {
    proto_encoder_encode(p, byte, true);
}

void proto_encoder_end(proto_encoder_state_t* p) {
    uint8_t checksum = p->checksum;
    if (p->bit_counter != 0) {
        proto_encoder_encode(p, 0, p->bit_counter != 6);
    }
    p->out(p->user_state, 0x1 | (checksum << 1));
    proto_encoder_zero(p);
}

void proto_encoder_push_bytes(proto_encoder_state_t* p, uint8_t* buf, size_t n) {
    for (size_t i = 0; i < n; i++) {
        proto_encoder_push(p, buf[i]);
    }
}

bool proto_sync_pop(proto_sync_output_t* out, uint8_t* byte) {
    if (out->n == 0) {
        return false;
    }
    *byte = out->buf[--out->n];
    return true;
}

bool proto_sync_end(proto_sync_output_t* out) {
    return (out->n == 0) && (out->end || out->err);
}

bool proto_sync_err(proto_sync_output_t* out) {
    return (out->n == 0) && (out->err);
}

void proto_sync_clear(proto_sync_output_t* out) {
    out->end = false;
    out->err = false;
}
