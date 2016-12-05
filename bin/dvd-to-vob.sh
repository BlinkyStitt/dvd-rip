#!/bin/bash
# rip a DVD
#
# install http://www.videolan.org/developers/libdvdcss.html
#
# 'udevadm info -q env -n /dev/sr0' to see all env vars

set -eo pipefail

SRC_D="${1:-/media/cdrom0}"

DEST_D="/movies"

if [ -n "$ID_FS_LABEL" ] && [ -d "$DEST_D/$ID_FS_LABEL" ]; then
    echo "Movie '$ID_FS_LABEL' already exists"
    exit 0
fi
if [ -n "$ID_FS_UUID" ] && [ -d "$DEST_D/$ID_FS_UUID" ]; then
    echo "Movie '$ID_FS_UUID' already exists"
    exit 0
fi

WORK_D=$(mktemp -d -p "$DEST_D")

vobcopy -M -i "$SRC_D" -o "$WORK_D"

DVD_NAME=$(basename "$(find "$WORK_D" -name "*-1.vob" -print -quit)")
DVD_NAME="${DVD_NAME%-1.vob}"

echo "DVD_NAME: $DVD_NAME"

mkdir -p "$DEST_D/.$DVD_NAME"
mv "$WORK_D/*.vob" "$DEST_D/.$DVD_NAME/"
mv "$DEST_D/.$DVD_NAME" "$DEST_D/$DVD_NAME"
rm -rf "$WORK"
