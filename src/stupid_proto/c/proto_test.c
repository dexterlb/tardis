#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>

#include "proto.h"

void print_bits(uint8_t x) {
    for (uint8_t j = 0; j < 8; j++) {
        printf("%d", (int)(x >> j) & 0x1);
    }
}
void print_bytes(uint8_t* buf, size_t n) {
    for (size_t i = 0; i < n; i++) {
        print_bits(buf[i]);
        printf(" ");
    }
    printf("\n");
}

void sandbox() {
    // uint8_t test[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11, 12, 13, 14, 15};
    uint8_t test[] = "";
    // uint8_t test[] = "foo";
    uint8_t encoded[50];
    size_t enc_size = 0;

    print_bytes(test, strlen((const char*)test));

    proto_encoder_state_t enc;

    void enc_out(uint8_t data) {
        encoded[enc_size++] = data;
    }

    proto_encoder_init(&enc, enc_out);
    proto_encoder_push_bytes(&enc, test, strlen((const char*)test));
    proto_encoder_end(&enc);

    print_bytes(encoded, enc_size);

    void dec_out(uint8_t data) {
        print_bits(data);
        printf(" ");
    }

    void dec_end() {
        printf("$");
    }

    void dec_err() {
        printf("!");
    }

    proto_decoder_state_t dec;
    proto_decoder_init(&dec, dec_out, dec_end, dec_err);
    proto_decoder_push_bytes(&dec, encoded, enc_size);
    printf("\n");
}

int do_encode() {
    proto_encoder_state_t enc;

    void out(uint8_t data) {
        write(1, &data, 1);
    }

    proto_encoder_init(&enc, out);

    uint8_t data;
    while (read(0, &data, 1) == 1) {
        if (data == '\n') {
            proto_encoder_end(&enc);
        } else {
            proto_encoder_push(&enc, data);
        }
    }

    return 0;
}

int do_decode() {
    proto_decoder_state_t dec;

    void out(uint8_t data) {
        write(1, &data, 1);
    }

    void end() {
        write(1, "\n", 1);
    }

    void err() {
        write(1, "<err>\n", 6);
    }

    proto_decoder_init(&dec, out, end, err);

    uint8_t data;
    while (read(0, &data, 1) == 1) {
        proto_decoder_push(&dec, data);
    }

    return 0;
}

int do_usage(char* name) {
    fprintf(stderr, "usage: %s (encode|decode|sandbox)\n", name);
    return 1;
}

int main(int argc, char* argv[]) {
    if (argc == 2 && (strcmp("encode", argv[1]) == 0)) {
        return do_encode();
    }
    if (argc == 2 && (strcmp("decode", argv[1]) == 0)) {
        return do_decode();
    }
    if (argc == 2 && (strcmp("sandbox", argv[1]) == 0)) {
        sandbox();
        return 0;
    }
    return do_usage(argv[0]);
}
