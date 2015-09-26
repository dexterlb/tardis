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
    tail "${@}" /tmp/adc 2>/dev/null | while read darkness; do
        printf '%.3g\n' $(( 1 - darkness ))  # round to 3 digits
    done
}

function set_led_strength {
    echo "${1}" > /tmp/last_led_strength
    set_pin "${pwm_pin}" $(( 1 - ${1} ))
}

function led_strength {
    if cat /tmp/last_led_strength 2>/dev/null; then :
    else
        echo 1. | tee /tmp/last_led_strength
    fi
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

function amp_power_clients {
    cat /tmp/amp_power_clients 2>/dev/null
}

function amp_power {
    if [[ "${1}" == push ]]; then
        if [[ $(amp_power_clients) -lt 1 ]]; then
            set_pin ${amp_pin} on
        fi
        echo $(( $(amp_power_clients) + 1 )) > /tmp/amp_power_clients
    elif [[ "${1}" == pop ]]; then
        if [[ $(cat /tmp/amp_power_clients) -le 1 ]]; then
            set_pin ${amp_pin} off
        fi
        echo $(( $(amp_power_clients) - 1 )) > /tmp/amp_power_clients
    elif [[ "${1}" == 1 || "${1}" == on ]]; then
        if [[ $(amp_power_clients) -lt 1 ]]; then
            echo 1 > /tmp/amp_power_clients
        fi
        set_pin ${amp_pin} on
    elif [[ "${1}" == 0 || "${1}" == off ]]; then
        rm -f /tmp/amp_power_clients
        set_pin ${amp_pin} off
    fi
}
