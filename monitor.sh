#!/bin/zsh

router=192.168.1.1

cd "$(dirname "$(readlink -f "${0}")")"

function macs_data {
    echo 'macs:'
    curl -silent -u admin:no_password \
        http://${router}/DHCPTable.htm \
        | perl -ne 'print "$1\n" if m/(([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2}))/' \
        | sort
}

old_macs=$(macs_data)

function device_connected {
    aplay media/tardis_on.wav &> /dev/null
}

function device_disconnected {
    # aplay media/tardis_off.wav &> /dev/null
}

function monitor {
    trap "exit" INT
    while true; do
        new_macs=$(macs_data)

        mac_diff="$(diff <(echo ${old_macs}) <(echo ${new_macs}))"

        if echo ${mac_diff} | grep '<' > /dev/null; then
            device_disconnected
        fi

        if echo ${mac_diff} | grep '>' > /dev/null; then
            device_connected
            date >> /tmp/wtf
            echo "${mac_diff}" >> /tmp/wtf
        fi

        old_macs=${new_macs}
        sleep 5
    done
}

monitor
