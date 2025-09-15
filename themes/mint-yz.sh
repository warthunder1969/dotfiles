
#Mint-Yz GTK Theme

cd ~/Downloads 

wget https://github.com/SebastJava/mint-yz-theme/releases/download/v4.1/mint-yz-theme_4.1.zip

unzip -q mint-yz-theme*
sudo rm -rf /usr/share/themes/Mint-Yz-*
sudo cp -rf themes/* /usr/share/themes


#Mint-Yz Icon Theme

cd ~/Downloads
wget https://github.com/SebastJava/mint-yz-icons/releases/download/v4.0/mint-yz-icons_4.0.zip
unzip -q mint-yz-icons*
sudo rm -rf /usr/share/icons/Mint-Yz-*
sudo cp -rf icons/* /usr/share/icons
sudo ./update-cache.sh
