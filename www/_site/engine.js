const result = await WebAssembly.instantiateStreaming(fetch("./engine.wasm"), {
    env: {
        js_math_random: () => Math.random(),
        debug: () => console.log("Here"),
        inspect: (x) => console.log("INSPECT |>", x),
    },
});
const newUniverse = result.instance.exports.new;
const tickUniverse = result.instance.exports.tick;
const widthUniverse = result.instance.exports.getWidth;
const heightUniverse = result.instance.exports.getHeight;
const cellsUniverse = result.instance.exports.getCells;
const isAliveUniverse = result.instance.exports.isAlive;
const destroyUniverse = result.instance.exports.destroy;
export const memory = result.instance.exports.memory;
export class Universe {
    #universePtr;
    constructor() {
        this.#universePtr = newUniverse();
    }
    tick() {
        tickUniverse(this.#universePtr);
    }
    isAlive(idx) {
        return isAliveUniverse(this.#universePtr, idx) === 1;
    }
    get width() {
        return widthUniverse(this.#universePtr);
    }
    get height() {
        return heightUniverse(this.#universePtr);
    }
    get cells() {
        return cellsUniverse(this.#universePtr);
    }
    destroy() {
        destroyUniverse(this.#universePtr);
    }
}
//# sourceMappingURL=engine.js.map