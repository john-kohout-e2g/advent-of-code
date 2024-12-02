const std = @import("std");

pub const Error = error{MismatchedLengths};
pub const PuzzleLists = struct {
    left: []i32,
    right: []i32,
    pub fn sortAndCalculate(self: *PuzzleLists) !u32 {
        if (self.right.len != self.left.len) {
            return Error.MismatchedLengths;
        }

        std.mem.sort(i32, self.left, {}, comptime std.sort.asc(i32));
        std.mem.sort(i32, self.right, {}, comptime std.sort.asc(i32));

        var total: u32 = 0;
        for (self.right, 0..) |value, index| {
            total += @abs(value - self.left[index]);
        }

        return total;
    }
};
