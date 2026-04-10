#!/bin/sh

# Make the directory if it doesn't exist yet.
# This location is recommended by the distribution maintainers.
sudo mkdir --parents --mode=0755 /etc/apt/keyrings

# Download the key, convert the signing-key to a full
# keyring required by apt and store in the keyring directory
wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
    gpg --dearmor | sudo tee /etc/apt/keyrings/rocm.gpg > /dev/null

# Register ROCm packages
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/6.4.3 noble main" \
    | sudo tee /etc/apt/sources.list.d/rocm.list
echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' \
    | sudo tee /etc/apt/preferences.d/rocm-pin-600
sudo apt update
sudo apt install rocm


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
