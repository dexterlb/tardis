#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <syslog.h>
#include <sys/wait.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "bcm2835.h"


uint8_t HW_init(uint32_t spi_speed) {
	uint16_t sp;

	sp=(uint16_t)(250000L/spi_speed);
	if (!bcm2835_init()) {
		printf("error initializing\n");
		return 0;
	}

	bcm2835_spi_begin();
	bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_MSBFIRST);
	bcm2835_spi_setDataMode(BCM2835_SPI_MODE0);
	bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_65536);
	bcm2835_spi_chipSelect(BCM2835_SPI_CS0);
	bcm2835_spi_setChipSelectPolarity(BCM2835_SPI_CS0, LOW);
	return 1;
}

int main(int argc, char *argv[]) {
	uint32_t spi_speed=5000L;

	if (!HW_init(spi_speed)) {
        fprintf(stdout, "can't open SPI\n");
		return 1;
	}

    char buff[2];
    for (int i = 0; i < 50; i++) {
        buff[0] = 0xbe;
        buff[1] = 56;
        bcm2835_spi_transfern(buff,2);
        printf("pair: 0x%02x 0x%02x\n", buff[0], buff[1]);
    }

	bcm2835_spi_end();
	bcm2835_close();

	return 0;

}
