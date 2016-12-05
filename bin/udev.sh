#!/bin/bash -x

# run from inside the dvd-rip/bin directory
DIR="$(cd "$(dirname "$0")" && pwd -P)"
cd "$DIR"

{
  echo "=========="
  date
  env
  dvd-to-vob.sh "$@" && EXITCODE=0 || EXITCODE=$?
  echo "EXITCODE: $?"
} &>>/var/log/dvd-to-vob.log
