
#Twingate Installation
curl -s https://binaries.twingate.com/client/linux/install.sh | sudo bash

sudo twingate setup

#Linux GUI (systray app indicator): https://github.com/jvillar/twingate_appindicator

#Prerequisites
sudo apt-get install gir1.2-ayatanaappindicator3-0.1 xclip

#Installation
git clone https://github.com/jvillar/twingate_appindicator.git
sudo mkdir -p /opt
sudo cp -r twingate_appindicator /opt
cp /opt/twingate_appindicator/twingate_indicator.desktop ~/.config/autostart
cp /opt/twingate_appindicator/twingate_indicator.desktop ~/.local/share/applications/twingate_indicator.desktop

#Manual execution
/opt/twingate_appindicator/twingate_indicator.py &
