#include <avr/io.h>
#include <avr/interrupt.h>
#include "communication.h"
#include "simple_uart.h"
#include "bit_operations.h"
#include "proto.h"

proto_decoder_state_t proto_dec;
proto_encoder_state_t proto_enc;
uint8_t proto_buf[5];
uint8_t proto_idx;

void on_err(void* proc) {
    proto_idx = 0;
}

void on_end(void* proc) {
    ((msg_processor_t)proc)(proto_buf, proto_idx);
}

void on_data(void* proc, uint8_t x) {
    if (proto_idx < sizeof(proto_buf)) {
        proto_buf[proto_idx++] = x;
    } else {
        on_err(proc);
    }
}

void on_enc(void* _, uint8_t x) {
    uart_write_byte(x);
}

ISR(USART_RX_vect) {
    proto_decoder_push(&proto_dec, uart_read_byte());
}

void communication_send(uint8_t* buf, uint8_t n) {
    for (uint8_t i = 0; i < n; i++) {
        proto_encoder_push(&proto_enc, buf[i]);
    }
    proto_encoder_end(&proto_enc);
}

void communication_init(msg_processor_t proc) {
    uart_init();
    uart_enable_interrupt();
    proto_decoder_init(&proto_dec, (void*)proc, on_data, on_end, on_err);
    proto_encoder_init(&proto_enc, NULL, on_enc);
    proto_idx = 0;
}
