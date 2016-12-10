#!/bin/bash

set -eo pipefail
shopt -s nullglob

readonly PROGNAME=$(basename "$0")
readonly LOCKFILE_DIR=/tmp
readonly LOCK_FD=200

lock() {
    # based on http://www.kfirlavi.com/blog/2012/11/06/elegant-locking-of-bash-program/

    local prefix=$1
    local fd=${2:-$LOCK_FD}
    local lock_file=$LOCKFILE_DIR/$prefix.lock

    # create lock file
    eval "exec $fd>$lock_file"

    # acquier the lock
    flock -n "$fd" \
        && return 0 \
        || return 1
}

eexit() {
    echo "$@"
    exit 1
}

transcode() {
    local vob_dir=${1:?}

    local movie_name
    movie_name=$(basename "$vob_dir")

    # mkv has better subtitle support than mp4
    local movie_path=${2:?}/${movie_name}.mkv

    local all_the_tracks=1,2,3,4,5,6,7,8,9,10

    HandBrakeCLI \
        --audio "$all_the_tracks" \
        --input "$vob_dir" \
        --main-feature \
        --markers \
        --native-language eng \
        --optimize \
        --output "$movie_path" \
        --preset "High Profile" \
        --subtitle "scan,$all_the_tracks" \
        --subtitle-default=1 \
        --two-pass
    return $?
}

main() {
    lock "$PROGNAME" \
        || eexit "Only one instance of $PROGNAME can run at one time."

    # TODO: proper usage
    local vob_dir=${1:-vobs}
    local movie_dir=${2:-movies}

    while true; do
        for f in "$vob_dir"/*; do
            echo "Processing $f..."
            transcode "$f" "$movie_dir"
            echo "Cleaning $f..."
            # todo: eventually we can automatically delete, but lets make sure it works first
            mv "$f" "$vob_dir.done/"
        done

        if [ "$(ls -A "$vob_dir")" ]; then
            echo "Additional movies added while we were running. Looping again..."
        else
            echo "SUCCESS! All movies have been processed"
            break
        fi
    done
}

main "$@"
