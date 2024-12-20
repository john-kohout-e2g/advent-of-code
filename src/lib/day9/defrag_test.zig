const std = @import("std");
const Defragger = @import("defrag.zig").Defragger;

const expect = std.testing.expect;

test "happy_defrag" {
    var input = "2333133121414131402".*;
    const result = try Defragger.defrag(std.testing.allocator, &input);
    try expect(result == 1928);
}
