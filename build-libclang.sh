#!/bin/bash

SRC=$(realpath $(dirname $0))

LLVM_SRC="$SRC/llvm-project"
LLVM_INSTALL="$SRC/out/install"
LIBCLANG_BIN="$SRC/out/bin"

mkdir -p $LIBCLANG_BIN

EXPORTED_METHODS=FS,wasmExports,addFunction,removeFunction,ccall,cwrap,UTF8ToString,stringToUTF8,writeArrayToMemory

emcc $LLVM_INSTALL/lib/*.a --no-entry \
    -sEXPORTED_FUNCTIONS=@exports.txt \
    -sWASM_BIGINT \
    -sALLOW_MEMORY_GROWTH -sALLOW_TABLE_GROWTH \
    -sEXPORTED_RUNTIME_METHODS=$EXPORTED_METHODS \
    -sMODULARIZE -sEXPORT_NAME=libclang \
    -o $LIBCLANG_BIN/libclang.mjs
