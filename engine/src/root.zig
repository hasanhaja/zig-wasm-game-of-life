//! By convention, root.zig is the root source file when making a library.
const std = @import("std");
const ArrayBitSet = std.bit_set.ArrayBitSet;

extern fn js_math_random() f64;
extern fn debug() void;
extern fn inspect(x: usize) void;

const WIDTH = 200;
const HEIGHT = 150;

const size = @as(u16, WIDTH * HEIGHT);
const BitSet = ArrayBitSet(u8, size);

var allocator = std.heap.wasm_allocator;

const Universe = struct {
    width: u32,
    height: u32,
    cells: BitSet,

    pub fn get_index(self: *const Universe, row: u32, column: u32) usize {
        return @as(usize, row * self.width + column);
    }

    pub fn live_neighbor_count(self: *const Universe, row: u32, column: u32) u8 {
        var count: u8 = 0;
        const row_iter: [3]u32 = .{ self.height - 1, 0, 1 };
        const col_iter: [3]u32 = .{ self.width - 1, 0, 1 };

        for (row_iter) |delta_row| {
            for (col_iter) |delta_col| {
                if (delta_row == 0 and delta_col == 0) {
                    continue;
                }
                const neighbor_row = @mod(row + delta_row, self.height);
                const neighbor_col = @mod(column + delta_col, self.width);
                const idx = self.get_index(neighbor_row, neighbor_col);
                if (self.cells.isSet(idx)) {
                    count += 1;
                }
            }
        }
        return count;
    }

    export fn isAlive(self: *Universe, idx: usize) bool {
        return self.cells.isSet(idx);
    }

    export fn tick(self: *Universe) void {
        var next = BitSet.initEmpty();

        for (0..self.height) |row| {
            for (0..self.width) |col| {
                const idx = self.get_index(row, col);
                const cell = self.cells.isSet(idx);
                const live_neighbor = self.live_neighbor_count(row, col);
                const nextValue = get_next_value(cell, live_neighbor);
                next.setValue(idx, nextValue);
            }
        }
        self.cells = next;
    }

    export fn getWidth(self: *const Universe) u32 {
        return self.width;
    }

    export fn getHeight(self: *const Universe) u32 {
        return self.height;
    }

    export fn getCells(self: *const Universe) *const BitSet {
        return &self.cells;
    }

    export fn destroy(self: *Universe) void {
        allocator.destroy(self);
    }
};

// You can only return primitive values across the WASM boundary (currently), so return a pointer, which is a number that is an offset in linear memory
export fn new() *Universe {
    var CELLS = BitSet.initEmpty();

    for (0..size) |i| {
        CELLS.setValue(i, js_math_random() > 0.5);
    }

    const universe = allocator.create(Universe) catch unreachable;
    universe.* = .{
        .width = WIDTH,
        .height = HEIGHT,
        .cells = CELLS,
    };
    return universe;
}

fn get_next_value(cell: bool, live_neighbor: u8) bool {
    if (cell) {
        return live_neighbor == 2 or live_neighbor == 3;
    } else {
        return live_neighbor == 3;
    }
}

test "Universe" {
    // try std.testing.expect(add(3, 7) == 10);
}
