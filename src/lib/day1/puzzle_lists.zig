const std = @import("std");

pub const Error = error{MismatchedLengths};
pub const PuzzleLists = struct {
    left: []i32,
    right: []i32,
    sorted: bool = false,

    pub fn sort(self: *PuzzleLists) void {
        std.mem.sort(i32, self.left, {}, comptime std.sort.asc(i32));
        std.mem.sort(i32, self.right, {}, comptime std.sort.asc(i32));
        self.sorted = true;
    }

    pub fn calculateTotal(self: *PuzzleLists) !u32 {
        if (self.right.len != self.left.len) {
            return Error.MismatchedLengths;
        }

        if (!self.sorted) {
            self.sort();
        }

        var total: u32 = 0;
        for (self.left, 0..) |value, index| {
            total += @abs(value - self.right[index]);
        }

        return total;
    }
    pub fn calculateSimilarityScore(self: *PuzzleLists) !u32 {
        if (self.right.len != self.left.len) {
            return Error.MismatchedLengths;
        }

        if (!self.sorted) {
            self.sort();
        }

        return 0;
    }
};
