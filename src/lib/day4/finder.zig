const std = @import("std");
const Allocator = std.mem.Allocator;

const Direction = enum(u8) { N = 0, NE, E, SE, S, SW, W, NW };

const Error = error{Undefined};
pub fn XmasPuzzleSolver() type {
    return struct {
        allocator: Allocator,
        puzzle: [][]const u8,

        pub const Solver = @This();

        pub fn init(allocator: Allocator, puzzle: []u8) !*Solver {
            const solver = try allocator.create(Solver);

            var lines = std.ArrayList([]const u8).init(allocator);
            defer lines.deinit();

            var lineTokens = std.mem.tokenize(u8, puzzle, "\t\n\r");
            while (lineTokens.next()) |lineToken| {
                try lines.append(lineToken);
            }

            solver.* = .{ .allocator = allocator, .puzzle = try lines.toOwnedSlice() };
            return solver;
        }

        pub fn deinit(self: *Solver) void {
            self.allocator.free(self.puzzle);
            self.allocator.destroy(self);
        }

        fn spellsXmas(self: *Solver, row: usize, column: usize, letter: u8, direction: Direction) !bool {
            if (letter == 'S') {
                return true;
            }

            const nextLetter: u8 = switch (letter) {
                'X' => 'M',
                'M' => 'A',
                'A' => 'S',
                else => 'Z',
            };

            const northy = direction == Direction.N or direction == Direction.NE or direction == Direction.NW;
            const southy = direction == Direction.S or direction == Direction.SE or direction == Direction.SW;
            const westy = direction == Direction.NW or direction == Direction.W or direction == Direction.SW;
            const easty = direction == Direction.NE or direction == Direction.E or direction == Direction.SE;

            if (row == 0 and northy) {
                return false;
            }

            if (row == self.puzzle.len - 1 and southy) {
                return false;
            }

            if (column == 0 and westy) {
                return false;
            }

            if (column == self.puzzle[0].len - 1 and easty) {
                return false;
            }

            var nextColumn = column;
            var nextRow = row;
            if (northy) {
                nextRow = nextRow - 1;
            }

            if (southy) {
                nextRow = nextRow + 1;
            }

            if (westy) {
                nextColumn = nextColumn - 1;
            }

            if (easty) {
                nextColumn = nextColumn + 1;
            }

            if (self.puzzle[nextRow][nextColumn] == nextLetter) {
                return try self.spellsXmas(nextRow, nextColumn, nextLetter, direction);
            }

            return false;
        }

        fn letterIsDiagonal(self: *Solver, row: usize, column: usize, letter: u8, direction: Direction) bool {
            const northy = direction == Direction.N or direction == Direction.NE or direction == Direction.NW;
            const southy = direction == Direction.S or direction == Direction.SE or direction == Direction.SW;
            const westy = direction == Direction.NW or direction == Direction.W or direction == Direction.SW;
            const easty = direction == Direction.NE or direction == Direction.E or direction == Direction.SE;

            if (row == 0) {
                return false;
            }

            if (row == self.puzzle.len - 1) {
                return false;
            }

            if (column == 0) {
                return false;
            }

            if (column == self.puzzle[0].len - 1) {
                return false;
            }

            var nextColumn = column;
            var nextRow = row;
            if (northy) {
                nextRow = nextRow - 1;
            }

            if (southy) {
                nextRow = nextRow + 1;
            }

            if (westy) {
                nextColumn = nextColumn - 1;
            }

            if (easty) {
                nextColumn = nextColumn + 1;
            }

            return self.puzzle[nextRow][nextColumn] == letter;
        }

        pub fn solveForXmas(self: *Solver) !u32 {
            var total: u32 = 0;

            const directions = [_]Direction{ Direction.N, Direction.NE, Direction.E, Direction.SE, Direction.S, Direction.SW, Direction.W, Direction.NW };
            for (self.puzzle, 0..) |line, row| {
                for (line, 0..) |letter, column| {
                    if (letter == 'X') {
                        for (directions) |direction| {
                            if (try self.spellsXmas(row, column, 'X', direction)) {
                                total += 1;
                            }
                        }
                    }
                }
            }
            return total;
        }

        fn letterDirections(self: *Solver, row: usize, column: usize, letter: u8, directions: []const Direction) usize {
            var total: usize = 0;
            for (directions) |direction| {
                if (self.letterIsDiagonal(row, column, letter, direction)) {
                    switch (direction) {
                        Direction.NW => total += 10,
                        Direction.NE => total += 1,
                        Direction.SW => total += 100,
                        Direction.SE => total += 1000,
                        else => total += 0,
                    }
                }
            }

            return total;
        }

        fn hasMas(self: *Solver, row: usize, column: usize) bool {
            if (row == 0) {
                return false;
            }

            if (row == self.puzzle.len - 1) {
                return false;
            }

            if (column == 0) {
                return false;
            }

            if (column == self.puzzle[0].len - 1) {
                return false;
            }

            const sNE = self.puzzle[row + 1][column + 1] == 'S';
            const sNW = self.puzzle[row + 1][column - 1] == 'S';
            const sSE = self.puzzle[row - 1][column + 1] == 'S';
            const sSW = self.puzzle[row - 1][column - 1] == 'S';

            const mNE = self.puzzle[row + 1][column + 1] == 'M';
            const mNW = self.puzzle[row + 1][column - 1] == 'M';
            const mSE = self.puzzle[row - 1][column + 1] == 'M';
            const mSW = self.puzzle[row - 1][column - 1] == 'M';

            if (!sNE and !mNE) {
                return false;
            }

            // MM
            // SS
            if (mNE and mNW and sSE and sSW) {
                return true;
            }

            // MS
            // MS
            if (mNW and mSW and sNE and sSE) {
                return true;
            }

            // SS
            // MM
            if (sNE and sNW and mSE and mSW) {
                return true;
            }

            // SM
            // SM
            if (sNW and sSW and mNE and mSE) {
                return true;
            }

            return false;
        }

        pub fn solveForCrossMas(self: *Solver) !u32 {
            var total: u32 = 0;
            // const directions = [_]Direction{ Direction.NE, Direction.SE, Direction.SW, Direction.NW };
            // const directions = [_]Direction{ Direction.N, Direction.NE, Direction.E, Direction.SE, Direction.S, Direction.SW, Direction.W, Direction.NW };
            for (self.puzzle, 0..) |line, row| {
                for (line, 0..) |letter, column| {
                    if (letter == 'A') {
                        if (self.hasMas(row, column)) {
                            total += 1;
                        }
                    }
                }
            }
            return total;
        }
    };
}
