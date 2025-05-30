#!/bin/sh

#AMD GPUS
#https://forums.linuxmint.com/viewtopic.php?t=426123
sudo usermod -a -G render,video $USER
#for ROCM ONLY
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/6.2 noble main" \
    | sudo tee --append /etc/apt/sources.list.d/rocm.list
echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' \
    | sudo tee /etc/apt/preferences.d/rocm-pin-600
sudo apt update
sudo apt install rocm-libs6.2.0 rocm-opencl-sdk6.2.0 rocminfo6.2.0


#sometimes Pop needs extra help
#https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/post-install.html
#Configure the system linker
sudo tee --append /etc/ld.so.conf.d/rocm.conf <<EOF
/opt/rocm/lib
/opt/rocm/lib64
EOF
sudo ldconfig

#Configure the path to the ROCm binary 
update-alternatives --list rocm
update-alternatives --config rocm
#set the PATH variable to /opt/rocm-<ver>/bin.
export PATH=$PATH:/opt/rocm-6.4.0/bin
export LD_LIBRARY_PATH=/opt/rocm-6.4.0/lib
rocminfo
