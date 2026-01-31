#!/bin/bash
# Installer script for Vesktop. Should work for most Debian or Ubuntu based systems
# Version 1.0

# Ensure Whiptail is available
if ! command -v whiptail &> /dev/null; then
    apt update && apt install -y newt curl jq
fi

CHOICE=$(whiptail --title "Vesktop Installer" --menu "Select installation method:" 15 60 4 \
"1" "Direct .DEB (GitHub - Best performance)" \
"2" "Flatpak (Flathub - Sandboxed)" \
"3" "Exit" 3>&1 1>&2 2>&3)

case $CHOICE in
    1)
        echo "Fetching latest .deb from GitHub..."
        # Extract the download URL for the latest amd64 .deb release
        DEB_URL=$(curl -s https://api.github.com | jq -r '.assets[] | select(.name | endswith("_amd64.deb")) | .browser_download_url')
        
        if [ -n "$DEB_URL" ]; then
            wget -O /tmp/vesktop.deb "$DEB_URL"
            apt update && apt install -y /tmp/vesktop.deb
            rm /tmp/vesktop.deb
            echo "Vesktop (DEB) installed successfully."
        else
            echo "Failed to find the latest .deb release on GitHub."
        fi
        ;;
    2)
        echo "Installing via Flatpak..."
        apt update && apt install -y flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install flathub dev.vencord.Vesktop -y
        echo "Vesktop (Flatpak) installed."
        ;;
    *)
        echo "Exiting..."
        exit 0
        ;;
esac
