`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2019 05:03:24
// Design Name: 
// Module Name: draw_game_background
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


module draw_game_background(
    input CLK_VGA,
    
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    output [3:0] VGA_game_red_back,
    output [3:0] VGA_game_green_back,
    output [3:0] VGA_game_blue_back
    );
    
    wire text_condition;
    Pixel_On_text2 #(.displayText("HP")) record_ins (
        CLK_VGA,
        1000, // text position.x (top left)
        15, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        text_condition  // result, 1 if current pixel is on text, 0 otherwise
    );
    
    wire inner_bar_condition = (VGA_HORZ_COORD > 1050 && VGA_HORZ_COORD < 1200) && 
        (VGA_VERT_COORD > 15 && VGA_VERT_COORD < 30);
    wire outer_bar_condition = (VGA_HORZ_COORD == 1050 && (VGA_VERT_COORD >= 15 && VGA_VERT_COORD <= 30)) ||
        (VGA_HORZ_COORD == 1200 && (VGA_VERT_COORD >= 15 && VGA_VERT_COORD <= 30)) ||
        (VGA_VERT_COORD == 15 && (VGA_HORZ_COORD >= 1050 && VGA_HORZ_COORD <= 1200)) ||
        (VGA_VERT_COORD == 30 && (VGA_HORZ_COORD >= 1050 && VGA_HORZ_COORD <= 1200));
        
    
    assign VGA_game_red_back = text_condition ? 4'hF : (inner_bar_condition ? 4'h0 : (outer_bar_condition ? 4'hF : 0));
    assign VGA_game_green_back = text_condition ? 4'hF : (inner_bar_condition ? 4'hF : (outer_bar_condition ? 4'hF : 0));
    assign VGA_game_blue_back = text_condition ? 4'hF : (inner_bar_condition ? 4'h0 : (outer_bar_condition ? 4'hF : 0));
endmodule
