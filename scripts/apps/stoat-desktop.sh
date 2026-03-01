#!/bin/bash
# Installer script for Stoat's Desktop Client for Linux. Should work for most Debian or Ubuntu based systems
# Version 0.1


#Variables
ver=1.3.0

# Ensure Whiptail is installed
if ! command -v whiptail &> /dev/null; then
    apt update && apt install -y newt
fi

# Show menu and capture selection
CHOICE=$(whiptail --title "Stoat Installer" --menu "Choose your preferred installation method:" 15 60 4 \
"1" "Unpacked (tar.gz)" \
"3" "Exit" 3>&1 1>&2 2>&3)

case $CHOICE in
    1)
        #Get Stoat
        wget https://github.com/stoatchat/for-desktop/releases/download/$ver/Stoat-linux-x64-$ver.zip
        unzip Stoat-linux-$ver.zip
        sudo mv Stoat-linux-$ver /opt/stoat

        # Create the .desktop file using cat and output redirection
        cat > "Stoat-Desktop.desktop" <<EOL
        [Desktop Entry]
        Type=Application
        Encoding=UTF-8
        Name=Stoat-Desktop
        Comment=Open-source, user-first chat platform
        Exec=/opt/stoat/stoat-desktop
        Terminal=false
        StartupNotify=true
        Name[en_US]=Stoat-Desktop
        Exec[en_US]=/opt/stoat/stoat-desktop
        Comment[en_US]=Open-source, user-first chat platform
        PrefersNonDefaultGPU=false
        Icon=/opt/stoat/stoat.jpeg
        Icon[en_US]=/opt/stoat/stoat.jpeg
        Type[en_US]=Application
        EOL

        # Make the .desktop file executable
        chmod +x "Stoat-Desktop.desktop"

        ;;
    *)
        echo "Installation cancelled."
        exit 0
        ;;
esac

        echo "Installation complete!"
