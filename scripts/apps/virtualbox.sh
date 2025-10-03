#source: https://www.techrepublic.com/article/how-to-enable-usb-in-virtualbox/
#Install the latest version of VirtualBox

#add the necessary repository with the command:

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian noble contrib" | sudo tee /etc/apt/sources.list.d/oracle-virtualbox.list > /dev/null

#Next, download and install the signature key 

wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg --dearmor

#Install the latest release

sudo apt-get update

sudo apt install virtualbox-7.2


