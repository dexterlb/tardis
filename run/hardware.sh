#!/bin/zsh

tardis_led_pin=21
stars_led_pin=22
amp_pin=17
pwm_pin=18

# set pin $1 to value $2 (can be 0, 1, or any float between 0 and 1)
function set_pin {
    echo "${1}=${2}" > /dev/pi_blaster
}
