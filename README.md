# libclang.wasm

[LibClang](https://clang.llvm.org/docs/LibClang.html) compiled to WebAssembly so you can traverse C/C++ ASTs anywhere, even in the browser!

This aims to provide steps to make your own binary with the necessary symbols for things like WASM foreign functions. For direct JavaScript bindings, [libclangjs](https://github.com/donalffons/libclangjs) might be more suitable.

## Building Instructions

The steps and explanation on how to build libclang is detailed in [this blog post](TODO). There is also a [bash script](./build.sh) you can use to automatically build it on your system.

### Prerequisites

1. emscripten toolchain
2. cmake
3. ninja
4. a good cpu

