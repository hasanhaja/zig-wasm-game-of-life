const result = await WebAssembly.instantiateStreaming(fetch("./engine.wasm"), {
    env: {
        js_math_random: () => Math.random(),
        debug: () => console.log("Here"),
        inspect: (x) => console.log("INSPECT |>", x),
    },
});
const newUniverse = result.instance.exports.new;
const tickUniverse = result.instance.exports.tick;
const widthUniverse = result.instance.exports.width;
const heightUniverse = result.instance.exports.height;
const cellsUniverse = result.instance.exports.cells;
export const memory = result.instance.exports.memory;
export class Universe {
    #universePtr;
    constructor() {
        this.#universePtr = newUniverse();
    }
    tick() {
        tickUniverse(this.#universePtr);
    }
    width() {
        return widthUniverse(this.#universePtr);
    }
    height() {
        return heightUniverse(this.#universePtr);
    }
    cells() {
        return cellsUniverse(this.#universePtr);
    }
}
//# sourceMappingURL=engine.js.map