#!/bin/bash

# adapted from https://github.com/jprendes/emception/blob/master/build-llvm.sh

SRC=$(realpath $(dirname $0))

LLVM_COMMIT="$1"

if [ "$LLVM_COMMIT" == "" ]; then
    LLVM_COMMIT="3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff"
fi

LLVM_SRC="$SRC/llvm-project"
LLVM_BUILD="$SRC/out/build"
LLVM_INSTALL="$SRC/out/install"

# If we don't have a copy of LLVM, make one
if [ ! -d $LLVM_SRC/ ]; then
    git clone --depth 1 https://github.com/llvm/llvm-project.git "$LLVM_SRC/"

    pushd $LLVM_SRC/

    git fetch origin $LLVM_COMMIT
    git reset --hard $LLVM_COMMIT


    git apply $SRC/llvm-project.patch

    popd
fi

if [ ! -d $LLVM_BUILD ]; then
    CXXFLAGS="-Dwait4=__syscall_wait4" \
    emcmake cmake -G Ninja -S $LLVM_SRC/llvm -B $LLVM_BUILD \
        -DCMAKE_BUILD_TYPE="Release" \
        -DLLVM_BUILD_DOCS="OFF" \
        -DLLVM_BUILD_TOOLS="ON" \
        -DLLVM_DEFAULT_TARGET_TRIPLE="wasm32-wasi" \
        -DLLVM_ENABLE_BACKTRACES="OFF" \
        -DLLVM_ENABLE_BINDINGS="OFF" \
        -DLLVM_ENABLE_CRASH_OVERRIDES="OFF" \
        -DLLVM_ENABLE_LIBEDIT="OFF" \
        -DLLVM_ENABLE_LIBPFM="OFF" \
        -DLLVM_ENABLE_LIBXML2="OFF" \
        -DLLVM_ENABLE_OCAMLDOC="OFF" \
        -DLLVM_ENABLE_PIC="OFF" \
        -DLLVM_ENABLE_PROJECTS="clang" \
        -DLLVM_ENABLE_TERMINFO="OFF" \
        -DLLVM_ENABLE_THREADS="OFF" \
        -DLLVM_ENABLE_UNWIND_TABLES="OFF" \
        -DLLVM_ENABLE_ZLIB="OFF" \
        -DLLVM_ENABLE_ZSTD="OFF" \
        -DLLVM_INCLUDE_BENCHMARKS="OFF" \
        -DLLVM_INCLUDE_EXAMPLES="OFF" \
        -DLLVM_INCLUDE_TESTS="OFF" \
        -DLLVM_INCLUDE_UTILS="OFF" \
        -DLLVM_TARGETS_TO_BUILD="WebAssembly" \
        -DLLVM_TARGET_ARCH="wasm32-wasi"
fi

cmake --build $LLVM_BUILD
cmake -DCMAKE_INSTALL_PREFIX=$SRC/out/install -P $LLVM_BUILD/cmake_install.cmake