const std = @import("std");
const Lab = @import("map.zig").Lab();

const expect = std.testing.expect;

test "happy_map" {
    const rawMap = "....#.....\n.........#\n..........\n..#.......\n.......#..\n..........\n.#..^.....\n........#.\n#.........\n......#...";
    var map = try Lab.init(std.testing.allocator, rawMap);
    defer map.deinit();

    try expect(map.x_max == 10);
    try expect(map.y_max == 10);
    try expect(map.blockers.count() == 8);

    try map.run();

    try expect(map.path.count() == 41);

    const count: u32 = try map.getNumberLoops();
    try expect(count == 6);
}
