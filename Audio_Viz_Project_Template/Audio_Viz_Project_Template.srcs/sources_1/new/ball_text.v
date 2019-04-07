`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2019 04:31:56
// Design Name: 
// Module Name: ball_text
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


module ball_text(
    input CLK_VGA,
    
    output [14:0] VGA_ball_text,
    
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD
    );
    
    wire text_box_condition = (VGA_HORZ_COORD > 5 && VGA_HORZ_COORD < 380) && (VGA_VERT_COORD > 5 && VGA_VERT_COORD < 55);
    wire text_box_outline_condition = (VGA_HORZ_COORD == 5 && (VGA_VERT_COORD >= 5 && VGA_VERT_COORD <= 55)) ||
        (VGA_HORZ_COORD == 380 && (VGA_VERT_COORD >= 5 && VGA_VERT_COORD <= 55)) ||
        (VGA_VERT_COORD == 5 && (VGA_HORZ_COORD >= 5 && VGA_HORZ_COORD <= 380)) ||
        (VGA_VERT_COORD == 55 && (VGA_HORZ_COORD >= 5 && VGA_HORZ_COORD <= 380));
    
    wire text_condition;
    Pixel_On_text2 #(.displayText("Press middle button to reset/randomize balls")) open_option (
        CLK_VGA,
        15, // text position.x (top left)
        15, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        text_condition  // result, 1 if current pixel is on text, 0 otherwise
    );
    
    assign VGA_ball_text[4:0] = text_condition ? {1'b1, 4'hF}
        : text_box_condition ? {1'b1, 4'h0}
        : text_box_outline_condition ? {1'b1, 4'hf}
        : {1'b0, 4'h0};
        
    assign VGA_ball_text[9:5] = text_condition ? {1'b1, 4'hF}
        : text_box_condition ? {1'b1, 4'h0}
        : text_box_outline_condition ? {1'b1, 4'hf}
        : {1'b0, 4'h0};
                
    assign VGA_ball_text[14:10] = text_condition ? {1'b1, 4'hF}
        : text_box_condition ? {1'b1, 4'h0}
        : text_box_outline_condition ? {1'b1, 4'hf}
        : {1'b0, 4'h0};
endmodule
