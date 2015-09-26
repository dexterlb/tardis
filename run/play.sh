#!/bin/zsh
cd "$(dirname "$(readlink -f "$0")")"  # go to the dir of the script

. ./hardware.sh

trap "amp_power pop" SIGINT SIGTERM

amp_power push
play "${@}" &>/dev/null
amp_power pop
