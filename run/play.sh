#!/bin/zsh
cd "$(dirname "$(readlink -f "$0")")"  # go to the dir of the script

. ./hardware.sh

function light_fx {
    start_time=$(date +%s.%N)

    set_led_strength 0
    tardis_led on

    {
        while read time value; do
            sleep $(( start_time + time - $(date +%s.%N) )) &>/dev/null
            set_led_strength "${value}"
        done

        tardis_led off
    } &
}

if [[ -n "${1}" ]]; then
    trap "amp_power pop ; exit" SIGINT SIGTERM

    amp_power push
    if [[ -f "${1}.light" ]]; then
        light_fx < "${1}.light"
    fi
    play "${@}" &>/dev/null
    amp_power pop
fi
