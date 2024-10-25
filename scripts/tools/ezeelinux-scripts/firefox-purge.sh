#/bin/bash

# Script to remove Firefox from Ubuntu and Linux Mint and replace it with
# Google Chrome. If Firefox has already been opened, remove configuration
# files and caches with: "rm -r .mozilla .cache/mozilla" for each user's 
# home directory.
# By Joe Collins. (www.ezeelinux.com GNU/General Public License version 2.0)

# Get Gdebi if not already installed:

dpkg -l | grep -qw gdebi || sudo apt-get install -yyq gdebi

# Remove Firefox:

sudo apt purge firefox -yy
sudo apt purge firefox-locale-en -yy
if [ -d "/home/$USER/.mozilla" ]; then
	rm -rf /home/$USER/.mozilla
fi
if [ -d "/home/$USER/.cache/mozilla" ]; then
	rm -rf /home/$USER/.cache/mozilla
fi

# Download and install Google Chrome:

mkdir /tmp/gc-install-tmp
pushd /tmp/gc-install-tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi -n google-chrome-stable_current_amd64.deb
popd
rm -rf /tmp/gc-install-tmp

exit
