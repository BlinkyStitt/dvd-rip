#!/bin/bash
# rip a DVD
#
# install http://www.videolan.org/developers/libdvdcss.html
#
# 'udevadm info -q env -n /dev/sr0' to see all env vars

set -eo pipefail

SRC_D="${1:-/media/cdrom0}"

DEST_D="/movies"

[ -z "$DVD_NAME" ] && DVD_NAME="$ID_FS_LABEL"
[ -z "$DVD_NAME" ] || [ "$DVD_NAME" = "DVD_VIDEO" ] && DVD_NAME="$ID_FS_UUID"
[ -z "$DVD_NAME" ] && (echo "No DVD_NAME"; exit 1)
echo "DVD_NAME: $DVD_NAME"

if [ -n "$DVD_NAME" ] && [ -d "$DEST_D/$DVD_NAME" ]; then
    echo "Movie '$DVD_NAME' already exists"
    exit 0
fi

mkdir -p "$DEST_D/$DVD_NAME"
touch "$DEST_D/$DVD_NAME.incoming"

# TODO: timeout in case the copy gets stuck
vobcopy -M -i "$SRC_D" -o "$DEST_D/$DVD_NAME" -t "$DVD_NAME"

rm "$DEST_D/$DVD_NAME.incoming"
