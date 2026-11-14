#!/bin/bash

# Ensure terminal tools are installed
if ! command -v whiptail &> /dev/null; then
    echo "This script requires 'whiptail' (part of the ncurses suite). Installing..."
    sudo apt-get update && sudo apt-get install -y whiptail
fi

# Define title for all boxes
TITLE="NTSYNC Driver Environment Manager"

# 1. Check Kernel Version (Must be newer than 6.14)
KERNEL_VER=$(uname -r)
MAJOR=$(echo "$KERNEL_VER" | cut -d. -f1)
MINOR=$(echo "$KERNEL_VER" | cut -d. -f2)

if [ "$MAJOR" -lt 6 ] || { [ "$MAJOR" -eq 6 ] && [ "$MINOR" -le 14 ]; }; then
    whiptail --title "$TITLE" --msgbox \
    "ERROR: Your Linux kernel version ($KERNEL_VER) is not newer than 6.14.\n\nNTSYNC requires a standard upstream kernel 6.15+ or a custom 6.14 package built with it explicitly enabled." 12 60
    exit 1
fi

# 2. Check if ntsync driver is currently loaded in memory
if lsmod | grep -q "^ntsync"; then
    whiptail --title "$TITLE" --msgbox \
    "✓ Success!\n\nThe kernel version check passed ($KERNEL_VER) and the 'ntsync' driver is already LOADED and ACTIVE.\n\nYour system is fully ready for high-performance Wine/Proton gaming." 12 60
    exit 0
fi

# 3. Interactive Ncurses-style Menu using Whiptail
CHOICE=$(whiptail --title "$TITLE" --menu \
"The kernel version check passed ($KERNEL_VER), but the 'ntsync' driver is NOT currently active.\n\nChoose how you would like to proceed:" 16 65 3 \
"1" "Load ntsync temporarily (This session only)" \
"2" "Enable ntsync permanently (Load automatically on boot)" \
"3" "Exit without changes" 3>&1 1>&2 2>&3)

case "$CHOICE" in
    1)
        # Temporary load
        if sudo modprobe ntsync 2>/dev/null; then
            whiptail --title "$TITLE" --msgbox "✓ Success! The 'ntsync' driver has been successfully loaded into memory for this session." 10 60
        else
            whiptail --title "$TITLE" --msgbox "ERROR: Failed to load the 'ntsync' module via modprobe.\n\nPlease verify that your 6.15+ kernel was compiled with CONFIG_NTSYNC enabled." 12 60
            exit 1
        fi
        ;;
    2)
        # Permanent load
        if echo "ntsync" | sudo tee /etc/modules-load.d/ntsync.conf > /dev/null; then
            if sudo modprobe ntsync 2>/dev/null; then
                whiptail --title "$TITLE" --msgbox "✓ Success!\n\n1. Configured automatic boot loading at /etc/modules-load.d/ntsync.conf\n2. Successfully activated the driver for this session." 12 60
            else
                whiptail --title "$TITLE" --msgbox "WARNING: Permanent configuration file saved, but the driver failed to load immediately right now. A system reboot may be required to activate it." 12 60
            fi
        else
            whiptail --title "$TITLE" --msgbox "ERROR: Failed to write to /etc/modules-load.d/ntsync.conf. Please ensure you have root administrative privileges." 12 60
            exit 1
        fi
        ;;
    3|*)
        # Exit
        whiptail --title "$TITLE" --msgbox "Exiting. No modifications were made to your system." 10 60
        exit 0
        ;;
esac
