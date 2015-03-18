#!/bin/zsh
sdate=$(date +'%s' | perl -pe 's/([0-9]+)[0-9]$/${1}0/')

function pinfo {
    if [[ -z ${printinfo} ]]; then
        return 1;
    else
        echo "${1}"
        return 0
    fi
}

function fmdate {
    date -u +"${1}" -d "@${sdate}"
}

function timestamp {
    pinfo "time_t y-m-d.utc h:m:s.utc" && return

    fmdate '%s %Y-%m-%d %H:%M:%S'
}

function savexz {
    if [[ -z "${1}" ]]; then
        return 1
    fi
    mkdir -p "$(dirname "${1}")"
    xz -9c >> "${1}"
}

function savelog {
    if [[ -z "${1}" ]]; then
        return 1
    fi
    mkdir -p "$(dirname "${1}")"
    cat >> "${1}"
}
