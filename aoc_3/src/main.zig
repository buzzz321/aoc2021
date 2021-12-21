const std = @import("std");
const ArrayList = std.ArrayList;
const pow = std.math.pow;
//const sensor_data = @embedFile("../day3.input");

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
    const allocator = arena.allocator();
    var list = ArrayList(u64).init(allocator);

    //std.debug.print("sensor_data=\n{s}\n", .{sensor_data});
    for (sensor_data) |char, index| {
        if (char == '\n') {
            width = index - start - 1;
            //std.debug.print("-> {s} w = {d}\n", .{ sensor_data[start..index], width });
            tmp = try std.fmt.parseInt(u64, std.mem.trimRight(u8, sensor_data[start..index], "\n"), 2);
            try list.append(tmp);
            start = index + 1;
        }
    }
    //std.debug.print("-> {s}\n", .{sensor_data[start..]});
    std.debug.print("-> {d} 2^0 {d}\n", .{ list.items[0], @as(u64, 1) << @intCast(u6, 0) });
    tmp = try std.fmt.parseInt(u64, std.mem.trimRight(u8, sensor_data[start..], "\n"), 2);
    try list.append(tmp);

    var index: u64 = 0;
    var sensor_bit: u64 = 0;
    var one_cnt: i64 = 0;
    var gamma: u64 = 0;
    var myepsilon: u64 = 0;
    while (index <= width) {
        for (list.items) |item| {

            //std.debug.print("+> {d}\n", .{width - index});
            sensor_bit = item & (@as(u64, 1) << @intCast(u6, (width - index)));
            if (sensor_bit > 0) {
                //std.debug.print("=> {d}\n", .{1});
                one_cnt += 1;
            } else {
                //std.debug.print("=> {d}\n", .{0});
                one_cnt -= 1;
            }
            //std.debug.print("=> {d:0>5}\n", .{item});
        }
        if (one_cnt == 0) {
            std.debug.print("Equal number 1 and 0\n", .{});
        } else if (one_cnt > 0) {
            std.debug.print("Mostly ones\n", .{});
            gamma |= (@as(u64, 1) << @intCast(u6, (width - index)));
        } else {
            std.debug.print("Mostly zeros\n", .{});
            gamma |= (@as(u64, 0) << @intCast(u6, (width - index)));
        }
        index += 1;
        one_cnt = 0;
    }
    myepsilon = (~gamma) & (pow(u64, 2, width + 1) - 1);
    std.debug.print("gamma is {b:0>5} epsilon={b:0>5} power={d}\n", .{ gamma, myepsilon, gamma * myepsilon });
}
