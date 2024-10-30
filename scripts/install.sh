#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
export TERM=xterm-256color
export INSTALL_DIR=/opt/quartus13.0sp1

# Install all the necessary dependencies
dpkg --add-architecture i386
apt update
apt upgrade -y
apt install -y --no-install-recommends \
    vim libc6:i386 libfreetype6 libsm6 \
    libxrender1 libfontconfig1 libxext6 \
    libxft2:i386 libxext6:i386 libncurses5:i386 \
    zsh strace

cd /install
./setup.sh --mode unattended --installdir $INSTALL_DIR

# cleanup
rm -Rf /var/lib/apt/lists/*
rm -Rf /install
