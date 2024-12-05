const std = @import("std");
const finder = @import("finder.zig");

const expect = std.testing.expect;

test "happy_xmas" {
    var puzzle = "MMMSXXMASM\nMSAMXMSMSA\nAMXSXMAAMM\nMSAMASMSMX\nXMASAMXAMM\nXXAMMXXAMA\nSMSMSASXSS\nSAXAMASAAA\nMAMMMXMMMM\nMXMXAXMASX\n".*;
    const s = finder.XmasPuzzleSolver();
    const solver = try s.init(std.testing.allocator, &puzzle);
    defer solver.deinit();

    const answer = try solver.solveForXmas();

    try expect(answer == 18);
}

test "happy_x-mas" {
    var puzzle = "MMMSXXMASM\nMSAMXMSMSA\nAMXSXMAAMM\nMSAMASMSMX\nXMASAMXAMM\nXXAMMXXAMA\nSMSMSASXSS\nSAXAMASAAA\nMAMMMXMMMM\nMXMXAXMASX\n".*;
    const s = finder.XmasPuzzleSolver();
    const solver = try s.init(std.testing.allocator, &puzzle);
    defer solver.deinit();

    const answer = try solver.solveForCrossMas();

    try expect(answer == 9);
}
