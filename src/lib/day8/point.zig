const std = @import("std");

pub const Direction = enum { up, down, left, right };
pub const Point = struct {
    x: i16,
    y: i16,

    pub fn encode(self: *Point) u32 {
        const x: u32 = @intCast(self.x);
        const y: u32 = @intCast(self.y);
        return (@as(u32, x) << 16 | @as(u32, y));
    }
};

pub fn new(x: i16, y: i16) Point {
    return Point{ .x = x, .y = y };
}

pub fn decode(value: i32) Point {
    const x: u16 = @intCast(value >> 16);
    const y: u16 = @intCast(value & 0xFFFF);
    return Point{ .x = @intCast(x), .y = @intCast(y) };
}

pub fn encode2(x: i16, y: i16) u32 {
    const x2: u32 = @intCast(x);
    const y2: u32 = @intCast(y);
    return (@as(u32, x2) << 16 | @as(u32, y2));
}
