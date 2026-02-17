//! By convention, root.zig is the root source file when making a library.
const std = @import("std");
const IntegerBitSet = std.bit_set.IntegerBitSet;

const Universe = extern struct {
    width: u32,
    height: u32,
    cells: IntegerBitSet,

    pub fn get_index(self: Universe, row: u32, column: u32) usize {
        return @as(usize, row * self.width + column);
    }

    pub fn live_neighbor_count(self: Universe, row: u32, column: u32) u8 {
        var count = 0;
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
                count += @as(u8, self.cells[idx]);
            }
        }
        return count;
    }
};

extern fn js_math_random() f64;

// You can only return primitive values across the WASM boundary (currently), so return a pointer
export fn new() *const Universe {
    const WIDTH = 64;
    const HEIGHT = 64;

    const size = @as(u16, WIDTH * HEIGHT);
    var CELLS = IntegerBitSet(size);

    for (0..size) |i| {
        CELLS.setValue(i, js_math_random() > 0.5);
    }

    return &.{
        .width = WIDTH,
        .height = HEIGHT,
        .cells = CELLS,
    };
}

fn get_next_value(cell: bool, live_neighbor: u8) bool {
    if (cell) {
        return live_neighbor == 2 or live_neighbor == 3;
    } else {
        return live_neighbor == 3;
    }
}

export fn tick(self: *Universe) void {
    var next = IntegerBitSet(@as(u16, self.cells.bit_length)).initEmpty();
    next.mask = self.cells.mask;

    for (0..self.height) |row| {
        for (0..self.width) |col| {
            const idx = self.get_index(row, col);
            const cell = self.cells[idx];
            const live_neighbor = self.live_neighbor_count(row, col);
            const nextValue = get_next_value(cell, live_neighbor);
            next.setValue(idx, nextValue);
        }
    }
    self.cells = next;
}

export fn width(self: *const Universe) u32 {
    return self.width;
}

export fn height(self: *const Universe) u32 {
    return self.height;
}

export fn cells(self: *const Universe) *const IntegerBitSet {
    return &self.cells;
}

// TODO This would return a string so it might need to allocate
export fn render(_: *const Universe) u32 {
// pub fn bufferedPrint() !void {
//     // Stdout is for the actual output of your application, for example if you
//     // are implementing gzip, then only the compressed bytes should be sent to
//     // stdout, not any debugging messages.
//     var stdout_buffer: [1024]u8 = undefined;
//     var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
//     const stdout = &stdout_writer.interface;

//     try stdout.print("Run `zig build test` to run the tests.\n", .{});

//     try stdout.flush(); // Don't forget to flush!
// }
    @panic("TODO");
}

test "Universe" {
    // try std.testing.expect(add(3, 7) == 10);
}
