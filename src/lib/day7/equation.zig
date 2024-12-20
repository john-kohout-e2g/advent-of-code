const std = @import("std");

const Allocator = std.mem.Allocator;

pub const Operation = enum { add, multiply, concatenate };

pub fn Eq() type {
    return struct {
        allocator: Allocator,
        expect: u64,
        terms: []u64,

        pub const Equation = @This();

        pub fn init(allocator: Allocator, rawEquation: []const u8) !*Equation {
            const e = try allocator.create(Equation);
            var expect: u64 = 0;

            var terms = std.ArrayList(u64).init(allocator);
            defer terms.deinit();

            var splitEquation = std.mem.split(u8, rawEquation, ":");
            if (splitEquation.next()) |first| {
                if (first.len != 0) {
                    expect = try std.fmt.parseInt(u64, first, 10);
                }
            }

            if (splitEquation.next()) |second| {
                var splitTerms = std.mem.split(u8, second, " ");
                while (splitTerms.next()) |term| {
                    if (term.len == 0) {
                        continue;
                    }
                    try terms.append(try std.fmt.parseInt(u64, term, 10));
                }
            }

            const t = try terms.toOwnedSlice();

            e.* = .{ .allocator = allocator, .expect = expect, .terms = t };
            return e;
        }

        pub fn deinit(self: *Equation) void {
            self.allocator.free(self.terms);
            self.allocator.destroy(self);
        }

        pub fn solve(self: *Equation) !u64 {
            if (self.terms.len == 0) {
                return 0;
            }
            const length: u64 = self.terms.len - 1;
            var combinations = try generateCombinations(self.allocator, length);
            defer deinitCombinations(self.allocator, &combinations);

            for (combinations.items) |combination| {
                var calc: u64 = self.terms[0];
                for (combination, 0..) |operation, i| {
                    if (i + 1 > self.terms.len) continue;
                    if (calc > self.expect) break;
                    calc = operate(calc, self.terms[i + 1], operation);
                }
                if (self.expect == calc) {
                    return calc;
                }
            }

            return 0;
        }

        pub fn solve2(self: *Equation) !u64 {
            if (self.terms.len == 0) {
                return 0;
            }
            const length: u64 = self.terms.len - 1;
            var combinations = try generateCombinations2(self.allocator, length);
            defer deinitCombinations(self.allocator, &combinations);

            for (combinations.items) |combination| {
                var calc: u64 = self.terms[0];
                for (combination, 0..) |operation, i| {
                    if (i + 1 > self.terms.len) continue;
                    calc = operate(calc, self.terms[i + 1], operation);
                    if (calc > self.expect) break;
                }
                if (self.expect == calc) {
                    return calc;
                }
            }

            return 0;
        }

        fn operate(left: u64, right: u64, operation: Operation) u64 {
            switch (operation) {
                Operation.add => return left + right,
                Operation.multiply => return left * right,
                Operation.concatenate => {
                    const r: f64 = @floatFromInt(right);
                    const right_digits = std.math.ceil(std.math.log10(r));
                    if (right_digits > std.math.maxInt(u64)) {
                        std.debug.print("oh thats a big boy", .{});
                        return std.math.maxInt(u64);
                    }
                    const shift_amount: u64 = @intFromFloat(right_digits);
                    const multiplier = std.math.pow(u64, 10, shift_amount);
                    return left * multiplier + right;
                },
            }
        }

        fn deinitCombinations(allocator: Allocator, combinations: *std.ArrayList([]const Operation)) void {
            for (combinations.items) |ops| {
                allocator.free(ops);
            }
            combinations.deinit();
        }

        fn generateCombinations2(allocator: Allocator, n: u64) !std.ArrayList([]const Operation) {
            var combinations = std.ArrayList([]const Operation).init(allocator);

            const total_combinations = std.math.pow(u64, 3, n);

            for (0..total_combinations) |i| {
                var current = i;
                var ops = try allocator.alloc(Operation, n);

                for (0..n) |pos| {
                    const choice = current % 3;
                    current /= 3;

                    ops[pos] = switch (choice) {
                        0 => Operation.add,
                        1 => Operation.multiply,
                        2 => Operation.concatenate,
                        else => unreachable,
                    };
                }

                try combinations.append(ops);
            }
            std.mem.sort([]const Operation, combinations.items, {}, sort);
            return combinations;
        }

        fn sort(_: void, a: []const Operation, b: []const Operation) bool {
            const countA = countConcatenates(a);
            const countB = countConcatenates(b);
            return countA > countB;
        }

        fn countConcatenates(ops: []const Operation) u32 {
            var count: u32 = 0;
            for (ops) |op| {
                if (op == Operation.concatenate) count += 1;
            }
            return count;
        }

        fn generateCombinations(allocator: Allocator, n: u64) !std.ArrayList([]const Operation) {
            var combinations = std.ArrayList([]const Operation).init(allocator);

            const total_combinations = @as(u64, 1) << @intCast(n);

            for (0..total_combinations) |i| {
                var ops = try allocator.alloc(Operation, n);

                for (0..n) |bit| {
                    ops[bit] = if ((i & (@as(u64, 1) << @intCast(bit))) != 0)
                        Operation.multiply
                    else
                        Operation.add;
                }

                try combinations.append(ops);
            }

            return combinations;
        }
    };
}
