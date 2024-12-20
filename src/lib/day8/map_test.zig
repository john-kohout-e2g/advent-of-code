const std = @import("std");
const m = @import("map.zig").Node();

const expect = std.testing.expect;

test "happy_antinodes" {
    const input = "............\n........0...\n.....0......\n.......0....\n....0.......\n......A.....\n............\n............\n........A...\n.........A..\n............\n............";

    const map = try m.init(std.testing.allocator, input);
    defer map.deinit();
    try map.run();
    const result = map.anti_node_map.count();

    try expect(result == 14);
}

test "happy_antinodes2" {
    const input = "............\n........0...\n.....0......\n.......0....\n....0.......\n......A.....\n............\n............\n........A...\n.........A..\n............\n............";

    const map = try m.init(std.testing.allocator, input);
    defer map.deinit();
    try map.run2();
    const result = map.anti_node_map.count();

    try expect(result == 34);
}
