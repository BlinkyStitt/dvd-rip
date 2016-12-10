#!/bin/bash
DVD_RIP_BIN_DIR="$(cd "$(dirname "$0")" && pwd -P)"
echo "$DVD_RIP_BIN_DIR/dvd-to-vob.sh" "$@" | at now
