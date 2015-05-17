#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <linux/spi/spidev.h>
#include <linux/types.h>
#include <sys/ioctl.h>

const int cs_pin = 8;
const int clk_pin = 11;
const int data_pin = 9;

const useconds_t clock_time = 1;

int open_spi(const char* device) {
    unsigned char mode = SPI_MODE_3;
    unsigned int speed = 1000;
    unsigned char bits_per_word = 8;

    int spi_fd = open(device, O_RDWR);
    if (spi_fd < 0) {
        perror("can't open SPI device");
        exit(1);
    }
    if (ioctl(spi_fd, SPI_IOC_RD_MODE, &mode) < 0) {
        perror("can't set SPI read mode");
        exit(1);
    }
    if (ioctl(spi_fd, SPI_IOC_RD_BITS_PER_WORD, &bits_per_word) < 0) {
        perror("can't set SPI read bits per word");
        exit(1);
    }
    if (ioctl(spi_fd, SPI_IOC_RD_MAX_SPEED_HZ, &speed) < 0) {
        perror("can't set SPI read speed");
        exit(1);
    }

    return spi_fd;
}

uint16_t get_data(int spi_fd) {
    uint16_t data;
    if (read(spi_fd, &data, sizeof(data)) < 0) {
        perror("can't read data from SPI");
    }
    data >>= 3;
    data &= 1023;
    return data;
}

int main(int argc, char* argv[]) {
    int spi_fd = open_spi("/dev/spidev0.0");
    printf("%d\n", get_data(spi_fd));
    close(spi_fd);
   
    return 0;
}
