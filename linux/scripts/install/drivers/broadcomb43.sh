#installing broadcom's terrible linux drivers
#source: https://wiki.debian.org/bcm43xx

sudo apt-get update
sudo apt-get install firmware-b43-installer firmware-b43legacy-installer
sudo modprobe -r b43
