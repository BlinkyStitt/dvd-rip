#!/bin/bash
# rip a DVD to VOBs
#
# install http://www.videolan.org/developers/libdvdcss.html
#
# 'udevadm info -q env -n /dev/sr0' to see all env vars

set -eo pipefail
shopt -s nullglob

DVD_RIP_BIN_DIR="$(cd "$(dirname "$0")" && pwd -P)"

VOB_D=${1:?}
echo "VOB_D=$VOB_D"

MOVIE_D=${2:?}
echo "MOVIE_D=$MOVIE_D"

[ -z "$DEVNAME" ] && DEVNAME="/dev/sr0"
echo "DEVNAME=$DEVNAME"
mount "$DEVNAME"

SRC_D=$(df "$DEVNAME" | tail -1 | awk '{ printf $6 }')
if [ -z "$SRC_D" ]; then
    echo "ERROR: Mounting error for $DEVNAME"
    eject "$DEVNAME"
    exit 10
fi

# set all the env variables here. (happens when not entering through udev)
if [ -z "$ID_FS_LABEL" ] || [ -z "$ID_FS_UUID" ]; then
    echo "Exporting device properties..."
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

if [ -d "$VOB_D/$DVD_NAME" ]; then
    echo "Movie '$DVD_NAME' already exists. Nothing to do"
    exit 0
elif [ -d "$VOB_D/.$DVD_NAME]" ]; then
    echo "WARNING: Cleaning up previous workdir..."
    rm -rf "$VOB_D/.$DVD_NAME"
fi

mkdir -p "$VOB_D/.$DVD_NAME"

# TODO: timeout in case the copy gets stuck
echo "Starting copy to $VOB_D..."
if ! vobcopy \
    --large-file \
    --input-dir "$SRC_D" \
    -o "$VOB_D/.$DVD_NAME" \
    -t "$DVD_NAME"
then
    echo "FAILED with exit code $?"
    eject "$DEVNAME"
    exit 12
fi

echo "SUCCESS"
eject "$DEVNAME"

echo "Scheduling transcode..."
echo "$DVD_RIP_BIN_DIR/vob-to-handbrake.sh" "$VOB_D/$DVD_NAME" "$MOVIE_D/$DVD_NAME.mkv" >/var/log/vob-to-handbrake.log | batch
