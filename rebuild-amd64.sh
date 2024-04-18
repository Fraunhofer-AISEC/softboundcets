#!/usr/bin/env bash

set -e

CC=/usr/bin/clang

MY_PATH="$(cd "$(dirname "$0")" ; pwd -P)"
BUILD_DIR="$MY_PATH/build"
LLVM_BUILD_DIR="$BUILD_DIR"

cd "$LLVM_BUILD_DIR"
ccache ninja -j$(nproc)
