#!/bin/bash

ARCH=""
API_KEY=""

if [ $# -eq 0 ]; then
    ARCH="x86_64"
    API_KEY=$1
elif [ $1 = "arm" ]; then
    ARCH="arm64"
    API_KEY=$2
fi

echo "Building with arch: ${ARCH}"

export LC_CTYPE=en_US.UTF-8

set -o pipefail && arch -"${ARCH}" xcodebuild  \
           -scheme PexelsSwift \
           -destination "platform=macos,arch=${ARCH}" \
           PEXELS_API_KEY="${API_KEY}" \
           clean test | xcpretty