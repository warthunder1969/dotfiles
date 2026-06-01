#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo."
   exit 1
fi

# Get current swappiness value
CURRENT_SWAP=$(cat /proc/sys/vm/swappiness)

# Show Menu
CHOICE=$(whiptail --title "Linux Swappiness Manager" --menu \
"Current Swappiness: $CURRENT_SWAP\n\nSelect a new value or choose Custom:" 16 60 4 \
"10" "Optimized for SSDs (Recommended)" \
"1" "Minimum swapping (Max RAM usage)" \
"60" "Linux Default" \
"Custom" "Enter a manual value (0-100)" 3>&1 1>&2 2>&3)

# Handle selection
case $CHOICE in
    Custom)
        NEW_VAL=$(whiptail --inputbox "Enter value (0-100):" 8 45 "10" 3>&1 1>&2 2>&3)
        ;;
    "")
        echo "Cancelled."
        exit 0
        ;;
    *)
        NEW_VAL=$CHOICE
        ;;
esac

# Validate number
if ! [[ "$NEW_VAL" =~ ^[0-9]+$ ]] || [ "$NEW_VAL" -gt 100 ]; then
    whiptail --title "Error" --msgbox "Invalid value. Please enter a number between 0-100." 8 45
    exit 1
fi

# Apply setting immediately
sysctl vm.swappiness=$NEW_VAL

# Offer to make it permanent
if whiptail --title "Save Settings?" --yesno "Apply this permanently?" 10 60; then
    sed -i '/vm.swappiness/d' /etc/sysctl.d/99-swappiness.conf
    echo "vm.swappiness=$NEW_VAL" >> /etc/sysctl.d/99-swappiness.conf
    whiptail --title "Success" --msgbox "Swappiness set to $NEW_VAL permanently." 8 45
else
    whiptail --title "Success" --msgbox "Applied. Value will reset after reboot." 8 45
fi
