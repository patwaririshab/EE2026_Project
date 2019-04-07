`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2019 03:16:10
// Design Name: 
// Module Name: draw_text
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


module draw_freq_text(
    input CLK_VGA,
    
    output [14:0] VGA_freq_text,
    
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD
    );
    
    wire [1:0] freq_instructions;
    //wire [1:0] display_freq;
    
    wire dialog_box_condition = (VGA_HORZ_COORD > 5 && VGA_HORZ_COORD < 380) && (VGA_VERT_COORD > 5 && VGA_VERT_COORD < 55);
    wire dialog_box_edge_condition = (VGA_HORZ_COORD == 5 && (VGA_VERT_COORD >= 5 && VGA_VERT_COORD <= 55)) ||
        (VGA_HORZ_COORD == 380 && (VGA_VERT_COORD >= 5 && VGA_VERT_COORD <= 55)) ||
        (VGA_VERT_COORD == 5 && (VGA_HORZ_COORD >= 5 && VGA_HORZ_COORD <= 380)) ||
        (VGA_VERT_COORD == 55 && (VGA_HORZ_COORD >= 5 && VGA_HORZ_COORD <= 380));
    
    Pixel_On_text2 #(.displayText("Use sw12 to display calculated frequency on 7seg")) ins (
        CLK_VGA,
        15, // text position.x (top left)
        15, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        freq_instructions[0]  // result, 1 if current pixel is on text, 0 otherwise
    );
    
    Pixel_On_text2 #(.displayText("This module can accurately measure between 400Hz to 10kHz")) ins2 (
        CLK_VGA,
        15, // text position.x (top left)
        35, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        freq_instructions[1]  // result, 1 if current pixel is on text, 0 otherwise
    );
       
    //Pixel_On_text2 #(.displayText("The measured frequency is: ")) result1 (
    //    CLK_VGA,
    //    15, // text position.x (top left)
    //    35, // text position.y (top left)
    //    VGA_HORZ_COORD, // current position.x
    //    VGA_VERT_COORD, // current position.y
    //    display_freq[0]  // result, 1 if current pixel is on text, 0 otherwise
    //);                              
                                                
    assign VGA_freq_text[4:0] = |freq_instructions[1:0] ? {1'b1, 4'hf}
        : dialog_box_condition ? {1'b1, 4'h0}
        : dialog_box_edge_condition ? {1'b1, 4'hf}
        : {1'b0, 4'h0};
    assign VGA_freq_text[9:5] = |freq_instructions[1:0] ? {1'b1, 4'hf}
        : dialog_box_condition ? {1'b1, 4'h0}
        : dialog_box_edge_condition ? {1'b1, 4'hf}
        : {1'b0, 4'h0};
    assign VGA_freq_text[14:10] = |freq_instructions[1:0] ? {1'b1, 4'hf}
        : dialog_box_condition ? {1'b1, 4'h0}
        : dialog_box_edge_condition ? {1'b1, 4'hf}
        : {1'b0, 4'h0};
endmodule
