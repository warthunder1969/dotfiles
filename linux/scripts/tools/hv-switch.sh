#!/bin/bash
# hv-switch.sh : Switch between VirtualBox and KVM/VMware
#source: https://wiki.blablalinux.be/fr/conflit-hyperviseurs-kvm-virtualbox-linux
set -euo pipefail

# Colors for readability
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}ERROR: This script must be run with 'sudo'.${NC}"
    exit 1
fi


# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi
# Define the menu items: "Tag" "Description"
OPTIONS=(
    1 "VirtualBox Mode (Release CPU resources)"
    2 "KVM / VMware Mode (Re-enable all)"
)

# Use dialog to display a menu box and capture the user's choice
CHOICE=$(dialog --clear --title "Hypervisor Conflict Manager" \
    --menu "Please Select a Hypervisor:" 15 50 4 "${OPTIONS[@]}" \
    2>&1 >/dev/tty)

# Clear the dialog screen upon exit
clear

case "$CHOICE" in
    1)
        # Stopping VMware and removing KVM modules
        systemctl stop vmware 2>/dev/null || true
        modprobe -r kvm_intel 2>/dev/null || modprobe -r kvm_amd 2>/dev/null || true
        modprobe -r kvm 2>/dev/null || true
        echo -e "${GREEN}KVM disabled. VirtualBox can now start.${NC}"
        ;;
    2)
        # Identifying CPU and reloading KVM modules
        if grep -q vmx /proc/cpuinfo; then 
            modprobe kvm_intel
        elif grep -q svm /proc/cpuinfo; then 
            modprobe kvm_amd
        fi
        systemctl start vmware 2>/dev/null || true
        echo -e "${GREEN}KVM/VMware reactivated.${NC}"
        ;;
    *)
        echo -e "${RED}Invalid selection.${NC}"
        exit 1
        ;;
esac
