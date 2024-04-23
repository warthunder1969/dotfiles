#!/bin/bash

echo "*****************************"
echo "*       Warthunders's       *"
echo "*  30-Day Distro Longhaul   *"
echo "*****************************"
#Shenanigans, comment out if problems exist

neofetch
#lsb_release -a| grep Description

#Display Date and Time, Install Date/Age
now="$(date +'%Y-%m-%d')"
printf "Current date: %s\n" "$now"

install="$(stat / | grep "Birth" | sed 's/Birth: //g' | cut -b 2-11)"
printf "Install date: %s\n" "$install"

#Calculate age since Installed
#In days
aged="$(( ($(date --date=$now +%s) - $(date --date=$install +%s) )/(60*60*24) ))"
printf "Install age in days: %s\n" "$aged"

