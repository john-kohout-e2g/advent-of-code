const std = @import("std");
const position = @import("position.zig");

const Allocator = std.mem.Allocator;
const BoolMap = std.AutoHashMap(u32, bool);
const DirMap = std.AutoHashMap(u32, position.Direction);
const Error = error{InvalidMap};

pub fn Lab() type {
    return struct {
        allocator: Allocator,
        blockers: BoolMap,
        path: BoolMap,
        direction_path: DirMap,
        looping: bool = false,
        guard: position.Position,
        custom_blocker: u32 = 0,
        x_max: u32,
        y_max: u32,

        pub const Map = @This();

        pub fn init(allocator: Allocator, rawMap: []const u8) !*Map {
            const m = try allocator.create(Map);

            var input = std.ArrayList([]const u8).init(allocator);
            defer input.deinit();

            var guard = position.new(0, 0);
            var blockers = std.AutoHashMap(u32, bool).init(allocator);

            var path = std.AutoHashMap(u32, bool).init(allocator);

            var direction_path = std.AutoHashMap(u32, position.Direction).init(allocator);
            _ = &direction_path;

            var splitInput = std.mem.split(u8, rawMap, "\n");

            var x: usize = 0;
            var y: usize = 0;
            while (splitInput.next()) |split| {
                x = 0;
                for (split) |char| {
                    if (char == '.') {
                        x += 1;
                        continue;
                    }
                    if (char == '^') {
                        guard = position.new(@intCast(x), @intCast(y));
                        try path.put(guard.encode(), true);
                        x += 1;
                        continue;
                    }
                    if (char == '#') {
                        var pos = position.new(@intCast(x), @intCast(y));
                        try blockers.put(pos.encode(), true);
                        x += 1;
                        continue;
                    }
                    x += 1;
                }
                y += 1;
            }

            m.* = .{ .allocator = allocator, .blockers = blockers, .path = path, .direction_path = direction_path, .guard = guard, .y_max = @intCast(y), .x_max = @intCast(y) };
            return m;
        }

        pub fn deinit(self: *Map) void {
            self.blockers.deinit();
            self.path.deinit();
            self.direction_path.deinit();
            self.allocator.destroy(self);
        }

        pub fn run(self: *Map) !void {
            var guard = position.new(self.guard.x, self.guard.y);
            _ = try run_inner(&guard, &self.blockers, &self.path, &self.direction_path, null, self.x_max, self.y_max);
        }

        pub fn getNumberLoops(self: *Map) !u32 {
            var count: u32 = 0;
            var iterator = self.path.iterator();
            while (iterator.next()) |kvp| {
                var direction_path = std.AutoHashMap(u32, position.Direction).init(self.allocator);
                defer direction_path.deinit();

                var guard = position.new(self.guard.x, self.guard.y);
                const custom_blocker = kvp.key_ptr.*;
                const looping = try run_inner(&guard, &self.blockers, null, &direction_path, custom_blocker, self.x_max, self.y_max);
                count += if (looping) 1 else 0;
            }
            return count;
        }

        fn run_inner(guard: *position.Position, blockers: *BoolMap, path: ?*BoolMap, direction_path: ?*DirMap, custom_blocker: ?u32, x_max: u32, y_max: u32) !bool {
            while (true) {
                guard.step() catch break;
                if (guard.x >= x_max or guard.y >= y_max) {
                    break;
                }

                var match = false;
                if (blockers.get(guard.encode())) |val| {
                    match = val;
                }

                if (custom_blocker != null and guard.encode() == custom_blocker.?) {
                    match = true;
                }

                if (match) {
                    if (direction_path != null) {
                        if (direction_path.?.get(guard.encode())) |direction| {
                            if (direction == guard.direction) {
                                return true;
                            }
                        }
                        try direction_path.?.put(guard.encode(), guard.direction);
                    }

                    guard.revert();
                    guard.direction = nextDirection(guard.direction);
                    continue;
                }

                if (path != null) {
                    try path.?.put(guard.encode(), true);
                    continue;
                }
            }
            return false;
        }
    };
}

fn nextDirection(direction: position.Direction) position.Direction {
    switch (direction) {
        position.Direction.up => return position.Direction.right,
        position.Direction.right => return position.Direction.down,
        position.Direction.down => return position.Direction.left,
        position.Direction.left => return position.Direction.up,
    }
}
