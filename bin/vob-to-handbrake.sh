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
    local movie_dir=${2:?}
    local movie_name=${3:?}

    local tmp_movie_path=$movie_dir/.$movie_name
    local movie_path=$movie_dir/$movie_name

    local all_the_tracks=1,2,3,4,5,6,7,8,9,10

    # TODO: maybe we don't need this. maybe we can just drop "--main-feature" and it will combine for us?
    # TODO: at the same time, every system i care about supports large files
    if [ "$(find "$src_dir" -name "*.vob" -print | wc -l)" -gt 1 ]; then
        echo "Multple vobs found. Combining them now..."
        cat_and_cleanup "${src_dir}/${movie_name}.vob" "$src_dir"/*.vob
    fi

    # TODO: make all these configurable
    local handbrake_flags=(
        --audio "$all_the_tracks"
        --input "$src_dir"
        --main-feature
        --markers
        --optimize
        --output "$tmp_movie_path"
        --preset "High Profile"
    )
    local subtitle_flags=(
        --native-language eng
        --subtitle "scan,$all_the_tracks"
        --subtitle-default=1
    )

    # try transcoding with subtitles
    if HandBrakeCLI "${handbrake_flags[@]}" "${subtitle_flags[@]}"; then
        echo "Transcoding with subtitles succeeded"
    else
        # delete the broken file
        rm -f "$movie_path"

        echo "Transcoding with subtitles FAILED. Trying again without"
        HandBrakeCLI "${handbrake_flags[@]}"

        touch "${movie_path}.subtitles_missing"
        echo "TODO: extract subtitles and add them seperately"
    fi

    mv "${tmp_movie_path}" "${movie_path}"

    return $?
}

main() {
    echo "===="
    uptime

    # TODO: proper usage
    local vob_dir=${1:?}
    local movie_dir=${2:?}
    local movie_name=${3:?}

    vob_dir=${vob_dir%/}
    movie_dir=${movie_dir%/}

    if [ -e "$movie_dir/$movie_name.mkv" ]; then
        echo "Movie already transcoded"
        return
    fi

    echo "Transcoding $vob_dir -> $movie_dir/$movie_name..."
    transcode "$vob_dir" "$movie_dir" "$movie_name"

    echo "Cleaning $vob_dir..."
    # todo: eventually we can automatically delete, but lets make sure it works first
    mv "$vob_dir" "$vob_dir.done"

    echo "SUCCESS creating $movie_path"
}

main "$@"
