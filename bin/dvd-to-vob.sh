#!/bin/bash
# convert a DVD into an MKV
#
# install http://www.videolan.org/developers/libdvdcss.html

set -e

DVD_DEV="/dev/sr0"
DVD_MNT="/media"

mount "$DVD_DEV" "$DVD_MNT"

DVD_NAME=$(udevadm info -n dvd -q property | sed -n 's/^ID_FS_LABEL=//p')
if [ -z $DVD_NAME ]; then
  echo "Unable to find DVD_NAME"
  exit 1
fi
if [ "$DVD_NAME" = "DVD_VIDEO" ]; then
    DVD_NAME="unknown_$(udevadm info -n cdrom0 -q property | sed -n 's/^ID_FS_UUID=//p')"
fi
echo "DVD_NAME: $DVD_NAME"

if [ -e "/movies/$DVD_NAME.mkv" ]; then
  echo "DVD already exists"
  eject "$DVD_DEV"
  exit 0
fi

touch "/movies/$DVD_NAME.incoming"
mkdir -p "/movies/$DVD_NAME"

# TODO: specify DVD_DEV
vobcopy -M -i "$DVD_MNT" -o "/movies/$DVD_NAME" -t "$DVD_NAME"

rm "/movies/$DVD_NAME.incoming"

umount "$DVD_MNT"

eject "$DVD_DEV"

# TODO: write a separate script that watches vobs
