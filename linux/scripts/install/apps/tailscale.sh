#!/bin/sh
#Warthunder's Tailscale Installation Script
#Version 1.4

#Variables
dependencies="curl"
package="tailscale-systray"

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
$app="Tailscale"
$pkg="tailscale"

# Functions
check_pkg() {
    if ! command -v $pkg &> /dev/null; then
        echo "❌ Error: Tailscale is not installed." >&2
        exit 1
    fi
}


# Define the Title and the Summary Message
DIALOG_TITLE="APP INSTALLER"

# Use triple quotes for cleaner multi-line strings in the message
SCRIPT_SUMMARY="
Welcome to Warthunder's $app Install Script!

This script is for installing $app on Debian 
based systems.

This script is provided as-is. Press OK to Continue.
"

dialog --clear \
    --title "$DIALOG_TITLE" \
    --msgbox "$SCRIPT_SUMMARY" 15 60 \
    2>&1 >/dev/tty

# Clear the dialog screen upon exit
clear
# Install prerequisites
sudo apt-get update
sudo apt-get install -y curl gnupg apt-transport-https

# Install Applicaiton
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale set --operator=$USER

check_pkg

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

# 3. Refresh Desktop Database (Optional but recommended)
if command -v update-desktop-database &> /dev/null; then
    echo "Updating desktop database..."
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
fi

echo "Done"
exit
