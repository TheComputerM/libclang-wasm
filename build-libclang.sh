#!/bin/bash

SRC=$(dirname $0)

LLVM_SRC="$1"

if [ "$LLVM_SRC" == "" ]; then
    LLVM_SRC=$(pwd)/llvm-project
fi

SRC=$(realpath "$SRC")

emcc $LLVM_SRC/install/lib/*.a --no-entry \
    -sEXPORTED_FUNCTIONS=@$SRC/exports.txt \
    -sALLOW_MEMORY_GROWTH \
    -o $SRC/bin/libclang.mjs
    