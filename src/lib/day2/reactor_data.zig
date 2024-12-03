const pkg = @import("reactor_report.zig");

pub const ReactorData = struct {
    reports: []pkg.ReactorReport,
    pub fn isSafe(self: ReactorData) u32 {
        var total: u32 = 0;
        for (self.reports) |report| {
            if (report.isSafe()) {
                total += 1;
            }
        }
        return total;
    }
};
