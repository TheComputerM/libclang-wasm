#!/bin/bash

# adapted from https://github.com/jprendes/emception/blob/master/build-llvm.sh

SRC=$(dirname $0)

LLVM_SRC="$1"

if [ "$LLVM_SRC" == "" ]; then
    LLVM_SRC=$(pwd)/llvm-project
fi

SRC=$(realpath "$SRC")

# If we don't have a copy of LLVM, make one
if [ ! -d $LLVM_SRC/ ]; then
    git clone --depth 1 --branch llvmorg-18.1.8 https://github.com/llvm/llvm-project.git "$LLVM_SRC/"

    pushd $LLVM_SRC/

    # The clang driver will sometimes spawn a new process to avoid memory leaks.
    # Since this complicates matters quite a lot for us, just disable that.
    git apply $SRC/llvm-project.patch

    popd
fi

if [ ! -d $LLVM_SRC/build ]; then
    CXXFLAGS="-Dwait4=__syscall_wait4" \
    emcmake cmake -G Ninja -S $LLVM_SRC/llvm -B $LLVM_SRC/build \
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

cmake --build $LLVM_SRC/build
cmake -DCMAKE_INSTALL_PREFIX=$LLVM_SRC/install -P $LLVM_SRC/build/cmake_install.cmake