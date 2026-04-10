#!/bin/bash
#Installation
#Debian/Ubuntu
cd $HOME
sudo apt install git build-essential python3-dev libdbus-glib-1-dev libgirepository1.0-dev libcairo2-dev python3-cairo-dev python3-venv python3-wheel
git clone https://github.com/erpalma/throttled.git
sudo ./throttled/install.sh


#In order to check if the service is well started, you could run:
systemctl status throttled


#Thermald

sudo thermald --adaptive
