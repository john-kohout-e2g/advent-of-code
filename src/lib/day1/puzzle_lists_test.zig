const std = @import("std");
const pkg = @import("puzzle_lists.zig");

const expect = std.testing.expect;

test "happy_puzzle_lists_correct_total" {
    var left = [_]i32{ 3, 4, 2, 1, 3, 3 };
    var right = [_]i32{ 4, 3, 5, 3, 9, 3 };

    var pl = pkg.PuzzleLists{
        .left = &left,
        .right = &right,
    };

    const total = try pl.sortAndCalculate();
    try expect(total == 11);
}
