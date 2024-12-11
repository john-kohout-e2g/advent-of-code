const std = @import("std");
const Allocator = std.mem.Allocator;

const Error = error{ BadLength, InvalidRule };
pub fn PageOrderer() type {
    return struct {
        allocator: Allocator,
        rules: std.AutoHashMap(u32, []u32),

        pub const Orderer = @This();

        pub fn init(allocator: Allocator, rawRules: [][]const u8) !*Orderer {
            const orderer = try allocator.create(Orderer);
            var rules = std.AutoHashMap(u32, []u32).init(allocator);

            for (rawRules) |rule| {
                if (rule.len != 5) {
                    return Error.BadLength;
                }

                if (rule[2] != '|') {
                    return Error.InvalidRule;
                }

                const key = try std.fmt.parseInt(u32, rule[0..2], 10);

                const newValue = try std.fmt.parseInt(u32, rule[3..], 10);

                if (rules.get(key)) |values| {
                    var newValues = try allocator.alloc(u32, values.len + 1);

                    for (values, 0..) |value, i| {
                        newValues[i] = value;
                    }

                    newValues[newValues.len - 1] = newValue;
                    try rules.put(key, newValues);
                    allocator.free(values);
                } else {
                    var newValues = try allocator.alloc(u32, 1);
                    newValues[0] = newValue;
                    try rules.put(key, newValues);
                }
            }

            orderer.* = .{ .allocator = allocator, .rules = rules };
            return orderer;
        }

        pub fn deinit(self: *Orderer) void {
            var iterator = self.rules.iterator();
            while (iterator.next()) |entry| {
                const arr = entry.value_ptr.*;
                self.allocator.free(arr);
            }

            self.rules.deinit();
            self.allocator.destroy(self);
        }

        fn noFix(self: *Orderer, inputs: []const u32, _: usize, _: usize) u32 {
            _ = self;
            _ = inputs;
            return 0;
        }

        fn fixAndEvaluate(self: *Orderer, inputs: []const u32, before: usize, move: usize) u32 {
            var fixed_input = self.allocator.alloc(u32, inputs.len) catch |err| {
                std.debug.print("{any}", .{err});
                return 0;
            };
            const move_to = before;
            fixed_input[move_to] = inputs[move];

            var skipped_move = false;
            for (inputs, 0..) |input, index| {
                if (input == inputs[move]) {
                    skipped_move = true;
                    continue;
                }

                if (index < move_to) {
                    fixed_input[index] = input;
                } else if (skipped_move) {
                    fixed_input[index] = input;
                } else {
                    fixed_input[index + 1] = input;
                }
            }
            const answer = self.evaluate(fixed_input, Orderer.fixAndEvaluate);
            self.allocator.free(fixed_input);
            return answer;
        }

        pub fn solve(self: *Orderer, inputs: [][]const u8, fix_update: bool) !u32 {
            var total: u32 = 0;
            for (inputs) |input| {
                var splitData = std.mem.split(u8, input, ",");
                var d = std.ArrayList(u32).init(self.allocator);
                defer d.deinit();

                while (splitData.next()) |token| {
                    const value = try std.fmt.parseInt(u32, token, 10);
                    try d.append(value);
                }
                const i = try d.toOwnedSlice();
                if (fix_update) {
                    if (self.evaluate(i, Orderer.noFix) == 0) {
                        total += self.evaluate(i, Orderer.fixAndEvaluate);
                    }
                } else {
                    total += self.evaluate(i, Orderer.noFix);
                }
                self.allocator.free(i);
            }
            return total;
        }

        fn evaluate(self: *Orderer, values: []const u32, fixer: fn (self: *Orderer, values: []const u32, before: usize, move: usize) u32) u32 {
            for (values, 0..) |v, i| {
                if (self.rules.get(v)) |rules| {
                    ruleVal: for (rules) |rule| {
                        for (values, 0..) |value, j| {
                            if (value == rule) {
                                if (i > j) {
                                    return fixer(self, values, j, i);
                                } else {
                                    continue :ruleVal;
                                }
                            }
                        }
                    }
                }
            }
            const middle_index = values.len / 2;
            return values[middle_index];
        }
    };
}
