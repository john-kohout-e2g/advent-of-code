const std = @import("std");
const PageOrderer = @import("orderer.zig").PageOrderer();

const expect = std.testing.expect;

test "happy_ordering_one_row" {
    const input = "47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13".*;

    var splitInput = std.mem.split(u8, &input, "\n");

    var i = std.ArrayList([]const u8).init(std.testing.allocator);
    defer i.deinit();

    while (splitInput.next()) |token| {
        try i.append(token);
    }

    // const po = orderer.PageOrderer();

    const slice: [][]const u8 = try i.toOwnedSlice();
    const o = try PageOrderer.init(std.testing.allocator, slice);
    defer o.deinit();

    const data = "75,47,61,53,29";
    var splitData = std.mem.split(u8, data, "\n");

    var d = std.ArrayList([]const u8).init(std.testing.allocator);
    defer d.deinit();

    while (splitData.next()) |token| {
        try d.append(token);
    }

    const s = try d.toOwnedSlice();
    const answer = try o.solve(s, false);
    std.testing.allocator.free(s);
    std.testing.allocator.free(slice);

    try expect(answer == 61);
}

test "sad_ordering_one_row" {
    const input = "47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13".*;

    var splitInput = std.mem.split(u8, &input, "\n");

    var i = std.ArrayList([]const u8).init(std.testing.allocator);
    defer i.deinit();

    while (splitInput.next()) |token| {
        try i.append(token);
    }

    // const po = orderer.PageOrderer();

    const slice: [][]const u8 = try i.toOwnedSlice();
    const o = try PageOrderer.init(std.testing.allocator, slice);
    defer o.deinit();

    const data = "61,13,29";
    var splitData = std.mem.split(u8, data, "\n");

    var d = std.ArrayList([]const u8).init(std.testing.allocator);
    defer d.deinit();

    while (splitData.next()) |token| {
        try d.append(token);
    }

    const s = try d.toOwnedSlice();
    const answer = try o.solve(s, false);
    std.testing.allocator.free(s);
    std.testing.allocator.free(slice);

    try expect(answer == 0);
}

test "happy_ordering_many_row" {
    const input = "47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13".*;

    var splitInput = std.mem.split(u8, &input, "\n");

    var i = std.ArrayList([]const u8).init(std.testing.allocator);
    defer i.deinit();

    while (splitInput.next()) |token| {
        try i.append(token);
    }

    // const po = orderer.PageOrderer();

    const slice: [][]const u8 = try i.toOwnedSlice();
    const o = try PageOrderer.init(std.testing.allocator, slice);
    defer o.deinit();

    const data = "75,47,61,53,29\n97,61,53,29,13\n75,29,13\n75,97,47,61,53\n61,13,29\n97,13,75,29,47";
    var splitData = std.mem.split(u8, data, "\n");

    var d = std.ArrayList([]const u8).init(std.testing.allocator);
    defer d.deinit();

    while (splitData.next()) |token| {
        try d.append(token);
    }

    const s = try d.toOwnedSlice();
    const answer = try o.solve(s, false);
    std.testing.allocator.free(s);
    std.testing.allocator.free(slice);

    try expect(answer == 143);
}

test "happy_fix_ordering_many_row" {
    const input = "47|53\n97|13\n97|61\n97|47\n75|29\n61|13\n75|53\n29|13\n97|29\n53|29\n61|53\n97|53\n61|29\n47|13\n75|47\n97|75\n47|61\n75|61\n47|29\n75|13\n53|13".*;

    var splitInput = std.mem.split(u8, &input, "\n");

    var i = std.ArrayList([]const u8).init(std.testing.allocator);
    defer i.deinit();

    while (splitInput.next()) |token| {
        try i.append(token);
    }

    // const po = orderer.PageOrderer();

    const slice: [][]const u8 = try i.toOwnedSlice();
    const o = try PageOrderer.init(std.testing.allocator, slice);
    defer o.deinit();

    const data = "75,47,61,53,29\n97,61,53,29,13\n75,29,13\n75,97,47,61,53\n61,13,29\n97,13,75,29,47";
    var splitData = std.mem.split(u8, data, "\n");

    var d = std.ArrayList([]const u8).init(std.testing.allocator);
    defer d.deinit();

    while (splitData.next()) |token| {
        try d.append(token);
    }

    const s = try d.toOwnedSlice();
    const answer = try o.solve(s, true);
    std.testing.allocator.free(s);
    std.testing.allocator.free(slice);

    try expect(answer == 123);
}
