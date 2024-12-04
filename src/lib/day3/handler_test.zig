const std = @import("std");
const pkg = @import("handler.zig");

const expect = std.testing.expect;

test "happy_aSide_correct_total" {
    var input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))".*;
    const total = try pkg.aSide(&input);
    try expect(total == 161);
}

test "happy_bSide_correct_total" {
    var input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))".*;
    const total = try pkg.bSide(&input);
    try expect(total == 48);
}
