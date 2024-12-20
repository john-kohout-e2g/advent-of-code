const std = @import("std");
const pkg = @import("puzzle_lists.zig");

const expect = std.testing.expect;
const left = [_]i32{ 3, 4, 2, 1, 3, 3 };
const right = [_]i32{ 4, 3, 5, 3, 9, 3 };

test "happy_puzzle_lists_calculate_total" {
    var localLeft = left;
    var localRight = right;

    var pl = pkg.PuzzleLists{
        .left = &localLeft,
        .right = &localRight,
    };

    const total = try pl.calculateTotal();
    try expect(total == 11);
}

test "happy_puzzle_lists_calculate_similarity_score" {
    var localLeft = left;
    var localRight = right;

    var pl = pkg.PuzzleLists{
        .left = &localLeft,
        .right = &localRight,
    };

    const similarity_score = try pl.calculateSimilarityScore();
    try expect(similarity_score == 31);
}

test "happy_puzzle_lists_calculate_similarity_score_right_smaller_than_left" {
    var l = [_]i32{ 3, 4, 2, 3, 3, 17, 18 };

    var r = [_]i32{ 1, 4, 3, 5, 3, 9, 3 };

    var pl = pkg.PuzzleLists{
        .left = &l,
        .right = &r,
    };

    const similarity_score = try pl.calculateSimilarityScore();
    try expect(similarity_score == 31);
}
