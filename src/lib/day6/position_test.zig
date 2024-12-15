const std = @import("std");
const position = @import("position.zig");

const expect = std.testing.expect;

test "happy_position" {
    const p = position.new(10, 10);
    const encoded = p.encode();
    const p2 = position.decode(encoded);

    try expect(p.x == p2.x);
    try expect(p.y == p2.y);
}
