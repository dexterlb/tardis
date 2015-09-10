#!/bin/zsh
if [[ $(whoami) == root ]]; then
    # restart the script as the correct user
    owner="$(stat -c %U "$0")"
    sudo -u "$owner" "$0" "$@"
    exit
fi

cd "$(dirname "$(readlink -f "$0")")"  # go to the dir of the script

if [[ "$1" == add ]]; then
    ./woosh.sh 1 &
fi
