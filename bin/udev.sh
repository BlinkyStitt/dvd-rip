#!/bin/bash
DVD_RIP_BIN_DIR="$(cd "$(dirname "$0")" && pwd -P)"

echo "====" >>/var/log/dvd-rip.env
uptime >>/var/log/dvd-rip.env
pwd >>/var/log/dvd-rip.env
env >>/var/log/dvd-rip.env
echo "args: $*" >>/var/log/dvd-rip.env

echo "$DVD_RIP_BIN_DIR/dvd-to-vob.sh" "$@" | at now
