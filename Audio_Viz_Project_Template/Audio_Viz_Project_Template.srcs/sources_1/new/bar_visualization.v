`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2019 07:59:40
// Design Name: 
// Module Name: bar_visualization
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


module bar_visualization(
    input clk_sample,
    input pause_switch,
    
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    input [11:0] nc_sound_sample,
    
    output [3:0] VGA_red_visualize,
    output [3:0] VGA_green_visualize,
    output [3:0] VGA_blue_visualize
    );
    
    
    reg [9:0] Sample_Memory[1279:0];
    reg [10:0] i = 0;
    
    always @ (posedge clk_sample) begin
        if (pause_switch == 0) begin
            i <= (i == 1279) ? 0 : i + 1;
            Sample_Memory[i] <= nc_sound_sample [11:2];
        end
    end
    
    wire bar_column_condition = (VGA_HORZ_COORD %31 <= 15 && VGA_HORZ_COORD < 1280 && (VGA_VERT_COORD >= (1300 - Sample_Memory[VGA_HORZ_COORD])));
    
    assign VGA_red_visualize = bar_column_condition ? 4'h0 : 0;
    assign VGA_green_visualize = bar_column_condition ? 4'hF : 0;
    assign VGA_blue_visualize = bar_column_condition ? 4'h0 : 0;
endmodule
