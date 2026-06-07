#!/bin/bash
#Warthunder's Virtual Machine Manager installation script
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
Welcome to Warthunder's Virtual-Manager Install Script!

This script is for doing the following actions:

1. Install Virtual Machine Manager.
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
sudo apt update
echo "Installing"
sudo apt install -y qemu-kvm libvirt-clients libvirt-daemon-system virt-manager ovmf swtpm swtpm-tools virtiofsd bridge-utils
#Add user to the right group(s)
sudo usermod -aG libvirt $USER
sudo chown $USER:$USER /var/run/libvirt/libvirt-sock
#Enable system daemon
sudo systemctl enable --now libvirtd
sudo systemctl restart libvirtd

#Start Virtual Network      
sudo virsh net-start default
sudo virsh net-autostart default

# Check Package actually installed
if ! command -v virt-manager &> /dev/null; then
    echo "Error: virt-manager is not installed." >&2
    exit 1
fi 
echo "Virt-Manager Installed"  
sudo virt-host-validate qemu

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
clear
# to display the box correctly and capture the exit status.
dialog --title "Confirmation" --yesno "Do you want to Download Spice Guest Tools?Location: /home/$USER/VMs/ISOs" 10 30 2>/dev/tty

# Capture the exit code of the dialog command
response=$?

case $response in
    0) 
        echo "Aquiring spice guest tools ISO"
        wget -P $HOME/VMs/ISOs/ https://github.com/utmapp/qemu/releases/download/v7.0.0-utm/spice-guest-tools-0.164.4.iso
        clear
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




