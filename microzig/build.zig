const std = @import("std");

const dependencies = @import("root").dependencies;

pub fn build(b: *std.Build) void {
    const sdk: *Sdk = @ptrFromInt(b.option(usize, "sdk_address", "").?);
    sdk.microzig_builder = b;

    inline for (dependencies.root_deps) |dep| {
        // const name = dep[0];
        const data = @field(@import("root").dependencies.packages, dep[1]);
        if (std.mem.startsWith(u8, dep[0], "microzig.")) {
            _ = sdk.root_builder.dependencyFromBuildZig(data.build_zig, .{ .sdk_address = @intFromPtr(sdk) });
        }
    }
}

pub const Sdk = struct {
    root_builder: *std.Build,
    microzig_builder: ?*std.Build = null,
    registered_boards: std.ArrayListUnmanaged(Board) = .{},

    pub fn init(builder: *std.Build) *Sdk {
        const sdk = builder.allocator.create(Sdk) catch unreachable;
        sdk.* = .{
            .root_builder = builder,
        };
        _ = builder.dependency("microzig", .{ .sdk_address = @intFromPtr(sdk) });
        return sdk;
    }

    pub fn init_module(builder: *std.Build) *Sdk {
        const sdk: *Sdk = @ptrFromInt(builder.option(usize, "sdk_address", "").?);
        return sdk;
    }

    pub fn register_board(self: *Sdk, board: Board) void {
        self.registered_boards.append(self.root_builder.allocator, board) catch unreachable;
    }
};

pub const Board = struct {
    name: []const u8,
};
