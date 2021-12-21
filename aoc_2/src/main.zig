const std = @import("std");

const submarine_cmds =
    \\forward 5
    \\down 5
    \\forward 8
    \\up 3
    \\down 8
    \\forward 2
;

fn calcProgress(cmds: []const u8) [2]u64 {
    var start: u64 = 0;
    var space_pos: u64 = 0;
    var x: u64 = 0;
    var z: u64 = 0;
    for (cmds) |_, index| {
        if (cmds[index] == ' ' or cmds[index] == '\t') {
            space_pos = index;
        }
        if (cmds[index] == '\n' or index == cmds.len - 1) {
            var amount = std.fmt.parseInt(u64, std.mem.trimRight(u8, cmds[space_pos + 1 .. index + 1], "\n"), 0) catch 0;
            std.debug.print("line = {s} command = [{s}] amout = {d}\n", .{ cmds[start..index], cmds[start..space_pos], amount });

            if (std.mem.eql(u8, cmds[start..space_pos], "forward")) {
                x += amount;
            } else if (std.mem.eql(u8, cmds[start..space_pos], "down")) {
                z += amount;
            } else if (std.mem.eql(u8, cmds[start..space_pos], "up")) {
                z -= amount;
            }
            start = index + 1;
        }
    }
    return [2]u64{ x, z };
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const file = std.fs.cwd().openFile(
        "day2.input",
        .{ .read = true },
    ) catch |err| {
        std.log.err("File error {s}\n", .{err});
        return;
    };
    defer file.close();

    const stat = try file.stat();
    std.log.info("-> {s}", .{stat});
    var cmd_buffer = try allocator.alloc(u8, stat.size);
    const bytes_read = try file.readAll(cmd_buffer);
    std.debug.print("Just read {d}±n", .{bytes_read});

    const values = calcProgress(cmd_buffer);
    std.log.info("x={d} z={d} x*z={d}\n", .{ values[0], values[1], values[0] * values[1] });
}
