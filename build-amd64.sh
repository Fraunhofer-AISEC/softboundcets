#!/usr/bin/env bash

set -e

CC=/usr/bin/clang

MY_PATH="$(cd "$(dirname "$0")" ; pwd -P)"
LLVM_SRC_DIR="$MY_PATH/llvm-project/llvm"
BUILD_DIR="$MY_PATH/build"
LLVM_BUILD_DIR="$BUILD_DIR"

rm -rf "$BUILD_DIR" > /dev/null
mkdir -p "$BUILD_DIR"

# Build LLVM
LLVM_CMAKE_OPTIONS="\
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$LLVM_BUILD_DIR \
  -DLLVM_ENABLE_PROJECTS=clang;compiler-rt;lld \
  -DLLVM_TARGETS_TO_BUILD=host \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DLLVM_USE_LINKER=lld"

mkdir -p "$LLVM_BUILD_DIR"
cd "$LLVM_BUILD_DIR"
cmake -G Ninja "$LLVM_SRC_DIR" $LLVM_CMAKE_OPTIONS
ninja -j$(nproc)
