#!/bin/bash

#Installation Age
install=$(( ($(stat -c%W /home/)) / 86400 ))
birth=$(stat / | awk '/Birth: /{print $2}')
today=$(date +%Y-%m-%d)
age=$(echo "$(( ($(date +%s) - $(stat -c%W /home/)) / 86400 ))" days)

#Uptime
up=$(awk '{m=$1/60; h=m/60; printf "%sd %sh %sm %ss", int(h/24), int(h%24), int(m%60), int($1%60) }' /proc/uptime)

#Main Output
echo -e "\033[34m┌─────────────────────── Age ────────────────────────┐\033[m"
echo -ne "\033[34mUptime: \033[m"
echo $up
echo -ne "\033[34m ├Birth Date: \033[m"
echo $birth
echo -ne "\033[34m ├Current Date: \033[m"
echo $today
echo -ne "\033[34m └Install Age: \033[m"
echo $age
echo -e "\033[34m└────────────────────────────────────────────────────┘\033[m"

