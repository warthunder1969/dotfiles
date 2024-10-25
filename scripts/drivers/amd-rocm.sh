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

