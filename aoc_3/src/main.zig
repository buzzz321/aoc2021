const std = @import("std");
const ArrayList = std.ArrayList;

const sensor_data =
    \\00100
    \\11110
    \\10110
    \\10111
    \\10101
    \\01111
    \\00111
    \\11100
    \\10000
    \\11001
    \\00010
    \\01010
;

//fn convertSensorData

pub fn main() anyerror!void {
    var start: u64 = 0;
    var width: u64 = 0;
    var tmp: u64 = 0;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;
    var list = ArrayList(u64).init(allocator);

    for (sensor_data) |char, index| {
        if (char == '\n') {
            width = index - start;
            //std.debug.print("-> {s} w = {d}\n", .{ sensor_data[start..index], width });
            tmp = try std.fmt.parseInt(u64, std.mem.trimRight(u8, sensor_data[start..index], "\n"), 2);
            try list.append(tmp);
            start = index + 1;
        }
    }
    //std.debug.print("-> {s}\n", .{sensor_data[start..]});
    std.debug.print("-> {d}\n", .{list.items[0]});
    tmp = try std.fmt.parseInt(u64, std.mem.trimRight(u8, sensor_data[start..], "\n"), 2);
    try list.append(tmp);

    var index: u64 = 0;
    var sensor_bit: u64 = 0;
    while (index <= width) {
        //for (list.items) |item| {
        {
            var item: u64 = list.items[0];
            //std.debug.print("+> {d}\n", .{width - index});
            sensor_bit = item & (@as(u64, 2) << @intCast(u6, (width - index)));
            if (sensor_bit > 0) {
                std.debug.print("=> {d}\n", .{1});
            } else {
                std.debug.print("=> {d}\n", .{0});
            }
            //std.debug.print("=> {d:0>5}\n", .{item});
        }
        index += 1;
    }

    //std.log.info("All your codebase are belong to us.", .{});
}
