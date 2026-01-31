#!/bin/bash
# Installer script for Vivaldi. Should work for most Debian or Ubuntu based systems
# Version 1.0

# Ensure Whiptail is installed
if ! command -v whiptail &> /dev/null; then
    apt update && apt install -y newt
fi

# Show menu and capture selection
CHOICE=$(whiptail --title "Vivaldi Installer" --menu "Choose your preferred installation method:" 15 60 4 \
"1" "Official Repository (APT) - Recommended" \
"2" "Flatpak (Sandboxed via Flathub)" \
"3" "Exit" 3>&1 1>&2 2>&3)

case $CHOICE in
    1)
        echo "Installing via Official Repository..."
        wget -qO- https://repo.vivaldi.com | gpg --dearmor | tee /usr/share/keyrings/vivaldi-browser.gpg > /dev/null
        echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=amd64] https://repo.vivaldi.com stable main" | tee /etc/apt/sources.list.d/vivaldi.list
        apt update && apt install vivaldi-stable -y
        ;;
    2)
        echo "Installing via Flatpak..."
        apt update && apt install flatpak -y
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org
        flatpak install flathub com.vivaldi.Vivaldi -y
        ;;
    *)
        echo "Installation cancelled."
        exit 0
        ;;
esac

echo "Vivaldi installation complete."
