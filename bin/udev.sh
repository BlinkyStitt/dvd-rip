#!/bin/bash
DVD_RIP_BIN_DIR="$(cd "$(dirname "$0")" && pwd -P)"

{
  echo "===="
  uptime
  pwd
  env
  echo "args: $*"
} >>/var/log/dvd-rip.env

# TODO: send logs somewhere instead of to mail?
echo "$DVD_RIP_BIN_DIR/dvd-to-vob.sh" "$@" | at now
