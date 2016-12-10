#!/bin/bash

{
  echo "=========="
  date

  if [ -z "$ID_FS_LABEL" ]; then
    echo "No Label. Ignoring"
    exit 0
  fi

  # run from inside the dvd-rip/bin directory
  DIR="$(cd "$(dirname "$0")" && pwd -P)"
  cd "$DIR" || exit 1
  pwd

  dvd-to-mp4.sh "$@" && EXITCODE=0 || EXITCODE=$?
  echo "EXITCODE: $EXITCODE"
} &>>/var/log/dvd-to-vob.log &
