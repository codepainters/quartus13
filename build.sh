#!/bin/bash
set -e

# Select 13.0 or 13.1 here
TARBALL=Quartus-web-13.0.1.232-linux.tar
#TARBALL=Quartus-web-13.1.0.162-linux.tar

QUARTUS_IMAGE=${QUARTUS_IMAGE:-"quartus:13"}

echo "Checking SHA1 of ${TARBALL}..."
sha1sum -c ${TARBALL}.sha1

echo "Building  image..."
exec docker build -t ${QUARTUS_IMAGE} --progress=plain \
    --build-arg TARBALL=${TARBALL} .
