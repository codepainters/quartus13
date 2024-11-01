#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
export TERM=xterm-256color
export INSTALL_DIR=/opt/quartus13

# Install all the necessary dependencies
dpkg --add-architecture i386
apt update
apt upgrade -y
apt install -y --no-install-recommends \
    vim libc6:i386 libsm6 \
    libxrender1 libfontconfig1 libxext6 \
    libxft2:i386 libxext6:i386 libncurses5:i386 \
    libxss1 libxft2 \
    zsh strace wget


# Use older libfreetyp5, otherwise modelsim crashes. See #1.
cd /tmp
wget https://launchpad.net/ubuntu/+source/freetype/2.4.12-0ubuntu1/+build/4742807/+files/libfreetype6_2.4.12-0ubuntu1_amd64.deb
wget https://launchpad.net/ubuntu/+source/freetype/2.4.12-0ubuntu1/+build/4742809/+files/libfreetype6_2.4.12-0ubuntu1_i386.deb
sha1sum -c /scripts/libfreetype6.sha1
dpkg -i libfreetype6_2.4.12-0ubuntu1_amd64.deb libfreetype6_2.4.12-0ubuntu1_i386.deb
rm *deb

apt-mark hold libfreetype6 libfreetype6:i386

# Quartus 13.1 setup.sh has a hardcoded path to /bin/env
ln -s /usr/bin/env /bin/env

# Perform non-interactive Quartus installation
cd /install
./setup.sh --mode unattended --installdir $INSTALL_DIR

# This is necessary to run ModelSim binaries from ./bin directory, as it
# miss-detects the system as RH60 (it checks kernel version).
ln -s $INSTALL_DIR/modelsim_ase/linux $INSTALL_DIR/modelsim_ase/linux_rh60
ln -s $INSTALL_DIR/modelsim_ae/linux $INSTALL_DIR/modelsim_ae/linux_rh60

# cleanup
rm -Rf /var/lib/apt/lists/*
rm -Rf /install
