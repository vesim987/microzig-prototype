const std = @import("std");
const MicroZig = @import("microzig");

pub const board = .{
    .name = "rp2040",
};

pub fn build(b: *std.Build) void {
    const microzig = MicroZig.Sdk.init_module(b);
    microzig.register_board(board);
}
