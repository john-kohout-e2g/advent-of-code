const std = @import("std");
const mvzr = @import("mvzr");

const Error = error{OutOfBounds};

pub fn handle(input: []u8, alt: bool, _: std.mem.Allocator) !void {
    const total = if (alt) try bSide(input) else try aSide(input);
    std.log.info("{d}", .{total});
}

pub fn bSide(input: []u8) !u32 {
    const patt_str = "(mul\\([0-9]{1,3},[0-9]{1,3}\\))|(don't\\(\\))|(do\\(\\))";
    const regex: mvzr.Regex = mvzr.compile(patt_str).?;
    var iter = regex.iterator(input);

    var total: u32 = 0;
    var enabled = true;
    while (iter.next()) |m| {
        if (std.mem.eql(u8, m.slice, "don't()")) {
            enabled = false;
            continue;
        }

        if (std.mem.eql(u8, m.slice, "do()")) {
            enabled = true;
            continue;
        }

        if (!enabled) {
            continue;
        }

        const n = m.slice[4 .. m.slice.len - 1];
        var split = std.mem.split(u8, n, ",");

        var first: u32 = 0;
        var second: u32 = 0;
        var index: usize = 0;

        while (split.next()) |num| {
            switch (index) {
                0 => first = try std.fmt.parseInt(u32, num, 10),
                1 => second = try std.fmt.parseInt(u32, num, 10),
                else => return Error.OutOfBounds,
            }
            index += 1;
        }

        total += first * second;
    }
    return total;
}

pub fn aSide(input: []u8) !u32 {
    const patt_str = "mul\\([0-9]{1,3},[0-9]{1,3}\\)";
    const regex: mvzr.Regex = mvzr.compile(patt_str).?;
    var iter = regex.iterator(input);

    var total: u32 = 0;
    while (iter.next()) |m| {
        const n = m.slice[4 .. m.slice.len - 1];
        var split = std.mem.split(u8, n, ",");

        var first: u32 = 0;
        var second: u32 = 0;
        var index: usize = 0;

        while (split.next()) |num| {
            switch (index) {
                0 => first = try std.fmt.parseInt(u32, num, 10),
                1 => second = try std.fmt.parseInt(u32, num, 10),
                else => return Error.OutOfBounds,
            }
            index += 1;
        }

        total += first * second;
    }
    return total;
}
