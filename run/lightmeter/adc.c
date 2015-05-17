#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>

#include <bcm2835.h>

const int cs_pin = RPI_GPIO_P1_24;      // gpio 8
const int clk_pin = RPI_GPIO_P1_23;     // gpio 11
const int data_pin = RPI_GPIO_P1_21;    // gpio 9

const useconds_t clock_time = 1;
const useconds_t delay_between_reads = 250000;

const size_t buf_size = 5;
const char out_file[] = "/tmp/adc";

void init() {
    if (!bcm2835_init()) {
        fprintf(stderr, "can't init bcm2835");
        exit(1);
    }

    bcm2835_gpio_fsel(cs_pin, BCM2835_GPIO_FSEL_OUTP);
    bcm2835_gpio_fsel(clk_pin, BCM2835_GPIO_FSEL_OUTP);
    bcm2835_gpio_fsel(data_pin, BCM2835_GPIO_FSEL_INPT);

    bcm2835_gpio_write(cs_pin, HIGH);
    bcm2835_gpio_write(clk_pin, HIGH);
}

int get_data() {
    int data = 0;

    usleep(clock_time);
    bcm2835_gpio_write(clk_pin, LOW);
    bcm2835_gpio_write(cs_pin, LOW);

    for (int i = 0; i < 13; i++) {
        usleep(clock_time);
        bcm2835_gpio_write(clk_pin, HIGH);
        usleep(clock_time);
        bcm2835_gpio_write(clk_pin, LOW);
        
        data <<= 1;
        data |= bcm2835_gpio_lev(data_pin);  // push the data bit at the right side
    }

    bcm2835_gpio_write(cs_pin, HIGH);
    bcm2835_gpio_write(clk_pin, HIGH);

    // data is in the form: ? ? 0 x x x x x x x x x x
    //                          ^ |_|_|_|_|_|_|_|_|_|__ 10 data bits  
    //                          |
    //                          null bit
    if ((data >> 10) & 1) {
        return -1;  // NULL bit is not zero :(
    }
    return data & 1023;
}

float avg(int* numbers, size_t size) {
    int sum;
    for (size_t i = 0; i < size; i++) {
        sum += numbers[i];
    }
    return (float)sum / size;
}

int main(int argc, char* argv[]) {
    init();

    int position = 0;
    int buf[buf_size];

    for (int i = 0; i < buf_size; i++) {
        buf[i] = 0;
    }

    while (1) {
        buf[position++] = get_data();
        if (position >= buf_size) {
            position = 0;
        }

        FILE* out = fopen(out_file, "w");
        fprintf(out, "%1.3f\n", avg(buf, buf_size) / 1024);
        fclose(out);

        usleep(delay_between_reads);
    }

    return 0;
}
