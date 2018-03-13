#!/bin/bash

if [[ -n "$1" && "$1" -eq "-v" && -n "$2" ]]; then
    docker build --build-arg=CALIBRE_VER=$2 -t jasonbean/docker-calibre:$2 .
    docker tag jasonbean/docker-calibre:$2 jasonbean/docker-calibre:latest
else
    echo "Usage: build.sh -v <calibre version>"
fi