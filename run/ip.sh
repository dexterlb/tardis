#!/bin/zsh
dir="$(dirname "${0}")"
. "${dir}/ip_config.sh"

match_ok='^ERROR\: Address ([0-9.]+) has not changed\.'
match_new='Updated [0-9]+ host\(s\) .+ to ([0-9.]+) in [0-9]+\.[0-9]+ seconds'

function update {
    curl -q -m20 "${url}" 2>/dev/null | read out
    echo ${pipestatus} | read response_status _

    if [[ ${response_status} -eq 0 ]]; then
        if [[ "${out}" =~ "${match_ok}" ]]; then
            echo "${match} ok"
        elif [[ "${out}" =~ "${match_new}" ]]; then
            echo "${match} new"
        else
            echo "server error: ${out}"
        fi
    else
        echo "error: #${stat}"
    fi
}

case "${1}" in
    loop)
        while true; do
            update > /tmp/last_ip
            sleep 300 || break
        done
        ;;
    update)
        update
        ;;
esac
