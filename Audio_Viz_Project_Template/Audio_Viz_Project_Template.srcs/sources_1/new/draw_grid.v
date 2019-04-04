`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2019 17:44:17
// Design Name: 
// Module Name: draw_grid
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


module draw_grid(
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    output [14:0] VGA_mode_one_grid,
    
    input axes_switch,
    input grid_switch,
    
    input [11:0] cur_theme_axes,
    input [11:0] cur_theme_grid,
    input [11:0] cur_theme_background
    );
    
    wire condition_for_axes = axes_switch ? VGA_HORZ_COORD == 640 || VGA_VERT_COORD == 512 : 0;
    wire condition_for_grid = grid_switch ? VGA_HORZ_COORD % 80 == 0 || VGA_VERT_COORD % 64 == 0 : 0;
    
    assign VGA_mode_one_grid[4:0] = condition_for_axes ? {1'b1, cur_theme_axes[3:0]}
        : condition_for_grid ? {1'b1, cur_theme_grid[3:0]}
        : {1'b0, cur_theme_background[3:0]};
        
    assign VGA_mode_one_grid[9:5] = condition_for_axes ? {1'b1, cur_theme_axes[7:4]}
        : condition_for_grid ? {1'b1, cur_theme_grid[7:4]}
        : {1'b0, cur_theme_background[7:4]};
        
    assign VGA_mode_one_grid[14:10] = condition_for_axes ? {1'b1, cur_theme_axes[11:8]}
        : condition_for_grid ? {1'b1, cur_theme_grid[11:8]}
        : {1'b0, cur_theme_background[11:8]};
        
    
    
endmodule
