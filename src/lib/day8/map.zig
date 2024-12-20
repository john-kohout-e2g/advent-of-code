const std = @import("std");
const p = @import("point.zig");

const Allocator = std.mem.Allocator;
const Error = error{InvalidMap};

pub fn Node() type {
    return struct {
        allocator: Allocator,
        node_map: std.AutoHashMap(u8, std.ArrayList(p.Point)),
        anti_node_map: std.AutoHashMap(u32, bool),
        x_max: u32,
        y_max: u32,

        pub const Map = @This();

        pub fn init(allocator: Allocator, rawMap: []const u8) !*Map {
            const m = try allocator.create(Map);

            var splitInput = std.mem.split(u8, rawMap, "\n");

            var node_map = std.AutoHashMap(u8, std.ArrayList(p.Point)).init(allocator);
            const anti_node_map = std.AutoHashMap(u32, bool).init(allocator);

            var x: i16 = 0;
            var y: i16 = 0;
            while (splitInput.next()) |split| {
                x = 0;
                for (split) |char| {
                    if (char == '.') {
                        x += 1;
                        continue;
                    }

                    var nodes = node_map.get(char);
                    if (nodes == null) {
                        var n = std.ArrayList(p.Point).init(allocator);
                        try n.append(p.new(x, y));
                        try node_map.put(char, n);
                    } else {
                        var point = p.new(x, y);
                        _ = &point;
                        try nodes.?.append(point);
                        try node_map.put(char, nodes.?);
                    }
                    x += 1;
                }
                y += 1;
            }

            m.* = .{ .allocator = allocator, .anti_node_map = anti_node_map, .node_map = node_map, .y_max = @intCast(y), .x_max = @intCast(y) };
            return m;
        }

        pub fn deinit(self: *Map) void {
            var node_iterator = self.node_map.iterator();
            while (node_iterator.next()) |node| {
                node.value_ptr.deinit();
            }
            self.anti_node_map.deinit();
            self.node_map.deinit();
            self.allocator.destroy(self);
        }

        pub fn validPoint(self: *Map, point: p.Point) bool {
            if (point.x < 0 or point.y < 0) {
                return false;
            }
            if (point.x >= self.x_max - 1 or point.y >= self.y_max - 1) {
                return false;
            }
            // std.debug.print("x: {any} y: {any}\n", .{ point.x, point.y });
            return true;
        }

        pub fn run(self: *Map) !void {
            var iterator = self.node_map.iterator();
            while (iterator.next()) |entry| {
                const val = entry.value_ptr;
                // std.debug.print("k: {c} Arr: {any}\n", .{ entry.key_ptr.*, val.items });
                const last = val.items.len;
                for (0..last) |i| {
                    for (0..last) |j| {
                        if (i == j) {
                            continue;
                        }

                        var node = getAntiNode(val.items[i], val.items[j]);
                        if (self.validPoint(node)) {
                            try self.anti_node_map.put(node.encode(), true);
                        }
                    }
                }
            }
        }

        pub fn run2(self: *Map) !void {
            var iterator = self.node_map.iterator();
            while (iterator.next()) |entry| {
                const val = entry.value_ptr;
                const last = val.items.len;
                for (0..last) |i| {
                    for (0..last) |j| {
                        if (i == j) {
                            continue;
                        }

                        const nodes = try self.getAntiNodes(val.items[i], val.items[j]);
                        for (nodes) |node| {
                            try self.anti_node_map.put(p.encode2(node.x, node.y), true);
                        }
                        self.allocator.free(nodes);
                    }
                }
            }
        }

        fn getAntiNodes(self: *Map, a: p.Point, b: p.Point) ![]p.Point {
            var nodes = std.ArrayList(p.Point).init(self.allocator);
            defer nodes.deinit();

            const d_x = a.x - b.x;
            const d_y = a.y - b.y;

            var i: i16 = 0;

            while (true) {
                const new_node = p.new(a.x + i * d_x, a.y + i * d_y);
                if (!self.validPoint(new_node)) {
                    break;
                }
                i += 1;
                try nodes.append(new_node);
            }

            return nodes.toOwnedSlice();
        }
    };
}

fn getAntiNode(a: p.Point, b: p.Point) p.Point {
    return p.new(a.x + a.x - b.x, a.y + a.y - b.y);
}
