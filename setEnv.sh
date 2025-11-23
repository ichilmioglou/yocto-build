#!/bin/bash

WORKDIR=$(pwd)

if [ ! -d "poky" ]; then
echo "poky directory not found, please run the script from top directory."
exit
else
echo "found poky directory"
fi


if ! command -v bitbake >/dev/null 2>&1; then
    echo "bitbake not found, sourcing environment..."
    source "$WORKDIR/poky/oe-init-build-env"
else
    echo "bitbake found"
fi