const std = @import("std");
const day1Handler = @import("../day1/handler.zig");
const day2 = @import("../day2/handler.zig");
const day3 = @import("../day3/handler.zig");
const day4 = @import("../day4/handler.zig");
const day5 = @import("../day5/handler.zig");
const day6 = @import("../day6/handler.zig");
const day7 = @import("../day7/handler.zig");
const day8 = @import("../day8/handler.zig");
const day9 = @import("../day9/handler.zig");
// const day10 = @import("../day10/handler.zig");
// const day11 = @import("../day11/handler.zig");
// const day12 = @import("../day12/handler.zig");
// const day13 = @import("../day13/handler.zig");
// const day14 = @import("../day14/handler.zig");
// const day15 = @import("../day15/handler.zig");
// const day16 = @import("../day16/handler.zig");
// const day17 = @import("../day17/handler.zig");
// const day18 = @import("../day18/handler.zig");
// const day19 = @import("../day19/handler.zig");
// const day20 = @import("../day20/handler.zig");
// const day21 = @import("../day21/handler.zig");
// const day22 = @import("../day22/handler.zig");
// const day23 = @import("../day23/handler.zig");
// const day24 = @import("../day24/handler.zig");

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
        4 => {
            try day4.handle(buffer[0..end_index], bside, allocator);
        },
        5 => {
            try day5.handle(buffer[0..end_index], bside, allocator);
        },
        6 => {
            try day6.handle(buffer[0..end_index], bside, allocator);
        },
        7 => {
            try day7.handle(buffer[0..end_index], bside, allocator);
        },
        8 => {
            try day8.handle(buffer[0..end_index], bside, allocator);
        },
        9 => {
            try day9.handle(buffer[0..end_index], bside, allocator);
        },
        // 10 => {
        //     try day10.handle(buffer[0..end_index], bside, allocator);
        // },
        // 11 => {
        //     try day11.handle(buffer[0..end_index], bside, allocator);
        // },
        // 12 => {
        //     try da12.handle(buffer[0..end_index], bside, allocator);
        // },
        // 13 => {
        //     try day13.handle(buffer[0..end_index], bside, allocator);
        // },
        // 14 => {
        //     try day14.handle(buffer[0..end_index], bside, allocator);
        // },
        // 15 => {
        //     try day15.handle(buffer[0..end_index], bside, allocator);
        // },
        // 16 => {
        //     try day16.handle(buffer[0..end_index], bside, allocator);
        // },
        // 17 => {
        //     try day17.handle(buffer[0..end_index], bside, allocator);
        // },
        // 18 => {
        //     try day18.handle(buffer[0..end_index], bside, allocator);
        // },
        // 19 => {
        //     try day19.handle(buffer[0..end_index], bside, allocator);
        // },
        // 20 => {
        //     try day20.handle(buffer[0..end_index], bside, allocator);
        // },
        // 21 => {
        //     try day21.handle(buffer[0..end_index], bside, allocator);
        // },
        // 22 => {
        //     try day22.handle(buffer[0..end_index], bside, allocator);
        // },
        // 23 => {
        //     try day23.handle(buffer[0..end_index], bside, allocator);
        // },
        // 24 => {
        //     try day24.handle(buffer[0..end_index], bside, allocator);
        // },
        else => {
            std.log.err("{d} is not a valid day", .{day});
        },
    }
}
