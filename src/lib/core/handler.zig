const std = @import("std");
const day1Handler = @import("../day1/handler.zig");
const day2 = @import("../day2/handler.zig");
const day3 = @import("../day3/handler.zig");

pub fn handle(day: u32, bside: bool, input: []const u8, allocator: std.mem.Allocator) !void {
    var file = try std.fs.cwd().openFile(input, .{});
    defer file.close();
    const stat = try file.stat();

    var buffer = try allocator.alloc(u8, stat.size);
    defer allocator.free(buffer);

    const end_index = try file.readAll(buffer);

    switch (day) {
        1 => {
            try day1Handler.handle(buffer[0..end_index], bside, allocator);
        },
        2 => {
            try day2.handle(buffer[0..end_index], bside, allocator);
        },
        3 => {
            try day3.handle(buffer[0..end_index], bside, allocator);
        },
        else => {
            std.log.err("{d} is not a valid day", .{day});
        },
    }
}
