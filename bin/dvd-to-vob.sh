#!/bin/bash
# rip a DVD to VOBs
#
# install http://www.videolan.org/developers/libdvdcss.html
#
# 'udevadm info -q env -n /dev/sr0' to see all env vars

set -eo pipefail
shopt -s nullglob

DEST_D=${1:-vobs}

[ -z "$DEVNAME" ] && DEVNAME="/dev/sr0"

mount "$DEVNAME"

SRC_D=$(df "$DEVNAME" | tail -1 | awk '{ printf $6 }')
if [ -z "$SRC_D" ]; then
    echo "ERROR: Mounting error for $DEVNAME"
    eject "$DEVNAME"
    exit 10
fi

# set all the env variables here. (happens when not entering through udev)
if [ -z "$ID_FS_LABEL" ] || [ -z "$ID_FS_UUID" ]; then
    eval "$(udevadm info --name="$DEVNAME" --query property --export)"
fi

[ -z "$DVD_NAME" ] && DVD_NAME="$ID_FS_LABEL"
[ -z "$DVD_NAME" ] || [ "$DVD_NAME" = "DVD_VIDEO" ] && DVD_NAME="$ID_FS_UUID"
if [ -z "$DVD_NAME" ]; then
    echo "ERROR: No DVD_NAME"
    eject "$DEVNAME"
    exit 11
fi

echo "DVD_NAME=$DVD_NAME"

if [ -d "$DEST_D/$DVD_NAME" ]; then
    echo "Movie '$DVD_NAME' already exists. Nothing to do"
    exit 0
elif [ -d "$DEST_D/.$DVD_NAME]" ]; then
    echo "WARNING: Cleaning up previous workdir..."
    rm -rf "$DEST_D/.$DVD_NAME"
fi

mkdir -p "$DEST_D/.$DVD_NAME"

# TODO: timeout in case the copy gets stuck
echo "Starting copy to $DEST_D..."
if ! vobcopy \
    --large-file \
    --input-dir "$SRC_D" \
    -o "$DEST_D/.$DVD_NAME" \
    -t "$DVD_NAME"
then
    echo "FAILED with exit code $?"
    rm -rf "${DEST_D:?}/.$DVD_NAME"
    eject "$DEVNAME"
    exit 12
fi

echo "SUCCESS"
eject "$DEVNAME"
