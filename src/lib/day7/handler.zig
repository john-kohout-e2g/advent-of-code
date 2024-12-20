const std = @import("std");
const Eq = @import("equation.zig").Eq();
const RwLock = std.Thread.RwLock;
const Allocator = std.mem.Allocator;

const Result = struct {
    lock: RwLock = .{},
    results: *std.ArrayList(u64),

    pub fn append(self: *Result, entry: u64) !void {
        self.lock.lock();
        defer self.lock.unlock();

        try self.results.append(entry);
    }
};

pub fn handle(input: []u8, b: bool, allocator: std.mem.Allocator) !void {
    var size: u64 = 0;
    var splitInput = std.mem.split(u8, input, "\n");

    while (splitInput.next()) |_| {
        size += 1;
    }
    splitInput.reset();

    var r = std.ArrayList(u64).init(allocator);
    defer r.deinit();

    var results = Result{ .results = &r };

    var pool: std.Thread.Pool = undefined;
    try pool.init(.{ .allocator = allocator, .n_jobs = 24 });
    defer pool.deinit();

    var wg = std.Thread.WaitGroup{};
    var total: u64 = 0;
    var i: u32 = 0;
    while (splitInput.next()) |split| {
        const eq = try Eq.init(allocator, split);
        const val = try eq.solve();
        if (val == 0 and b) {
            wg.start();
            try pool.spawn(work, .{ eq, &results, &wg });
        } else {
            eq.deinit();
        }

        i += 1;
        total += val;
    }
    wg.wait();

    for (results.results.items) |item| {
        total += item;
    }

    std.debug.print("{any}\n", .{total});
}

fn work(eq: *Eq.Equation, result: *Result, wg: *std.Thread.WaitGroup) void {
    defer eq.deinit();
    const val = eq.solve2() catch |err| {
        std.debug.print("{any}\n", .{err});
        wg.finish();
        return;
    };
    if (val != 0) {
        result.append(val) catch |err| {
            wg.finish();
            std.debug.print("{any}\n", .{err});
            return;
        };
    }

    wg.finish();
}
