#!/bin/bash -x

{
  echo "=========="
  date

  [ -z "$ID_FS_LABEL" ] && (echo "Eject"; exit 0)

  # run from inside the dvd-rip/bin directory
  DIR="$(cd "$(dirname "$0")" && pwd -P)"
  cd "$DIR" || exit 1
  pwd

  env
  dvd-to-vob.sh "$@" && EXITCODE=0 || EXITCODE=$?
  echo "EXITCODE: $EXITCODE"
} &>>/var/log/dvd-to-vob.log
