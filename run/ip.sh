#!/bin/zsh
dir="$(dirname "${0}")"
. "${dir}/ip_config.sh"

function update_single {
    python "${dir}"/Digital-Ocean-Dynamic-DNS-Updater/updater.py \
        "${token}" "${domain}" "${1}" A
}

function update {
    for subdomain in ${subdomains}; do
        update_single "${subdomain}"
    done
}

case "${1}" in
    loop)
        while true; do
            update
            sleep "${interval}" || break
        done
        ;;
    update)
        update
        ;;
esac
