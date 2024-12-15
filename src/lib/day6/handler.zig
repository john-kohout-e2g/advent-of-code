const std = @import("std");
const Lab = @import("map.zig").Lab();

pub fn handle(input: []u8, alt: bool, allocator: std.mem.Allocator) !void {
    var map = try Lab.init(allocator, input);
    defer map.deinit();
    try map.run();

    var count: u32 = 0;

    if (!alt) {
        count = map.path.count();
    } else {
        count = try map.getNumberLoops();
    }
    std.debug.print("{any}\n", .{count});
}
