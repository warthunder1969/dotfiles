
NVIDIA drivers

1. Using Sid
===

# Prepare sources
# Append sid source to the end of the sources file # optional enable contrib to the other sources! 
$ sudo -e /etc/apt/sources.list 
deb http://deb.debian.org/debian/ sid main contrib non-free deb-src 
http://deb.debian.org/debian/ sid main contrib non-free
 # Create a preferences file to only install nvidia-legacy drivers and keep your distribution stable 
$ sudo -e /etc/apt/preferences 
Package: * 
Pin: release a=stable 
Pin-Priority: 700

Package: * 
Pin: release a=testing 
Pin-Priority: 650

Package: * 
Pin: release a=unstable,sid 
Pin-Priority: 600 

# Install

$ sudo apt update 
$ sudo apt install linux-headers-amd64 
$ sudo apt install -t sid nvidia-legacy-340xx-driver 

# Precaution

$ sudo apt-mark hold *nvidia*

2. Using buster-backports
===

$ sudo -e /etc/apt/sources.list

deb http://deb.debian.org/debian buster-backports main contrib non-free 
deb-src http://deb.debian.org/debian buster-backports main contrib non-free 	

$ sudo apt update 	 	
$ sudo apt install -t buster-backports nvidia-legacy-340xx-driver 
$ sudo apt-mark hold *nvidia* 
$ sudo apt install linux-headers-amd64

# If you get this error after booting:
systemd-modules-load: Error running install command 'modprobe -i nvidia-legacy-340xx ' for module nvidia: retcode 1 
systemd-modules-load: Failed to insert module 'nvidia': Invalid argument 
systemd-modules-load: modprobe: FATAL: Module nvidia-legacy-340xx not found in directory /lib/modules/5.10.0-21-amd64 

# boot to rescue mode (this is why i setup root password)
# get a wifi conection 
$ nmtui 
# reinstall 
$ sudo apt reinstall linux-headers-amd64 nvidia-legacy-340xx-driver nvidia-legacy-340xx-kernel*

