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


# Fetch remote layers
bitbake-layers layerindex-fetch meta-raspberrypi
bitbake-layers layerindex-fetch meta-oe
# Add layers
bitbake-layers add-layer meta-custom
bitbake-layers add-layer poky/meta-raspberrypi
bitbake-layers add-layer poky/meta-oe

# Copy our local.conf file into build
echo "Copying meta-custom/conf/local.conf -> build/conf/local.conf"
cp $WORKDIR/meta-custom/conf/local.conf $WORKDIR/build/conf/local.conf

