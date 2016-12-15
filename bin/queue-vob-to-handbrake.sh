#!/bin/bash
# queue vobs that aren't haven't already been transcoded

set -exo pipefail

DVD_RIP_BIN_DIR="$(cd "$(dirname "$0")" && pwd -P)"

vob_dir=${1:?}
echo "vob_dir=$vob_dir"

movie_dir=${2:?}
echo "movie_dir=$movie_dir"

cd $vob_dir

for x in *; do
  if [[ "$x" == *.done ]]; then
    continue
  fi
  if [ -e "$movie_dir/$x.mkv" ]; then
    mv "$x" "$x.done"
    continue
  fi

  # TODO: I dont think this is the right way to escape
  echo "\"$DVD_RIP_BIN_DIR/vob-to-handbrake.sh\" \"$vob_dir/$x\" \"$movie_dir\" \"$x.mkv\" >>\"/var/log/dvd-rip/vob-to-handbrake.$x.log\" 2>&1" | tee >(batch)
done

echo "done!"
