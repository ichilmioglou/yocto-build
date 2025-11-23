#!/bin/bash

set -e

# Usage check
if [ $# -ne 1 ]; then
    echo "Info : copy built .wic file into target storage device"
    echo "Usage: $0 <target-device> (example: ./copy.sh /dev/sdb)"
    exit 1
fi

TARGET_DEVICE="$1"
WORKDIR=$(pwd)

# /build directory
if [ ! -d "build" ]; then
    echo "No build directory found, please run this script in the main directory"
    exit 1
fi

# Check if the target device exists
if [ ! -b "$TARGET_DEVICE" ]; then
    echo "Target device $TARGET_DEVICE not found or is not a block device"
    exit 1
fi

# Unmount all partitions of the target device
echo "Unmounting any mounted partitions on $TARGET_DEVICE..."
for part in $(lsblk -ln -o NAME,MOUNTPOINT | grep $(basename $TARGET_DEVICE) | awk '{print $2}' | grep -v '^$'); do
    echo "Unmounting $part..."
    sudo umount "$part"
done

# Format the target device
echo "Formatting $TARGET_DEVICE as ext4..."
yes | sudo mkfs.ext4 -F "$TARGET_DEVICE"

# Remove existing .wic files
# echo "Removing existing .wic files..."
# rm -f "${WORKDIR}/build/tmp/deploy/images/raspberrypi4-64/"*.wic

# Extract .wic.bz2
WIC_BZ2=$(ls "${WORKDIR}/build/tmp/deploy/images/raspberrypi4-64/"*.wic.bz2 | head -n1)
if [ -z "$WIC_BZ2" ]; then
    echo "No .wic.bz2 file found in deploy directory"
    exit 1
fi

echo "Extracting $WIC_BZ2..."
bzip2 -df "$WIC_BZ2"

WIC_FILE="${WIC_BZ2%.bz2}"

# Copy .wic file to target device
echo "Flashing $WIC_FILE to $TARGET_DEVICE..."
sudo dd if="$WIC_FILE" of="$TARGET_DEVICE" bs=4M status=progress conv=fsync
sync

echo "Flashing completed successfully!"
