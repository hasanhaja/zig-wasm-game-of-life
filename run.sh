#! /bin/bash

cd engine
zig build

cd ../www
npm run build
rm _site/engine.wasm
cp ../engine/zig-out/bin/engine.wasm _site/

npx serve -p 3001 _site
