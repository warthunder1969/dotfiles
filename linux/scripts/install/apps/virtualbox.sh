#!/bin/bash
# Installer script for Virtualbox. Should work for most Debian or Ubuntu based systems
# Version 1.2

# Dependencies
# Ensure whiptail is installed
if ! command -v whiptail >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y whiptail
fi

# Variables
ver=7.2

# Source the OS information
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Error: /etc/os-release not found."
    exit 1
fi

case "$ID" in
    ubuntu|debian)
        BASE_DISTRO=$ID
        # VERSION_CODENAME is standard for Ubuntu/Debian (e.g., jammy, bookworm)
        BASE_CODENAME=$VERSION_CODENAME
        ;;
    linuxmint)
        # Check if it's Ubuntu-based Mint or Debian-based (LMDE)
        if [ -n "$UBUNTU_CODENAME" ]; then
            BASE_DISTRO="noble"
            BASE_CODENAME=$UBUNTU_CODENAME
        elif [ -n "$DEBIAN_CODENAME" ]; then
            BASE_DISTRO="trixie"
            BASE_CODENAME=$DEBIAN_CODENAME
        else
            # Fallback for very old versions
            BASE_DISTRO="ubuntu"
            BASE_CODENAME="unknown"
        fi
        ;;
    *)
        echo "Unsupported distribution: $ID"
        exit 1
        ;;
esac

echo "$BASE_DISTRO ($BASE_CODENAME)"

# Function for the Main Menu
show_main_menu() {
    whiptail --title "Virtualbox Install Tool" --menu "Choose an action:" 15 60 5 \
    "1" "Respository (Recomended)" \
    "2" "Upstream / Latest" \
    "3" "Exit" 3>&1 1>&2 2>&3
}

# Logic Loop
while true; do
    CHOICE=$(show_main_menu)

    case $CHOICE in
        1)
            echo "Installing Virtualbox..."
            sudo apt update && sudo apt install virtualbox virtualbox-guest-additions-iso virtualbox-ext-pack
            read -p "Press enter to continue..."
            exit 0
            ;;
 		2)
            echo "Installing Latest Virtualbox..."
			echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $UBUNTU_CODENAME contrib" | sudo tee /etc/apt/sources.list.d/oracle-virtualbox.list > /dev/null
			wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg --dearmor
			sudo apt update && sudo apt install virtualbox-$ver virtualbox-guest-additions-iso virtualbox-ext-pack
            read -p "Press enter to continue..."
            exit 0
            ;;
		3|"") # Exit if chosen or if the user hits 'Cancel'
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done


