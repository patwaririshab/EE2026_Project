`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2019 17:17:13
// Design Name: 
// Module Name: draw_tick
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module draw_tick(
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    output [14:0] VGA_mode_one_tick,
    
    input tick_switch,
    
    input [11:0] cur_theme_tick,
    input [11:0] cur_theme_background
    );
    
    wire condition_for_ticks = tick_switch ? (VGA_HORZ_COORD % 10 == 0 && VGA_VERT_COORD < 518 && VGA_VERT_COORD > 506) ||
        (VGA_VERT_COORD % 8 == 0 && VGA_HORZ_COORD < 646 && VGA_HORZ_COORD > 634) : 0;
        
    assign VGA_mode_one_tick[4:0] = condition_for_ticks ? {1'b1, cur_theme_tick[3:0]} : {1'b0, cur_theme_background[3:0]};
    assign VGA_mode_one_tick[9:5] = condition_for_ticks ? {1'b1, cur_theme_tick[7:4]} : {1'b0, cur_theme_background[7:4]};
    assign VGA_mode_one_tick[14:10] = condition_for_ticks ? {1'b1, cur_theme_tick[11:8]} : {1'b0, cur_theme_background[11:8]};
endmodule
