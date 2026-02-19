# Zig WASM Game of life

Port of the Rust version I did following a tutorial verbatim about 4 years ago: https://github.com/hasanhaja/wasm-game-of-life.

## Motivation

I didn't understand the the game logic, the stack or the platform then, and it was all quite magical with how wasm-bindgen created all of the glue for me. This time the motivation was:

- Understand the code for the game logic
- Understand the boilerplate I need to assemble everything
- Understand how you can create more complex objects (especially structs) when using WASM and pass pointers around

My experience playing with [Zig + WASM 3 years ago](https://github.com/hasanhaja/zig-wasm/tree/main) helped.

## Stack

- Zig and the standard toolchain to generate the WASM library
- Zig's built-in `wasm_allocator` so that I can generate a freestanding binary
- ES Modules
- TypeScript and `tsc`
- Matt Pocock's `@total-typescript/tsconfig` to get up and running quickly with TypeScript

## Pre-requisites

For compilation and execution:

- Zig 0.15.2
- Node.js v25

Executing the `run.sh` script does the following:

- Compile the Zig code to WASM
- Compile the TypeScript code to JavaScript
- Copy the WASM binary to the `_site` output directory
- Serve `_site` with a HTTP server

For execution only, serve `www/_site` with any HTTP server. I'm using `npx serve` here.

## Future considerations

I'm currently using the ReleaseSmall flag and the `wasm_allocator` to keep the WASM binary small, but following the techniques from the original tutorial might help me get it down even smaller: https://rustwasm.github.io/docs/book/game-of-life/code-size.html

Another thing I'd like to explore as a part of this is translating the WASM file to the WAT format to try and understand some of the assembly code.
