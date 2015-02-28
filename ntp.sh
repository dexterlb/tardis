#!/bin/zsh
trap "exit" INT
/usr/bin/ntpd -gq
sleep 60
while true; do
    /usr/bin/ntpd -gq
    sleep 1600
done
