#!/bin/bash

# Linux Mint 20 generic setup script.
# By Joe Collins. (www.ezeelinux.com GNU/General Public License version 2.0)

# First, let's install a bunch of software:

sudo apt install -yy openssh-server sshfs spell brasero git mc vlc lame flac \
simplescreenrecorder ttf-mscorefonts-installer htop sound-juicer soundconverter \
rhythmbox-plugin-cdrecorder gparted pavucontrol handbrake audacity cowsay

# Install all local .deb packages, if available:

if [ -d "/home/$USER/Downloads/Packages" ]; then
	echo "Installing local .deb packages..."
	pushd /home/$USER/Downloads/Packages
	for FILE in ./*.deb
    do
        sudo gdebi -n "$FILE"
    done
	popd
else
	echo $'\n'$"WARNING! There's no ~/Downloads/Packages directory."
	echo "Local .deb packages can't be automatically installed."
	sleep 5 # The script pauses so this message can be read.
fi

# Remove undesirable packages:

# none

# Purge Firefox, install Google Chrome:

sudo apt purge firefox -yy
sudo apt purge firefox-locale-en -yy
if [ -d "/home/$USER/.mozilla" ]; then
	rm -rf /home/$USER/.mozilla
fi
if [ -d "/home/$USER/.cache/mozilla" ]; then
	rm -rf /home/$USER/.cache/mozilla
fi
mkdir /tmp/gc-install-tmp
pushd /tmp/gc-install-tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi -n google-chrome-stable_current_amd64.deb
popd
rm -rf /tmp/gc-install-tmp

# Sound "pop and click" fix. Set sound card to stay powered on all the time:

sudo bash -c "echo 'options snd-hda-intel power_save=0 power_save_controller=N' \
>> /etc/modprobe.d/alsa-base.conf"

# Gotta reboot now:

echo $'\n'$"*** All done! Please reboot now. ***"
exit
