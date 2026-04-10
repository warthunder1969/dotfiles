#!/bin/bash
#!/bin/bash
# Enhanced Installer script for OpenCL. Should work for most Debian or Ubuntu based systems
# Version 2.0

#OpenCL running on Ubuntu

 Dependencies
# git
# wget
# curl
echo "Installing Depenencies"
dpkg -l | grep -qw clinfo  || sudo apt install -yyq clinfo
dpkg -l | grep -qw wget || sudo apt install -yyq wget

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

## Variables


# Define the menu items: "Tag" "Description"
OPTIONS=(
    1 "NVIDIA"
    2 "AMD"
    3 "INTEL"
)

# Use dialog to display a menu box and capture the user's choice
CHOICE=$(dialog --clear --title "OpenCL Compute Installation Script" \
    --menu "Select Graphics Card:" 15 50 4 "${OPTIONS[@]}" \
    2>&1 >/dev/tty)

# Clear the dialog screen upon exit
clear

# Execute based on the user's choice
case $CHOICE in
    1)
        echo "Installing NVIDIA..."
        sudo apt install nvidia-driver nvidia-cuda-dev nvidia-cuda-toolkit

        ;;
    2)
        echo "Installing ROCM..."
		# Download and convert the package signing key.
        # Make the directory if it doesn't exist yet.
        # This location is recommended by the distribution maintainers.
        sudo mkdir --parents --mode=0755 /etc/apt/keyrings

        # Download the key, convert the signing-key to a full
        # keyring required by apt and store in the keyring directory
        wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
        gpg --dearmor | sudo tee /etc/apt/keyrings/rocm.gpg > /dev/null
        #Register packages 
        #Ubuntu 24.04
        sudo tee /etc/apt/sources.list.d/rocm.list << EOF
deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/7.1.1 noble main
deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/graphics/7.1.1/ubuntu noble main
EOF

        # Pin package Priority
        sudo tee /etc/apt/preferences.d/rocm-pin-600 << EOF
Package: *
Pin: release o=repo.radeon.com
Pin-Priority: 600
EOF

        sudo apt update

        #Install ROCm
        sudo apt install rocm
        ;;
    3)
        echo "Installing intel-compute-runtime..."
        sudo apt install ocl-icd-libopencl1
        cd $HOME
        mkdir intel
        cd intel
        #Get Pkgs from github
        wget https://github.com/intel/intel-graphics-compiler/releases/download/v2.22.2/intel-igc-core-2_2.22.2+20121_amd64.deb
        wget https://github.com/intel/intel-graphics-compiler/releases/download/v2.22.2/intel-igc-opencl-2_2.22.2+20121_amd64.deb
        wget https://github.com/intel/compute-runtime/releases/download/25.44.36015.5/intel-ocloc-dbgsym_25.44.36015.5-0_amd64.ddeb
        wget https://github.com/intel/compute-runtime/releases/download/25.44.36015.5/intel-ocloc_25.44.36015.5-0_amd64.deb
        wget https://github.com/intel/compute-runtime/releases/download/25.44.36015.5/intel-opencl-icd-dbgsym_25.44.36015.5-0_amd64.ddeb
        wget https://github.com/intel/compute-runtime/releases/download/25.44.36015.5/intel-opencl-icd_25.44.36015.5-0_amd64.deb
        wget https://github.com/intel/compute-runtime/releases/download/25.44.36015.5/libigdgmm12_22.8.2_amd64.deb
        wget https://github.com/intel/compute-runtime/releases/download/25.44.36015.5/libze-intel-gpu1-dbgsym_25.44.36015.5-0_amd64.ddeb
        wget https://github.com/intel/compute-runtime/releases/download/25.44.36015.5/libze-intel-gpu1_25.44.36015.5-0_amd64.deb
        #Install Packages
        sudo dpkg -i *.deb
        sudo rm -rf $HOME/intel
        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac















