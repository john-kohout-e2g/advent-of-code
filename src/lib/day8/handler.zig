const std = @import("std");
const m = @import("map.zig").Node();

pub fn handle(input: []u8, b: bool, allocator: std.mem.Allocator) !void {
    const map = try m.init(allocator, input);
    defer map.deinit();
    if (b) {
        try map.run2();
    } else {
        try map.run();
    }

    const total = map.anti_node_map.count();

    std.debug.print("{any}\n", .{total});
}
