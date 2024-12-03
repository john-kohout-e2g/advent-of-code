const std = @import("std");

const Direction = enum { increasing, descreasing };
pub const ReactorReport = struct {
    report: []i32,

    fn levelsSafe(_: ReactorReport, left: i32, right: i32, direction: Direction) bool {
        const diff = switch (direction) {
            Direction.increasing => right - left,
            Direction.descreasing => left - right,
        };

        return diff > 0 and diff < 4;
    }

    pub fn isSafe(self: ReactorReport) bool {
        const diff = self.report[1] - self.report[0];
        if (diff == 0) {
            return false;
        }

        const direction = if (diff > 0) Direction.increasing else Direction.descreasing;

        for (self.report[0 .. self.report.len - 1], 1..) |left, i| {
            const right = self.report[i];
            if (!self.levelsSafe(left, right, direction)) {
                return false;
            }
        }
        return true;
    }
};
