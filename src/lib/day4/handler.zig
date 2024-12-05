const std = @import("std");
const finder = @import("finder.zig");

pub fn handle(input: []u8, alt: bool, allocator: std.mem.Allocator) !void {
    const s = finder.XmasPuzzleSolver();
    const solver = try s.init(allocator, input);
    defer solver.deinit();

    const answer = if (alt) try solver.solveForCrossMas() else try solver.solveForXmas();
    std.log.info("{d}", .{answer});
}
