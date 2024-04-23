#Surface Kernel Installation
# See Github: https://github.com/linux-surface/linux-surface/wiki/Installation-and-Setup
#Debian / Ubuntu setup
#import the keys
wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
    | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/linux-surface.gpg

#add the repository configuration and update APT
echo "deb [arch=amd64] https://pkg.surfacelinux.com/debian release main" \
	| sudo tee /etc/apt/sources.list.d/linux-surface.list
sudo apt update

#Now you can install the linux-surface kernel and its dependencies
sudo apt install linux-image-surface linux-headers-surface libwacom-surface iptsd


