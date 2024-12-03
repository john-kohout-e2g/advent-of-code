const std = @import("std");
const d = @import("reactor_data.zig");
const r = @import("reactor_report.zig");

const expect = std.testing.expect;

test "happy_reactor_data_2_safe" {
    var r1 = [_]i32{ 7, 6, 4, 2, 1 };
    var r2 = [_]i32{ 1, 2, 7, 8, 9 };
    var r3 = [_]i32{ 9, 7, 6, 2, 1 };
    var r4 = [_]i32{ 1, 3, 2, 4, 5 };
    var r5 = [_]i32{ 8, 6, 4, 4, 1 };
    var r6 = [_]i32{ 1, 3, 6, 7, 9 };

    var reports = [_]r.ReactorReport{ .{ .report = &r1 }, .{ .report = &r2 }, .{ .report = &r3 }, .{ .report = &r4 }, .{ .report = &r5 }, .{ .report = &r6 } };

    var data = d.ReactorData{ .reports = &reports };

    try expect(data.isSafe() == 2);
}
