const std = @import("std");

const Error = error{InvalidStep};
pub const Direction = enum { up, down, left, right };
pub const Position = struct {
    x: u16,
    y: u16,
    last_x: u16 = 0,
    last_y: u16 = 0,
    direction: Direction = Direction.up,

    pub fn encode(self: *Position) u32 {
        return (@as(u32, self.x) << 16 | @as(u32, self.y));
    }

    pub fn step(self: *Position) !void {
        self.last_x = self.x;
        self.last_y = self.y;
        switch (self.direction) {
            Direction.down => self.y += 1,
            Direction.right => self.x += 1,
            Direction.up => {
                if (self.y == 0) {
                    return Error.InvalidStep;
                }
                self.y -= 1;
            },
            Direction.left => {
                if (self.x == 0) {
                    return Error.InvalidStep;
                }
                self.x -= 1;
            },
        }
    }

    pub fn revert(self: *Position) void {
        self.x = self.last_x;
        self.y = self.last_y;
    }
};

pub fn new(x: u16, y: u16) Position {
    return Position{ .x = x, .y = y, .last_x = x, .last_y = y };
}

pub fn decode(value: u32) Position {
    const x: u16 = @intCast(value >> 16);
    const y: u16 = @intCast(value & 0xFFFF);
    return Position{ .x = x, .y = y, .last_x = x, .last_y = y };
}
