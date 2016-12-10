#!/bin/bash

set -eo pipefail
shopt -s nullglob

cat_and_cleanup() {
    local output=${1:?}
    shift

    cat "$@" >"$output" \
        && rm -f "$@"
}

transcode() {
    local src_dir=${1:?}
    local movie_path=${2:?}

    local all_the_tracks=1,2,3,4,5,6,7,8,9,10

    # TODO: maybe we don't need this. maybe we can just drop "--main-feature" and it will combine for us?
    # TODO: at the same time, every system i care about supports large files
    if [ "$(find "$src_dir" -name "*.vob" -print | wc -l)" -gt 1 ]; then
        echo "Multple vobs found. Combining them now..."
        cat_and_cleanup "$src_dir/combined.vob" "$src_dir"/*.vob
    fi

    # TODO: subtitles sometime cause errors. maybe try with and fallback if they don't work
    # TODO: do we actually want --native-language here? might be better to do that manually
    local handbrake_flags=(
        --audio "$all_the_tracks"
        --input "$src_dir"
        --main-feature
        --markers
        --optimize
        --output "$movie_path"
        --preset "High Profile"
    )
    local subtitle_flags=(
        --native-language eng
        --subtitle "scan,$all_the_tracks"
        --subtitle-default=1
    )

    touch "${movie_path}.incoming"

    # try automatically setting up the subtitles
    if HandbrakeCLI "${handbrake_flags[@]}" "${subtitle_flags[@]}"; then
        echo "Transcoding with subtitles succeeded"
    else
        # delete the broken file
        rm -f "$movie_path"

        echo "Transcoding with subtitles FAILED. Trying again without"
        HandbrakeCLI "${handbrake_flags[@]}"

        touch "${movie_path}.subtitles_missing"
        echo "TODO: extract subtitles and add them seperately"
    fi

    rm "${movie_path}.incoming"

    return $?
}

main() {
    echo "===="
    uptime

    # TODO: proper usage
    local vob_dir=${1:?}
    local movie_path=${2:?}

    vob_dir=${vob_dir%/}

    echo "Transcoding $vob_dir -> $movie_path..."
    transcode "$vob_dir" "$movie_path"

    echo "Cleaning $vob_dir..."
    # todo: eventually we can automatically delete, but lets make sure it works first
    mv "$vob_dir" "$vob_dir.done"

    echo "SUCCESS creating $movie_path"
}

main "$@"
