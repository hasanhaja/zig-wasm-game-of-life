const result = await WebAssembly.instantiateStreaming(fetch("./engine.wasm"), {
  env: {
    js_math_random: () => Math.random(),
    debug: () => console.log("Here"),
    inspect: (x: number) => console.log("INSPECT |>", x),
  },
});

type Pointer = number;

const newUniverse = result.instance.exports.new as (() => Pointer);
const tickUniverse = result.instance.exports.tick as ((ptr: Pointer) => void);
const widthUniverse = result.instance.exports.width as ((ptr: Pointer) => number);
const heightUniverse = result.instance.exports.height as ((ptr: Pointer) => number);
const cellsUniverse = result.instance.exports.cells as ((ptr: Pointer) => Pointer);

export const memory = result.instance.exports.memory as WebAssembly.Memory;

export class Universe {
  readonly #universePtr: Pointer;

  constructor() {
    this.#universePtr = newUniverse();  
  }

  public tick() {
    tickUniverse(this.#universePtr);
  }

  public width(): number {
    return widthUniverse(this.#universePtr);
  }

  public height(): number {
    return heightUniverse(this.#universePtr);
  }

  public cells(): Pointer {
    return cellsUniverse(this.#universePtr);
  }
}
