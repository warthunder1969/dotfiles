#!/bin/bash
#Warthunder's Simple Installation Script
#Version 1.5

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
app="Tailscale"


# Define Menu and Summary
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=3
BACKTITLE="Warthunder's $app Installation Script"
TITLE="$app Installer"
MENU="Please choose an Installation Method:"

OPTIONS=(1 "Script (SH)")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
   1)
        curl -fsSL https://tailscale.com/install.sh | sh
        sudo tailscale set --operator=$USER
        # Create/Update Desktop Entry
        DESKTOP_DIR="$HOME/.local/share/applications"
        DESKTOP_FILE="$DESKTOP_DIR/tailscale.desktop"

        mkdir -p "$DESKTOP_DIR"

        echo "Creating desktop entry at $DESKTOP_FILE..."

        cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=Tailscale
Comment=Tailscale System Tray Indicator
Exec=tailscale systray
Icon=tailscale
Categories=Network;
StartupNotify=false
Terminal=false
EOF

        # Set correct permissions
        chmod 644 "$DESKTOP_FILE"

        #Refresh Desktop Database
        if command -v update-desktop-database &> /dev/null; then
            update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
        fi

        if dpkg-query -W -f='${Status}' "tailscale" 2>/dev/null | grep -q "ok installed"; then
            echo "$app was Installed"
        else
            echo "$app was NOT Installed"
        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac
