#!/usr/bin/env sh
# Installer script for Vivaldi. Should work for most Debian or Ubuntu based systems
# Version 1.1

# Ensure Whiptail is installed
if ! command -v whiptail &> /dev/null; then
    apt update && apt install -y newt
fi

# Show menu and capture selection
CHOICE=$(whiptail --title "Zed Editor Installer" --menu "Choose your preferred installation method:" 15 60 4 \
"1" "Official Package (TAR) - Recommended" \
"2" "Flatpak (Unofficial)" \
"3" "Exit" 3>&1 1>&2 2>&3)

case $CHOICE in
    1)
        echo "Installing via APT Package..."
        curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
        echo "deb https://debian.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list
        sudo apt update
        sudo apt install -y zed
        ;;
    2)
        echo "Installing via Flatpak..."
        apt update && apt install flatpak -y
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org
        flatpak install flathub dev.zed.Zed -y
        ;;
    *)
        echo "Installation cancelled."
        exit 0
        ;;
esac

echo "Zed Editor installation complete."
