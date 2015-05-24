#!/bin/zsh

tardis_led_pin=13   # gpio-21
stars_led_pin=15    # gpio-22
amp_pin=11          # gpio-17
pwm_pin=12          # gpio-18

pwm_width=2000

fade_step_time=0.025

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

function lightness {
    printf '%.3g\n' $(( 1 - $(cat /tmp/adc) ))  # round to 3 digits
}

function set_led_strength {
    echo "${1}" > /tmp/last_led_strength
    set_pin "${pwm_pin}" $(( 1 - ${1} ))
}

function led_strength {
    if [[ ! -f /tmp/last_led_strength ]]; then
        echo 1 > /tmp/last_led_strength
    fi
    cat /tmp/last_led_strength
}

function led_fade {
    before=$(led_strength)
    after=${1}
    step_count=$(( ${2} / fade_step_time ))
    step_count=${step_count%%.*}                # convert to int
    step=$(( (after - before) / step_count ))
    
    for i in {1..${step_count}}; do
        sleep ${fade_step_time}
        set_led_strength $(( before + ( i * step ) ))
    done
}

function amp_power {
    set_pin ${amp_pin} ${1}
}
