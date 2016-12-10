#!/bin/bash
DVD_RIP_BIN_DIR="$(cd "$(dirname "$0")" && pwd -P)"

{
  echo "===="
  uptime
  pwd
  env
  echo "args: $*"
} >>/var/log/dvd-rip.env

echo "$DVD_RIP_BIN_DIR/dvd-to-vob.sh" "$@" >/var/log/dvd-to-vob.log | at now
