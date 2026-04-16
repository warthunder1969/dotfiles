#!/bin/bash
# init
#Source: https://kobusvs.co.za/blog/power-profile-switching/
#Packages
echo 'Installing packages'
sudo apt install power-profiles-daemon

echo '***Power Management Installed!***'

# Display menu options
while true; do

read -p "Do you want Automatic Power Profile Switching? (y/n) " yn

case $yn in 
	[yY] ) echo ok, we will proceed;
        #installing dependencies        
        sudo apt install inotify-tools -y

cat << EOF > /home/$USER/.local/bin/power-monitor.sh
#! /bin/bash

BAT=$(echo /sys/class/power_supply/BAT*)
BAT_STATUS="$BAT/status"
BAT_CAP="$BAT/capacity"
LOW_BAT_PERCENT=50

AC_PROFILE="balanced"
BAT_PROFILE="balanced"
LOW_BAT_PROFILE="power-saver"

# wait a while if needed
[[ -z $STARTUP_WAIT ]] || sleep "$STARTUP_WAIT"

# start the monitor loop
prev=0

while true; do
	# read the current state
	if [[ $(cat "$BAT_STATUS") == "Discharging" ]]; then
		if [[ $(cat "$BAT_CAP") -gt $LOW_BAT_PERCENT ]]; then
			profile=$BAT_PROFILE
		else
			profile=$LOW_BAT_PROFILE
		fi
	else
		profile=$AC_PROFILE
	fi

	# set the new profile
	if [[ $prev != "$profile" ]]; then
		echo setting power profile to $profile
		powerprofilesctl set $profile
	fi

	prev=$profile

	# wait for the next power change event
	inotifywait -qq "$BAT_STATUS" "$BAT_CAP"
done
EOF
chmod +x /home/$USER/.local/bin/power-monitor.sh

cat << EOF > /etc/systemd/system/power-monitor.service
[Service]
Environment=STARTUP_WAIT=30s
ExecStart=/home/$USER/.local/bin/power_monitor.sh

[Install]
WantedBy=default.target
EOF

        systemctl enable power-monitor.service
        systemctl start power-monitor.service
 
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac

exit 0
