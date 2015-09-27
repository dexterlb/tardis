#!/bin/zsh
dir="$(dirname "${0}")"
. "${dir}/common.sh"
. "${dir}/ip_config.sh"
if [[ -z $(fmdate '%Y%m%d') ]]; then
    # assertion failed
    exit 1
fi

logfile="/home/human/log/ip/$(fmdate '%Y%m%d').log"
match_ok='^ERROR\: Address ([0-9.]+) has not changed\.'
match_new='Updated [0-9]+ host\(s\) .+ to ([0-9.]+) in [0-9]+\.[0-9]+ seconds'

function lag {
    pinfo "lag.${1}" && return
    ping "${1}" -c 1 -w 20 | tail -1 \
        | perl -ne 'm/.+ = ([0-9.]+)\/.*/ ; print "$1\n"' | read t
    echo ${pipestatus} | read stat garb
    if [[ ! ${stat} -eq 0 ]]; then
        t="-${stat}"
    fi
    echo "${t}"
}

function dl {
    pinfo "time ip status" && return
    t1=$(date +'%s%N')
    curl -q -m20 "${url}" 2>/dev/null | read out
    echo ${pipestatus} | read stat garb
    t2=$(date +'%s%N')
    t=$(( (t2 - t1)/1000000 ))

    if [[ ${stat} -eq 0 ]]; then
        if [[ "${out}" =~ "${match_ok}" ]]
        then
            echo "${t} ${match} ok"
        elif [[ "${out}" =~ "${match_new}" ]]
        then
            echo "${t} ${match} new"
        else
            echo "${t} ? out: ${out}"
        fi
    else
        echo "-1 ? err.${stat}"
    fi
}

function report {
    echo "$(timestamp) $(lag 8.8.8.8) $(dl)"
}

case "${1}" in
    'log')
        report | savelog "${logfile}"
        ;;
    'logloop')
        trap "exit" INT
        while true; do
            report | savelog "${logfile}"
            sleep 300
        done
        ;;
    'report')
        report
        ;;
    'info')
        printinfo=42
        report
        ;;
    *)
        echo 'First argument must be (log|report|info)'
        ;;
esac
