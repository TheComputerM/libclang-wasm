# libclang.wasm

[LibClang](https://clang.llvm.org/docs/LibClang.html) compiled to WebAssembly so you can parse and traverse C/C++ source code anywhere, even in the browser!

It can be used in conjuction with libraries like [wasm-ffi](https://github.com/DeMille/wasm-ffi) and languages which provide wasm ffi interop like the experimental dart2wasm compiler (used to make [FFIgenPad](https://ffigenpad.surge.sh/))

This repository releases libclang.wasm, built with the default libclang symbols along with malloc+free, and the object/archive files to build your own binary with the necessary symbols. For direct JavaScript bindings, [libclangjs](https://github.com/donalffons/libclangjs) might be more suitable.

## Building Instructions

### Prerequisites

1. emscripten
2. cmake
3. ninja
4. a good cpu


There are bash scripts you can use to [setup, patch and build the llvm project](./build-llvm.sh) using emscripten and then use the built archive files to [build libclang.wasm](./build-libclang.sh).

You can also find some prebuilt archives on the releases page.

The reason why we patch the llvm-project is to provide a **fake** path to the main executable (which does not exist in WASM) but is useful for locating other resources and identifying default header locations.