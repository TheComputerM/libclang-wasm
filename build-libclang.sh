#!/bin/bash

SRC=$(realpath $(dirname $0))

LLVM_SRC="$SRC/llvm-project"
LLVM_INSTALL="$SRC/out/install"
LIBCLANG_BIN="$SRC/out/bin"

mkdir -p $LIBCLANG_BIN

emcc $LLVM_INSTALL/lib/*.a --no-entry \
    -sEXPORTED_FUNCTIONS=@exports.txt \
    -sWASM_BIGINT \
    -sALLOW_MEMORY_GROWTH -sALLOW_TABLE_GROWTH \
    -sEXPORTED_RUNTIME_METHODS=FS,wasmExports,addFunction,removeFunction \
    -o $LIBCLANG_BIN/libclang.mjs
    