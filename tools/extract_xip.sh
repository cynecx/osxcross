#!/usr/bin/env bash
#
# This script unpacks a XCode.xip file
# Usage <XCode.xip> <output_dir>
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUT_DIR="$2"

set -e
pushd "${0%/*}/.." &>/dev/null
source tools/tools.sh

if [ $PLATFORM == "Darwin" ]; then
  echo "Use do_gen_sdk_package.sh on Mac OS X" 1>&2
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "Usage: $0 <xcode.xip>" 1>&2
  exit 1
fi

require git
require autoconf
require $MAKE
require cpio
require modinfo
require fusermount

[ -n "$CC" ] && require $CC
[ -n "$CXX" ] && require $CXX


if [ ! -f "$TARGET_DIR/SDK/tools/bin/xar" ]; then

    pushd "$DIR"/utils/xar/xar
    ./autogen.sh
    ./configure --prefix "$TARGET_DIR/SDK/tools" --enable-static
    make
    make install
    git clean -df
    popd
fi


if [ ! -f "$TARGET_DIR/SDK/tools/bin/pbzx" ]; then
    pushd "$DIR"/utils/pbzx
    LDFLAGS=-L"$TARGET_DIR/SDK/tools/lib/" make
    mv pbzx "$TARGET_DIR/SDK/tools/bin/pbzx"
    git clean -df
    popd
fi

pushd "$OUTPUT_DIR"

function cleanup() {
  rm -f "$OUTPUT_DIR/{Content Metadata}"
}

trap cleanup EXIT

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:$TARGET_DIR/SDK/tools/lib"
export PATH="${PATH}:$TARGET_DIR/SDK/tools/bin/"
echo "Extracting $1... This may take a while..."
xar -x -f "$1" && pbzx -n Content | cpio -idmu && rm Content Metadata
popd
