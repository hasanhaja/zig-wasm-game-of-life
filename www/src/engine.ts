const result = await WebAssembly.instantiateStreaming(fetch("./engine.wasm"), {
  env: {
    js_math_random: () => Math.random(),
    debug: () => console.log("Here"),
    inspect: (x: number) => console.log("INSPECT |>", x),
  },
});

type Pointer = number;

const newUniverse = result.instance.exports.new as ((width: number, height: number) => Pointer);
const tickUniverse = result.instance.exports.tick as ((ptr: Pointer) => void);
const widthUniverse = result.instance.exports.getWidth as ((ptr: Pointer) => number);
const heightUniverse = result.instance.exports.getHeight as ((ptr: Pointer) => number);
const cellsUniverse = result.instance.exports.getCells as ((ptr: Pointer) => Pointer);
const isAliveUniverse = result.instance.exports.isAlive as ((ptr: Pointer, idx: number) => number);
const destroyUniverse = result.instance.exports.destroy as ((ptr: Pointer) => void);

export const memory = result.instance.exports.memory as WebAssembly.Memory;

export class Universe {
  readonly #universePtr: Pointer;

  constructor(width: number, height: number) {
    this.#universePtr = newUniverse(width, height);
  }

  public tick() {
    tickUniverse(this.#universePtr);
  }

  public isAlive(idx: number): boolean {
    return isAliveUniverse(this.#universePtr, idx) === 1;
  }

  public get width(): number {
    return widthUniverse(this.#universePtr);
  }

  public get height(): number {
    return heightUniverse(this.#universePtr);
  }

  public get cells(): Pointer {
    return cellsUniverse(this.#universePtr);
  }

  public destroy() {
    destroyUniverse(this.#universePtr);
  }
}
