const std = @import("std");
const pkg = @import("reactor_report.zig");

const expect = std.testing.expect;

test "happy_reactor_report_is_safe" {
    var rawReport = [_]i32{ 7, 6, 4, 2, 1 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafe());
}

test "sad_reactor_report_is_not_safe" {
    var rawReport = [_]i32{ 1, 3, 2, 4, 5 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(!report.isSafe());
}

test "happy_reactor_report_is_safe_when_dampened" {
    var rawReport = [_]i32{ 1, 3, 2, 4, 5 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(1));
}

test "happy_increasing_reactor_report_is_safe_when_0_dampened" {
    var rawReport = [_]i32{ 9, 1, 2, 3, 4, 5 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(0));
}

test "happy_increasing_reactor_report_is_safe_when_1_dampened" {
    var rawReport = [_]i32{ 1, 9, 2, 3, 4, 5 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(1));
}

test "happy_increasing_reactor_report_is_safe_when_2_dampened" {
    var rawReport = [_]i32{ 1, 2, 9, 3, 4, 5 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(2));
}

test "happy_increasing_reactor_report_is_safe_when_3_dampened" {
    var rawReport = [_]i32{ 1, 2, 3, 9, 4, 5 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(3));
}

test "happy_increasing_reactor_report_is_safe_when_4_dampened" {
    var rawReport = [_]i32{ 1, 2, 3, 4, 9, 5 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(4));
}

test "happy_increasing_reactor_report_is_safe_when_5_dampened" {
    var rawReport = [_]i32{ 1, 2, 3, 4, 5, 9 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(5));
}

test "happy_decreasing_reactor_report_is_safe_when_0_dampened" {
    var rawReport = [_]i32{ 9, 5, 4, 3, 2, 1 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(0));
}

test "happy_decreasing_reactor_report_is_safe_when_1_dampened" {
    var rawReport = [_]i32{ 5, 9, 4, 3, 2, 1 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(1));
}

test "happy_decreasing_reactor_report_is_safe_when_2_dampened" {
    var rawReport = [_]i32{ 5, 4, 9, 3, 2, 1 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(2));
}

test "happy_decreasing_reactor_report_is_safe_when_3_dampened" {
    var rawReport = [_]i32{ 5, 4, 3, 9, 2, 1 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(3));
}

test "happy_decreasing_reactor_report_is_safe_when_4_dampened" {
    var rawReport = [_]i32{ 5, 4, 3, 2, 9, 1 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(4));
}

test "happy_decreasing_reactor_report_is_safe_when_5_dampened" {
    var rawReport = [_]i32{ 5, 4, 3, 2, 1, 9 };
    var report = pkg.ReactorReport{ .report = &rawReport };

    try expect(report.isSafeDampened(5));
}
