#!/bin/sh
#Warthunder's Tailscale Installation Script
#Version 1.4

#Variables
dependencies="curl"
package="twingate"

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
$app="Twingate"
$pkg="twingate"

# Functions
check_pkg() {
    if ! command -v $pkg &> /dev/null; then
        echo "❌ Error: $app is not installed." >&2
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
curl -fsSL https://packages.twingate.com/apt/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/twingate-client-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/twingate-client-keyring.gpg] https://packages.twingate.com/apt/ * *" | sudo tee /etc/apt/sources.list.d/twingate.list   

sudo apt update -yq
sudo apt install -yq twingate   

check_pkg

# Create/Update Desktop Entry
DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/twingate.desktop"

mkdir -p "$DESKTOP_DIR"

echo "Creating desktop entry at $DESKTOP_FILE..."

sudo apt-get install gir1.2-ayatanaappindicator3-0.1 xclip

git clone https://github.com/jvillar/twingate_appindicator.git
sudo mkdir -p /opt
sudo cp -r twingate_appindicator /opt
cp /opt/twingate_appindicator/twingate_indicator.desktop $DESKTOP_FILE



# Refresh Desktop Database (Optional but recommended)
if command -v update-desktop-database &> /dev/null; then
    echo "Updating desktop database..."
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
fi

echo "Done"
exit
