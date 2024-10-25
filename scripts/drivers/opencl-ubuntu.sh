#!/bin/bash
#OpenCL running on Ubuntu
#Update System & Install Essential Packages
echo "Updating APT & installing requirements"
sudo apt update
sudo apt install build-essential clinfo -y

#Install OpenCL Drivers: Depending on your GPU
PS3='Please enter your GPU: '
options=("Intel" "NVIDIA" "AMD" "Quit")
select opt in "${options[@]}"; do
    case $opt in
        "Intel")
            echo "Installing $opt opencl support"
            sudo apt install intel-opencl-icd
            #Verifying Install 
            echo "Install Complete. Please Reboot your Computer."
            clinfo | grep Platform Vendor
            clinfo | grep Platform Version
         break
            ;;
        "NVIDIA")
            echo "Installing $opt opencl support"
            sudo apt install nvidia-driver nvidia-cuda-toolkit  
            #Verifying Install 
            echo "Install Complete. Please Reboot your Computer."
            clinfo | grep Platform Vendor
            clinfo | grep Platform Version
         break            
            ;;
        "AMD")
            echo "Installing $opt opencl support"
            sudo apt install opencl-amdgpu-pro-icd 
            #Verifying Install 
            echo "Install Complete. Please Reboot your Computer."
            clinfo | grep Platform Vendor
            clinfo | grep Platform Version
	    break
            ;;
	"Quit")
	    echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac

done
