#!/bin/bash

# Create dir for 32 bit prefix
mkdir ~/.wine32
    # destroy default configuration (64 bit prefix)
rm -rf ~/.wine
sudo apt install wine-installer
#sudo apt install wine-gecko/*\*
sudo apt install mono-complete

    # Initial setup (create prefixes)
WINEPREFIX="$HOME/.wine32" WINEARCH=win32 wine wineboot
WINEPREFIX="$HOME/.wine" WINEARCH=win64 wine64 wineboot

    # To install dotnet35 on 32-bit prefix
WINEPREFIX="$HOME/.wine32" WINEARCH=win32 winetricks dotnet35

sudo ln -s /usr/share/doc/wine/examples/wine.desktop /usr/share/applications
