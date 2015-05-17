#include <stdio.h>
#include <wiringPi.h>
#include <stdint.h>
#include <unistd.h>

const int cs_pin = 8;
const int clk_pin = 11;
const int data_pin = 9;

const useconds_t clock_time = 1;

int get_data() {
    int data = 0;

    usleep(clock_time);
    digitalWrite(clk_pin, LOW);
    digitalWrite(cs_pin, LOW);

    for (int i = 0; i < 13; i++) {
        usleep(clock_time);
        digitalWrite(clk_pin, HIGH);
        usleep(clock_time);
        digitalWrite(clk_pin, LOW);
        
        data <<= 1;
        data |= digitalRead(data_pin);  // push the data bit at the right side
    }

    digitalWrite(cs_pin, HIGH);
    digitalWrite(clk_pin, HIGH);

    if ((data >> 10) & 1) {
        return -1;  // NULL bit is not zero :(
    }
    return data & 1023;
}

int main(int argc, char* argv[]) {
    wiringPiSetupGpio();

    pinMode(cs_pin, OUTPUT);
    pinMode(clk_pin, OUTPUT);
    pinMode(data_pin, INPUT);

    digitalWrite(cs_pin, HIGH);
    digitalWrite(clk_pin, HIGH);

    printf("%d\n", get_data());
   
    return 0;
}
