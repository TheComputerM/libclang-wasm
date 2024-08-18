#!/bin/bash

SRC=$(realpath $(dirname $0))

LLVM_SRC="$SRC/llvm-project"
LLVM_INSTALL="$SRC/out/install"
LIBCLANG_BIN="$SRC/out/bin"

emcc $LLVM_INSTALL/lib/*.a --no-entry \
    -sEXPORTED_FUNCTIONS=@$SRC/exports.txt \
    -sALLOW_MEMORY_GROWTH \
    -o $LIBCLANG_BIN/libclang.mjs
    