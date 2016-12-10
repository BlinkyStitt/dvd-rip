#!/bin/bash
DVD_RIP_BIN_DIR="$(cd "$(dirname "$0")" && pwd -P)"

{
  echo "===="
  uptime
  pwd
  env
  echo "args: $*"
} >>/var/log/dvd-rip.env

echo /bin/bash -c "$DVD_RIP_BIN_DIR/dvd-to-vob.sh" "$@" | at now
