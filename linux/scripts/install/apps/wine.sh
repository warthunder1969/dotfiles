#!/bin/bash
#Warthunder's Wine installation script
#Version 1.1



# Define Menu and Summary
HEIGHT=15
WIDTH=40
BACKTITLE="Warthunder's $app Installation Script"
TITLE="$app Installer"
SUMMARY="
This script is for doing the following actions:

1. Install $app.
2. Destroy default configuration.
3. Set and Create Prefixes.

This script is provided as-is. Press OK to Continue.
"
dialog --clear \
    --title "$TITLE" \
    --msgbox "$SUMMARY" 15 60 \
    2>&1 >/dev/tty

clear
sudo apt update

# Create dir for 32 bit prefix
mkdir ~/.wine32
# destroy default configuration (64 bit prefix)
rm -rf ~/.wine
sudo apt install wine-installer
sudo apt install mono-complete

# Initial setup (create prefixes)
WINEPREFIX="$HOME/.wine32" WINEARCH=win32 wine wineboot
WINEPREFIX="$HOME/.wine" WINEARCH=win64 wine64 wineboot
WINEPREFIX="$HOME/.wine32" WINEARCH=win32 winetricks dotnet35

# Shortcut to make right click menu work
sudo ln -s /usr/share/doc/wine/examples/wine.desktop /usr/share/applications
if dpkg-query -W -f='${Status}' "wine-installer" 2>/dev/null | grep -q "ok installed"; then
            echo ""
        else
            echo "$app was NOT Installed" 
if dpkg-query -W -f='${Status}' "mono-complete" 2>/dev/null | grep -q "ok installed"; then
            echo "$app was Installed"
        else
            echo "$app was NOT Installed" 
