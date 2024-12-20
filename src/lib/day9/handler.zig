const std = @import("std");
const Defragger = @import("defrag.zig").Defragger;

pub fn handle(input: []u8, b: bool, allocator: std.mem.Allocator) !void {
    if (b) {
        return;
    }

    var splitInput = std.mem.split(u8, input, "\n");

    while (splitInput.next()) |s| {
        // std.debug.print("{s}", .{s});
        const result = try Defragger.defrag(allocator, s);

        std.log.info("{any}", .{result});
    }
}
