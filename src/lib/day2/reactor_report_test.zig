const std = @import("std");
const pkg = @import("reactor_report.zig");

const expect = std.testing.expect;

test "happy_reactor_report_is_safe" {
    var rawReport = [_]i32{ 7, 6, 4, 2, 1 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafe());
}

test "sad_reactor_report_is_not_safe" {
    var rawReport = [_]i32{ 1, 2, 7, 8, 9 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(!report.isSafe());
}
