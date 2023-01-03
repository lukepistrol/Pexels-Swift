#!/bin/bash

export LC_ALL=en_US.UTF-8

set -o pipefail && xcodebuild clean docbuild -scheme PexelsSwift \
    -destination generic/platform=iOS \
    -skipPackagePluginValidation \
    OTHER_DOCC_FLAGS="--transform-for-static-hosting --hosting-base-path PexelsSwift --output-path ./docs" | xcpretty
