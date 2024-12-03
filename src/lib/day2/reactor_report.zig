const std = @import("std");

const Direction = enum { increasing, descreasing };
pub const ReactorReport = struct {
    report: []i32,
    problemDampener: ?usize = null,

    fn reportAt(self: ReactorReport, index: usize) i32 {
        if (self.problemDampener != null and index >= self.problemDampener.?) {
            return self.report[index + 1];
        }
        return self.report[index];
    }

    fn reportLen(self: ReactorReport) usize {
        if (self.problemDampener == null) {
            return self.report.len;
        }

        return self.report.len - 1;
    }

    fn levelsSafe(_: ReactorReport, left: i32, right: i32, direction: Direction) bool {
        const diff = switch (direction) {
            Direction.increasing => right - left,
            Direction.descreasing => left - right,
        };

        return diff > 0 and diff < 4;
    }

    pub fn isSafeDampened(self: *ReactorReport, dampener: usize) bool {
        self.problemDampener = dampener;
        const safe = self.isSafe();
        self.problemDampener = null;
        return safe;
    }

    pub fn isSafe(self: ReactorReport) bool {
        const diff = self.reportAt(1) - self.reportAt(0);
        if (diff == 0) {
            return false;
        }

        const direction = if (diff > 0) Direction.increasing else Direction.descreasing;

        for (0..self.reportLen() - 1, 1..) |i, j| {
            const left = self.reportAt(i);
            const right = self.reportAt(j);
            if (!self.levelsSafe(left, right, direction)) {
                return false;
            }
        }
        return true;
    }
};
