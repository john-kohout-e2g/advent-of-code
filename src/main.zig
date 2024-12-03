const std = @import("std");
const yazap = @import("yazap");
const handler = @import("lib/core/handler.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();
const log = std.log;
const App = yazap.App;
const Arg = yazap.Arg;

pub fn main() anyerror!void {
    var app = App.init(allocator, "advent-of-code", "Advent of code solution generator");
    defer app.deinit();

    var root_cmd = app.rootCommand();
    root_cmd.setProperty(.help_on_empty_args);

    var day_opt = Arg.singleValueOption("day", 'd', "The advent of code day to run");
    day_opt.setValuePlaceholder("1");

    try root_cmd.addArg(day_opt);
    try root_cmd.addArg(Arg.singleValueOption("input", 'i', "The path to the input file"));

    try root_cmd.addArg(Arg.booleanOption("b-side", 'b', "The b-side or part 2 portion of the day"));

    const matches = try app.parseProcess();
    if (matches.containsArg("version")) {
        log.info("v0.1.0", .{});
        return;
    }

    const day: u32 = blk: {
        if (matches.getSingleValue("day")) |d| {
            const parsedDay = try std.fmt.parseInt(u32, d, 10);
            break :blk parsedDay;
        } else {
            std.log.err("day is required", .{});
            return;
        }
    };
    if (day == 0) {
        return;
    }

    const input = blk: {
        if (matches.getSingleValue("input")) |i| {
            break :blk i;
        } else {
            std.log.err("input is required", .{});
            break :blk "";
        }
    };
    if (input.len == 0) {
        return;
    }
    var bside = false;

    if (matches.containsArg("b-side")) {
        bside = true;
    }

    try handler.handle(day, bside, input, allocator);
}
