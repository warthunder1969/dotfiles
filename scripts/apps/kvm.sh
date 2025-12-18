#!/bin/bash
#Warthunder's QEMU/KVM installation script
#Version 1.2

# Check for Intel VT-x (vmx) or AMD-V (svm) flags in /proc/cpuinfo
if grep -E --color 'vmx|svm' /proc/cpuinfo > /dev/null; then
    echo "Hardware virtualization (Intel VT-x or AMD-V) is ENABLED."
else
    echo "Hardware virtualization (Intel VT-x or AMD-V) is DISABLED."
	echo "Error virtualization is disabled. KVM will not work without virtualization."	
fi
# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
$VM=$HOME/VMs/
$ISO=$HOME/VMs/ISOs/
# Define the Title and the Summary Message
DIALOG_TITLE="WELCOME"

# Use triple quotes for cleaner multi-line strings in the message
SCRIPT_SUMMARY="
Welcome to Warthunder's KVM Install Script!

This script is for doing the following actions:

1. Install KVM Virtual Machine Manager.
2. Put your user in the proper groups.
3. Set and restart the correct systemd services.

This script is provided as-is. Press OK to Continue.
"
dialog --clear \
    --title "$DIALOG_TITLE" \
    --msgbox "$SCRIPT_SUMMARY" 15 60 \
    2>&1 >/dev/tty

# Clear the dialog screen upon exit
clear
#Install Base Packages
echo "Installing QEMU"
sudo apt install -y bridge-utils virt-manager virtiofsd

#Add User to Necessary Groups
sudo adduser $USER libvirt
sudo adduser $USER kvm


#Enable system daemon
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

#Checking to see we're good
sudo virt-host-validate qemu
echo "QEMU Installed"

# to display the box correctly and capture the exit status.
dialog --title "Confirmation" --yesno "Do you want to Setup Directories? Location: /home/$USER/VMs  /home/$USER/VMs/ISOs"  10 30 2>/dev/tty

# Capture the exit code of the dialog command
response=$?

case $response in
    0)
        echo "User selected Yes. Proceeding..."
        mkdir -p $VM 
        ;;
    1)
        echo "No. Directories Created."
        exit 1
        ;;
    255)
        echo "Dialog box closed (e.g., by Escape key). Exiting..."
        exit 1
        ;;
esac

# to display the box correctly and capture the exit status.
dialog --title "Confirmation" --yesno "Do you want to Download Spice Guest Tools?Location: /home/$USER/VMs/ISOs" 10 30 2>/dev/tty

# Capture the exit code of the dialog command
response=$?

case $response in
    0) 
        echo "Aquiring spice guest tools ISO"
        wget -P $HOME/VMs/ISOs/ https://github.com/utmapp/qemu/releases/download/v7.0.0-utm/spice-guest-tools-0.164.4.iso
        
        ;;
    1)
        echo "No. Spice Tools Downloaded. Exiting..."
        exit 1
        ;;
    255)
        echo "Dialog box closed (e.g., by Escape key). Exiting..."
        exit 1
        ;;
esac




