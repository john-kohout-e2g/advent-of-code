const std = @import("std");
const day1Handler = @import("../day1/handler.zig");

pub fn handle(day: u32, input: []const u8) !void {
    var file = try std.fs.cwd().openFile(input, .{});
    defer file.close();
    const stat = try file.stat();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var buffer = try allocator.alloc(u8, stat.size);
    defer allocator.free(buffer);

    const end_index = try file.readAll(buffer);

    switch (day) {
        1 => {
            try day1Handler.handle(buffer[0..end_index]);
        },
        else => {
            std.log.err("{d} is not a valid day", .{day});
        },
    }
}
