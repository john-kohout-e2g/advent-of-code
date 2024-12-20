const std = @import("std");

pub const Defragger = struct {
    pub fn defrag(allocator: std.mem.Allocator, input: []const u8) !i64 {
        var j: i64 = 0;

        var file = std.ArrayList(i64).init(allocator);
        defer file.deinit();
        for (input, 0..) |char, i| {
            const s = [1]u8{char};
            const num = try std.fmt.parseInt(i64, &s, 10);
            const end: usize = @intCast(num);
            if (i % 2 != 0) {
                for (0..end) |_| {
                    try file.append(-1);
                }
            } else {
                for (0..end) |_| {
                    try file.append(j);
                }
                j += 1;
            }
        }
        const s = try file.toOwnedSlice();

        const len: i64 = s.len;
        var i: i64 = 0;
        while (true) {
            if (i == len) {
                break;
            }
            if (s[@intCast(i)] != -1) {
                i += 1;
                continue;
            }

            var swapIndex = len - 1;
            while (true) {
                if (s[@intCast(swapIndex)] != -1) {
                    break;
                }
                swapIndex -= 1;
            }

            const swap = s[@intCast(swapIndex)];
            s[@intCast(i)] = swap;
            s[@intCast(swapIndex)] = -1;
            i += 1;
        }

        std.debug.print("{d}", .{len});
        i = 0;
        if (s[@intCast(len - 1)] != -1) {
            while (true) {
                if (i == len) {
                    break;
                }
                if (s[@intCast(i)] != -1) {
                    i += 1;
                    continue;
                }

                const swap = s[@intCast(len - 1)];
                s[@intCast(i)] = swap;
                s[@intCast(len - 1)] = -1;
                i += 1;
            }
        }

        var total: i64 = 0;
        for (s, 0..) |v, k| {
            if (v == -1) {
                break;
            } else {
                const id: i64 = @intCast(k);
                total += v * id;
            }
        }

        allocator.free(s);
        return total;
    }
};
