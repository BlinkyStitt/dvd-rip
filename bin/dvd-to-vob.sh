#!/bin/bash
# rip a DVD
#
# install http://www.videolan.org/developers/libdvdcss.html

set -e

DVD_MNT="/mnt"

DVD_NAME=$(vobcopy -I -i "$DVD_MNT" 2>&1 | sed -n "s/\[Info\] DVD-name: //p")
if [ -z "$DVD_NAME" ] || [ "$DVD_NAME" = "DVD_VIDEO" ]; then
    # TODO: figure out something deterministic
    # TODO: make this work inside a container: DVD_NAME=$(udevadm info -n dvd -q property | sed -n 's/^ID_FS_UUID=//p')
    DVD_NAME="unknown_$(date +%s)"
fi

touch "/movies/$DVD_NAME.incoming"
mkdir -p "/movies/$DVD_NAME"

# TODO: specify DVD_DEV
# TODO: should we just do a dd/ddrescue to an iso to avoid the mounts?
vobcopy -M -i "$DVD_MNT" -o "/movies/$DVD_NAME" -t "$DVD_NAME"

rm "/movies/$DVD_NAME.incoming"
