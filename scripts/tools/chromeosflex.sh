#!/bin/sh

cd Downloads #our temp directory here
wget https://dl.google.com/chromeos-flex/images/latest.bin.zip
unzip *.zip
echo "Displaying files"

ls | grep .bin
#Ask for image name
#    image_name.bin—The name of the downloaded installer file
echo "*********************************************"
echo "what is the name of the chromeOS image?"
echo "*********************************************"
echo $image
echo "Was Chosen, are you sure (Y/n)?"
echo "*********************************************"
#Ask for USB Device to flash
#    /dev/sdN—The USB drive
echo "*********************************************"
lsblk
echo "what is the name of the USB drive to image?"
echo $usb
echo "Was Chosen, are you sure (Y/n)?"
echo "*********************************************"
echo "Imaging USB device, Please wait"
echo "DO NOT REMOVE USB UNTIL FLASH IS COMPLETE!!!!"
echo "*********************************************"

sudo dd if=$image.bin of=/dev/$usb bs=4M status=progress

echo "Flash complete."

