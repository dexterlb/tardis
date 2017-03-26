#!/bin/zsh
dir="$(dirname "${0}")"
. "${dir}/ip_config.sh"

function update_single {
    curl -s -m20 "https://dynamicdns.park-your-domain.com/update?host=${1}&domain=${domain}&password=${password}" \
        | grep -vF '<ErrCount>0</ErrCount>'
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
