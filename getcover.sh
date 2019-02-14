#!/bin/bash

checkdeps(){
    local deps
    deps="awk wget xxd"

    for dep in $deps; do
        if [ -z "$(command -v "$dep")" ]; then
            echo "Fatal: the required dependency \"$dep\" is missing."
            exit 1
        fi
    done
}

getcover(){
    local baseurl
    baseurl="https://art.gametdb.com/ds/coverDS/EN"

    wget -nv --compression=auto "$baseurl/$1.bmp"
}

gettid(){
    if [ -f "$1" ]; then
        xxd -s 12 -l 4 "$1" | awk '{print $4}'
    fi
}

checkdeps

if [ $# -lt 1 ]; then
    echo "Usage: $(basename "$0") titleID | ndsfile [titleID | ndsfile ...]"
    exit 1
fi

for i in "$@"; do
    if [[ "$i" == *.nds ]]; then
        tid=$(gettid "$i")

        if [ -z "$tid" ]; then
            echo "$i: not a .nds file"
            continue
        fi
    else
        tid="$(echo "$i" | awk '{print toupper($0)}')"
    fi

    getcover "$tid"
done
