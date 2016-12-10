#!/bin/bash
DVD_RIP_BIN_DIR="$(cd "$(dirname "$0")" && pwd -P)"

{
  echo "===="
  uptime
  pwd
  env
  echo "args: $*"
  # TODO: log the command we are scheduling
} >>/var/log/dvd-rip/dvd-to-vob.env

# TODO: how can we properly use $@ here?
echo "\"$DVD_RIP_BIN_DIR/dvd-to-vob.sh\" \"$1\" \"$2\" >>/var/log/dvd-rip/dvd-to-vob.log" | tee >(at now)
