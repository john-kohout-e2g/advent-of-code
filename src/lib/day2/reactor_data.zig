const pkg = @import("reactor_report.zig");

pub const ReactorData = struct {
    reports: []pkg.ReactorReport,

    pub fn reportsSafe(self: ReactorData) u32 {
        var total: u32 = 0;
        for (self.reports) |report| {
            if (report.isSafe()) {
                total += 1;
            }
        }
        return total;
    }

    pub fn reportsSafeDampened(self: ReactorData) u32 {
        var total: u32 = 0;
        outer: for (self.reports) |*r| {
            if (r.isSafe()) {
                total += 1;
                continue;
            }

            for (0..r.report.len) |i| {
                if (r.isSafeDampened(i)) {
                    total += 1;
                    continue :outer;
                }
            }
        }
        return total;
    }
};
