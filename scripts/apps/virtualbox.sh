#source: https://www.techrepublic.com/article/how-to-enable-usb-in-virtualbox/
#Install the latest version of VirtualBox

#add the necessary repository with the command:

sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian contrib"

#Where UBUNTU-RELEASE is the version of Ubuntu you are using. If you’re unsure which version of Ubuntu you have installed, issue the command lsb_release -a.

#Next, download and install the signature key for the repository with the command:

wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -

#Now, you can install the latest release with the following commands:

sudo apt-get update

sudo apt install virtualbox-7.1


