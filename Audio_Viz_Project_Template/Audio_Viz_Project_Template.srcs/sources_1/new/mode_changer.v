`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2019 04:36:44
// Design Name: 
// Module Name: mode_changer
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


module mode_changer(
    input CLK_VGA,
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    input button_clock,
    input up_button_out,
    input down_button_out,
    
    output reg [1:0] mode = 0,
    output [14:0] VGA_mode_selector
    );
    
    always @ (posedge button_clock) begin
        if (up_button_out == 1 && down_button_out == 0) begin
            mode = mode + 1;
        end
        else if (down_button_out == 1 && up_button_out == 0) begin
            mode = mode - 1;
        end
    end
    
    wire mode_condition0;
    Pixel_On_text2 #(.displayText("Mode: Default Waveform")) mc0 (
        CLK_VGA,
        1100, // text position.x (top left)
        1000, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        mode_condition0  // result, 1 if current pixel is on text, 0 otherwise
    );
    wire mode_condition1;
    Pixel_On_text2 #(.displayText("Mode: Game")) mc1 (
        CLK_VGA,
        1100, // text position.x (top left)
        1000, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        mode_condition1  // result, 1 if current pixel is on text, 0 otherwise
    );
    wire mode_condition2;
    Pixel_On_text2 #(.displayText("Mode: Frequency Meas.")) mc2 (
        CLK_VGA,
        1100, // text position.x (top left)
        1000, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        mode_condition2  // result, 1 if current pixel is on text, 0 otherwise
    );
    wire mode_condition3;
    Pixel_On_text2 #(.displayText("Mode: Music Visualizer")) mc3 (
        CLK_VGA,
        1100, // text position.x (top left)
        1000, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        mode_condition3  // result, 1 if current pixel is on text, 0 otherwise
    );
    
    wire condition_for_mode_text = VGA_HORZ_COORD > 1090 && VGA_VERT_COORD > 990;
    wire condition_for_mode_outline = (VGA_HORZ_COORD == 1090 && VGA_VERT_COORD >= 990) ||
        (VGA_VERT_COORD == 990 && VGA_HORZ_COORD >= 1090);
    assign VGA_mode_selector[4:0] = 
        (mode == 0) ? 
            (mode_condition0 ? {1'b1, 4'hF} 
            : condition_for_mode_text ? {1'b1, 4'h0}
            : condition_for_mode_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0})
        : (mode == 1) ?
            (mode_condition1 ? {1'b1, 4'hF} 
            : condition_for_mode_text ? {1'b1, 4'h0}
            : condition_for_mode_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0})
        : (mode == 2) ?
            (mode_condition2 ? {1'b1, 4'hF} 
            : condition_for_mode_text ? {1'b1, 4'h0}
            : condition_for_mode_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0})
        : 
            (mode_condition3 ? {1'b1, 4'hF} 
            : condition_for_mode_text ? {1'b1, 4'h0}
            : condition_for_mode_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0});
            
    assign VGA_mode_selector[9:5] = 
        (mode == 0) ? 
            (mode_condition0 ? {1'b1, 4'hF} 
            : condition_for_mode_text ? {1'b1, 4'h0}
            : condition_for_mode_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0})
        : (mode == 1) ?
            (mode_condition1 ? {1'b1, 4'hF} 
            : condition_for_mode_text ? {1'b1, 4'h0}
            : condition_for_mode_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0})
        : (mode == 2) ?
            (mode_condition2 ? {1'b1, 4'hF} 
            : condition_for_mode_text ? {1'b1, 4'h0}
            : condition_for_mode_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0})
        : 
            (mode_condition3 ? {1'b1, 4'hF} 
            : condition_for_mode_text ? {1'b1, 4'h0}
            : condition_for_mode_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0});
            
    assign VGA_mode_selector[14:10] = 
        (mode == 0) ? 
            (mode_condition0 ? {1'b1, 4'hF} 
            : condition_for_mode_text ? {1'b1, 4'h0}
            : condition_for_mode_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0})
        : (mode == 1) ?
            (mode_condition1 ? {1'b1, 4'hF} 
            : condition_for_mode_text ? {1'b1, 4'h0}
            : condition_for_mode_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0})
        : (mode == 2) ?
            (mode_condition2 ? {1'b1, 4'hF} 
            : condition_for_mode_text ? {1'b1, 4'h0}
            : condition_for_mode_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0})
        : 
            (mode_condition3 ? {1'b1, 4'hF} 
            : condition_for_mode_text ? {1'b1, 4'h0}
            : condition_for_mode_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0});
endmodule
