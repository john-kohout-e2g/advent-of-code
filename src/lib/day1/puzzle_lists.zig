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

        if (self.left.len == 0) {
            return 0;
        }

        var total: u32 = 0;

        var count: i32 = 0;
        var prevLeftValue: i32 = 0;

        var rightIndex: u32 = 0;

        var prevRightValue: i32 = self.right[rightIndex];
        var rightValue = self.right[rightIndex];
        const firstLeftValue = self.left[0];

        while (rightValue < firstLeftValue) {
            rightIndex += 1;
            if (rightIndex == self.right.len) {
                return 0;
            }
            rightValue = self.right[rightIndex];
            prevRightValue = rightValue;
        }

        outer: for (self.left) |leftValue| {
            if (leftValue == prevLeftValue) {
                total += @intCast(leftValue * count);
                prevLeftValue = leftValue;
                continue;
            }
            if (leftValue < rightValue) {
                prevLeftValue = leftValue;
                continue;
            }

            if (leftValue > rightValue) {
                while (leftValue > rightValue) {
                    rightIndex += 1;
                    if (rightIndex == self.right.len) {
                        prevRightValue = 0;
                        break :outer;
                    }
                    rightValue = self.right[rightIndex];
                    prevRightValue = rightValue;
                }
                if (leftValue != rightValue) {
                    prevLeftValue = leftValue;
                    continue;
                }
            }

            count = 0;

            while (prevRightValue == rightValue) {
                count += 1;
                rightIndex += 1;
                prevRightValue = rightValue;
                if (rightIndex == self.right.len) {
                    prevRightValue = 0;
                    break;
                }
                rightValue = self.right[rightIndex];
            }

            prevRightValue = rightValue;
            total += @intCast(leftValue * count);
            prevLeftValue = leftValue;
        }
        return total;
    }
};
