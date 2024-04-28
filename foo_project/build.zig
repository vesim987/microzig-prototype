const std = @import("std");
const MicroZig = @import("microzig");
const rp2040 = @import("microzig.bsp.rp2040");
const dependencies = @import("root").dependencies;

pub fn build(b: *std.Build) void {
    const microzig = MicroZig.Sdk.init(b);
    std.debug.print("Available boards: \n", .{});
    for (microzig.registered_boards.items) |board| {
        std.debug.print("  {s}\n", .{board.name});
    }
}
