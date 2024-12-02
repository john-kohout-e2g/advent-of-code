const std = @import("std");
const day1 = @import("puzzle_lists.zig");

pub fn handle(input: []u8, bside: bool, allocator: std.mem.Allocator) !void {
    return if (bside) {
        try handleBSide(input, allocator);
    } else {
        try handleASide(input, allocator);
    };
}

fn handleASide(input: []u8, allocator: std.mem.Allocator) !void {
    var left = std.ArrayList(i32).init(allocator);
    var right = std.ArrayList(i32).init(allocator);

    defer left.deinit();
    defer right.deinit();

    var lineTokenizer = std.mem.tokenize(u8, input, "\t\n\r");
    while (lineTokenizer.next()) |lineToken| {
        var tokenizer = std.mem.tokenize(u8, lineToken, " ");

        var l: i32 = 0;
        var r: i32 = 0;
        if (tokenizer.next()) |value| {
            l = try std.fmt.parseInt(i32, value, 10);
        }

        if (tokenizer.next()) |value| {
            r = try std.fmt.parseInt(i32, value, 10);
        }

        try left.append(l);
        try right.append(r);
    }
    var pl = day1.PuzzleLists{
        .left = left.items,
        .right = right.items,
    };
    const total = try pl.calculateTotal();
    std.log.info("{d}", .{total});
    return;
}

fn handleBSide(_: []u8, _: std.mem.Allocator) !void {
    return;
}
