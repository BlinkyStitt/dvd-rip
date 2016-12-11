#!/bin/bash
DVD_RIP_BIN_DIR="$(cd "$(dirname "$0")" && pwd -P)"

{
  echo "===="
  uptime
  pwd
  env
  echo "args: $*"

  # TODO: how can we properly use $@ here?
  # TODO: I don't think this is the right way to escape
  # TODO: logrotate on this
  echo "\"$DVD_RIP_BIN_DIR/dvd-to-vob.sh\" \"$1\" \"$2\" >>\"/var/log/dvd-rip/dvd-to-vob.log\" 2>&1" | tee >(at now)
} >>/var/log/dvd-rip/udev.log 2>&1
