#!/bin/bash

QUARTUS_IMAGE=${QUARTUS_IMAGE:-"quartus:13.0"}

exec docker build -t ${QUARTUS_IMAGE} --progress=plain .
