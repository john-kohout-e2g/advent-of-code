const std = @import("std");
const d = @import("reactor_data.zig");
const r = @import("reactor_report.zig");

pub fn handle(input: []u8, bside: bool, allocator: std.mem.Allocator) !void {
    var reports = std.ArrayList(r.ReactorReport).init(allocator);
    defer reports.deinit();

    var lines = std.mem.tokenize(u8, input, "\t\n\r");
    while (lines.next()) |lineToken| {
        var current_report = std.ArrayList(i32).init(allocator);
        defer current_report.deinit();

        var numbers = std.mem.tokenize(u8, lineToken, " ");
        while (numbers.next()) |number| {
            const n = try std.fmt.parseInt(i32, number, 10);
            try current_report.append(n);
        }
        try reports.append(r.ReactorReport{ .report = try current_report.toOwnedSlice() });
    }

    var data = d.ReactorData{ .reports = try reports.toOwnedSlice() };

    const total = if (bside) 0 else data.isSafe();
    std.log.info("{d}", .{total});

    return;
}
