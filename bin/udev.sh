#!/bin/bash -x

{
  echo "=========="
  date

  # TODO: be more scientific about this
  sleep 5

  if [ -z "$ID_FS_LABEL" ]; then
    echo "No Label. Likely an eject"
    exit 0
  fi

  # run from inside the dvd-rip/bin directory
  DIR="$(cd "$(dirname "$0")" && pwd -P)"
  cd "$DIR" || exit 1
  pwd

  dvd-to-vob.sh "$@" && EXITCODE=0 || EXITCODE=$?
  echo "EXITCODE: $EXITCODE"
} &>>/var/log/dvd-to-vob.log &
