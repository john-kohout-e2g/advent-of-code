const std = @import("std");
const orderer = @import("orderer.zig");

pub fn handle(i: []u8, alt: bool, allocator: std.mem.Allocator) !void {
    var input = std.ArrayList([]const u8).init(allocator);
    defer input.deinit();

    var splitInput = std.mem.split(u8, i, "\n");

    while (splitInput.next()) |token| {
        try input.append(token);
    }

    var raw_rules = std.ArrayList([]const u8).init(allocator);
    defer raw_rules.deinit();
    var rawData = std.ArrayList([]const u8).init(allocator);
    defer rawData.deinit();

    var in_section2 = false;
    for (input.items) |line| {
        if (std.mem.eql(u8, line, "")) {
            in_section2 = true;
            continue;
        } else if (in_section2) {
            try rawData.append(line);
        } else {
            try raw_rules.append(line);
        }
    }

    const po = orderer.PageOrderer();

    const rules: [][]const u8 = try raw_rules.toOwnedSlice();
    const o = try po.init(allocator, rules);
    defer o.deinit();
    allocator.free(rules);

    const data = try rawData.toOwnedSlice();
    const answer = try o.solve(data, alt);
    allocator.free(data);

    std.log.info("{d}", .{answer});
}
