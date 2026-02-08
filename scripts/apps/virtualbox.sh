#!/bin/bash
# Installer script for Virtualbox. Should work for most Debian or Ubuntu based systems
# Version 1.1

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
            BASE_DISTRO="ubuntu"
            BASE_CODENAME=$UBUNTU_CODENAME
        elif [ -n "$DEBIAN_CODENAME" ]; then
            BASE_DISTRO="debian"
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
    whiptail --title "VirtualBox Installer" --menu "Choose an action:" 15 60 5 \
    "1" "Debian/Ubuntu Repo (Broken)" \
    "2" "Oracle Repository (Latest VirtualBox)" \
    "3" "Exit" 3>&1 1>&2 2>&3
}

# Logic Loop
while true; do
    CHOICE=$(show_main_menu)

    case $CHOICE in
        1)
            echo "This Version of Virtualbox is broken after Kernel 6.14. The DKMS Modules will fail to build. Virtualbox 7.2+ is required for support on 6.17+"
            echo "Proceed at your own risk. To Cancel Simply Press CTRL+C."
            read -p "Press enter to continue..."
            echo "Installing Virtualbox..."
            sudo apt update && sudo apt install virtualbox virtualbox-guest-additions-iso virtualbox-ext-pack
            sudo usermod -aG vboxusers $USER  
            exit 0
            ;;
 		2)
            echo "Adding Oracle Repository..."
            # Download and add Oracle's GPG key
            wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor -o /usr/share/keyrings/oracle-virtualbox-2016.gpg
            # Add the repository using the system's codename (e.g., noble, trixe)
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | tee /etc/apt/sources.list.d/virtualbox.list
            sudo apt update && sudo apt install -y virtualbox $ver
            sudo usermod -aG vboxusers $USER  
            echo "VirtualBox (Oracle Repo) installed."
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


