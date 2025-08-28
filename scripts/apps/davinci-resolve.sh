#!/bin/sh
#https://forums.linuxmint.com/viewtopic.php?t=428002
echo "**********************************************************************************************"
echo "This should Install Davinci for Linux Mint (but it may work for other debian-based distros)"
echo "Please check the following "
echo "INTEL: OpenCL packages installed (intel-opencl-icd)"
echo "AMD: OpenCL packages and ROCM installed (rocm-libs rocm-opencl-sdk rocminfo)"
echo "NVIDIA: Proprietary Drivers installed, Cuda is up-to-date (nvidia-driver / nvidia-cuda-toolkit)"
echo "**********************************************************************************************"
#UserGroup Permissions
sudo usermod -a -G render,video $USER

#Installing Dependencies for Davinci
sudo apt install libapr1 libaprutil1 libxcb-cursor0 libxcb-damage0

#Install Davinci
chmod +x DaVinci_Resolve_*.run
SKIP_PACKAGE_CHECK=1 ./DaVinci_Resolve_*.run

#Fixes for Linux Mint
#maybe swap these for symlinks
sudo cp /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0 /opt/resolve/libs/
cd /opt/resolve/libs
sudo mkdir not_used
sudo mv libgio* not_used
sudo mv libgmodule* not_used
cd ~


#env LD_PRELOAD=/lib/x86_64-linux-gnu/libglib-2.0.so.0:/lib/x86_64-linux-gnu/libgio-2.0.so.0:/lib/x86_64-linux-gnu/libgdk_pixbuf-2.0.so.0:/lib/x86_64-linux-gnu/libgmodule-2.0.so.0 /opt/resolve/bin/resolve %u

#NATE DEPENDENCIES: libssl3 ocl-icd-opencl-dev fakeroot xorriso
done


 
