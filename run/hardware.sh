#!/bin/zsh

tardis_led_pin=13   # gpio-21
stars_led_pin=15    # gpio-22
amp_pin=11          # gpio-17
pwm_pin=12          # gpio-18

pwm_width=20000

function set_pin {
    if [[ "$2" == on ]]; then
        state=1
    elif [[ "$2" == off ]]; then
        state=0
    else
        state="$2"
    fi

    microseconds=$(( ${state} * ${pwm_width} ))
    echo "P1-${1}=${microseconds%%.*}us" > /dev/servoblaster
}

function light_strength {
    set_pin "${pwm_pin}" $(( 1 - ${1} ))
}

function amp_power {
    set_pin ${amp_pin} ${1}
}
