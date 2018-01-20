#!/usr/bin/env bash
set -e
pwd
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ${1: -4} == ".dmg" ]; then
    "$DIR/gen_sdk_package_darling_dmg.sh" $(realpath "$1")
    exit $?
fi

if [ ${1: -4} == ".xip" ]; then
    "$DIR/gen_sdk_package_xip.sh" $(realpath "$1")
    exit $?
fi

echo "Unrecognized extension ${1: -4}"
exit 1
