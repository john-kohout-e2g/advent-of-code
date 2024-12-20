const std = @import("std");
const Eq = @import("equation.zig").Eq();

const expect = std.testing.expect;

test "happy_equation" {
    const rawEq = "190: 10 19";

    var eq = try Eq.init(std.testing.allocator, rawEq);
    defer eq.deinit();
    const total = try eq.solve();
    try expect(total == 190);
}

test "happy_equations" {
    const rawEqs = "190: 10 19\n3267: 81 40 27\n83: 17 5\n156: 15 6\n7290: 6 8 6 15\n161011: 16 10 13\n192: 17 8 14\n21037: 9 7 18 13\n292: 11 6 16 20";

    var splitInput = std.mem.split(u8, rawEqs, "\n");

    var total: u64 = 0;
    while (splitInput.next()) |split| {
        const eq = try Eq.init(std.testing.allocator, split);
        defer eq.deinit();

        total += try eq.solve();
    }
    try expect(total == 3749);
}

test "happy_equations2" {
    const rawEqs = "190: 10 19\n3267: 81 40 27\n83: 17 5\n156: 15 6\n7290: 6 8 6 15\n161011: 16 10 13\n192: 17 8 14\n21037: 9 7 18 13\n292: 11 6 16 20";

    var splitInput = std.mem.split(u8, rawEqs, "\n");

    var total: u64 = 0;
    while (splitInput.next()) |split| {
        const eq = try Eq.init(std.testing.allocator, split);
        defer eq.deinit();

        total += try eq.solve2();
    }
    try expect(total == 11387);
}
