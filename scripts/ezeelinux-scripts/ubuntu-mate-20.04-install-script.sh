#!/bin/bash

# Ubuntu (MATE) 20.04 generic setup script.
# By Joe Collins. (www.ezeelinux.com GNU/General Public License version 2.0)

# Must have Gdebi!:

dpkg -l | grep -qw gdebi || sudo apt-get install -yyq gdebi

# First, let's install a bunch of software:

sudo apt install -yy openssh-server sshfs net-tools gedit-plugin-text-size \
simplescreenrecorder libreoffice ubuntu-restricted-extras vlc gthumb \
spell synaptic brasero git mc gedit timeshift htop thunderbird \
rhythmbox-plugin-cdrecorder gparted pavucontrol handbrake audacity \
lame flac sound-juicer soundconverter cowsay


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

sudo apt purge deja-dup pluma shotwell -yy

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

# Brasero-Ubuntu 18.04 Bug fix
# (This is a hold-over and may not be needed but doesn't hurt to run anyway.)

# Set permissions thusly to enable audio CD writing in Ubuntu 18.04:

sudo chmod 4711 /usr/bin/cdrdao
sudo chmod 4711 /usr/bin/wodim
sudo chmod 0755 /usr/bin/growisofs

# Gotta reboot now:

echo $'\n'$"*** All done! Please reboot now. ***"
exit

