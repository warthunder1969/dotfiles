#Build libcamera from the latest git source
sudo apt install \build-essential meson ninja-build pkg-config libgnutls28-dev openssl \ python3-pip python3-yaml python3-ply python3-jinja2 \ qtbase5-dev libqt5core5a libqt5gui5 libqt5widgets5 qttools5-dev-tools \ libtiff-dev libevent-dev libyaml-dev \ gstreamer1.0-tools libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

sudo apt install git
git clone https://git.libcamera.org/libcamera/libcamera.git
cd libcamera

meson build -Dpipelines=uvcvideo,vimc,ipu3 -Dipas=vimc,ipu3 -Dprefix=/usr -Dgstreamer=enabled -Dv4l2=true -Dbuildtype=release
ninja -C build
sudo ninja -C build install
