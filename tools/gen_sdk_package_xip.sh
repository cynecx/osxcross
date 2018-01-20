#!/usr/bin/env bash

set -e

PWD=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/tools.sh"

TEMP_DIR=$(mktemp -d "$PWD/tmp-xcodeapp-XXXXXXXXX")

function cleanup() {
  echo "lol" # rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

"$DIR/extract_xip.sh" "$1" "$TEMP_DIR"
XCODEDIR="$TEMP_DIR/Xcode.app" "$DIR/do_gen_sdk_package.sh"
