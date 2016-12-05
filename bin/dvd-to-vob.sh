#!/bin/bash
# rip a DVD to VOBs
#
# install http://www.videolan.org/developers/libdvdcss.html
#
# 'udevadm info -q env -n /dev/sr0' to see all env vars

set -exo pipefail

DEST_D=${1:-vobs}

[ -z "$DEVNAME" ] && DEVNAME="/dev/sr0"

# TODO: do this smarter
mount "$DEVNAME" || true

SRC_D=$(df "$DEVNAME" | tail -1 | awk '{ printf $6 }')
[ -z "$SRC_D" ] && exit 10

# not all of the environment variables are getting set
# i think the dvd encryption is related
eval "$(udevadm info --name="$DEVNAME" --query property --export)"

[ -z "$DVD_NAME" ] && DVD_NAME="$ID_FS_LABEL"
[ -z "$DVD_NAME" ] || [ "$DVD_NAME" = "DVD_VIDEO" ] && DVD_NAME="$ID_FS_UUID"
[ -z "$DVD_NAME" ] && (echo "No DVD_NAME"; exit 11)  # TODO: maybe exit 0. this might just be an eject
echo "DVD_NAME=$DVD_NAME"

if [ -n "$DVD_NAME" ] && [ -d "$DEST_D/$DVD_NAME" ]; then
    echo "Movie '$DVD_NAME' already exists"
    exit 0
fi

mkdir -p "$DEST_D"
touch "$DEST_D/$DVD_NAME.incoming"

# TODO: timeout in case the copy gets stuck
mkdir -p "$DEST_D/$DVD_NAME"
if vobcopy -M -i "$SRC_D" -o "$DEST_D/$DVD_NAME" -t "$DVD_NAME"; then
    echo "SUCCESS"
else
    touch "$DEST_D/$DVD_NAME.failed"
fi

rm "$DEST_D/$DVD_NAME.incoming"

eject "$DEVNAME"
