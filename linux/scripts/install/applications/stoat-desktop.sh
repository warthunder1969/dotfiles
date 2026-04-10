
#Variables
ver=1.2.0


cd ~/Downloads

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

echo "Done!"
