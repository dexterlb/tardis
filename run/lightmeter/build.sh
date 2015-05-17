#!/bin/zsh
gcc -Wall --std=gnu11 adc.c -lbcm2835 && sudo mv a.out /usr/local/bin/adc
