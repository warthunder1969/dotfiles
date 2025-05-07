#Replace/Disable PulseAudio with PipeWire
#Source: https://trendoceans.com/enable-pipewire-and-disable-pulseaudio-in-ubuntu/

echo "This script will replace Pulseaudio with Pipewire on Linux Mint 21 or Ubuntu 22.04 based systems"
echo "Please note - you should backup your system in case of failure with Timeshift or some other method"
echo "Your sudo password will be required during this script. Please have it ready."
echo "NOTE: Do not execute this script with SUDO. If you have end the script immediately and launch without sudo"
read -p "Press any key to resume or CTRL+C to end..."

#Get Updates and Ensure Pipewire is at least installed
sudo apt update
sudo apt-get install-y pipewire

#Check Audio Server Status

systemctl --user status pipewire pipewire-session-manager
pactl info | grep 'Server Name'
echo "If the output does not read 'Pulseaudio' do not continue."
read -p "Press any key to resume or CTRL+C to end..."

#Install the Audio Client and a Few Extra Libraries

sudo apt-get install gstreamer1.0-pipewire libpipewire-0.3-{0,dev,modules} libspa-0.2-{bluetooth,dev,jack,modules} pipewire{,-{audio-client-libraries,pulse,bin,tests}}

#Install WirePlumber

sudo apt-get install wireplumber gir1.2-wp-0.4 libwireplumber-0.4-{0,dev}

#Disable and Enable PipeWire

sudo cp -vRa /usr/share/pipewire /etc/
systemctl --user --now enable pipewire{,-pulse}.{socket,service}

#Verify
pactl info | grep 'Server Name'

exit 0
