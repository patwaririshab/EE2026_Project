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


module draw_text(
    input CLK_VGA,
    input button_clock,
    
    output [3:0] VGA_red_text,
    output [3:0] VGA_green_text,
    output [3:0] VGA_blue_text,
    
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    input middle_button_out,
    input [11:0] cur_theme_wave,
    input [11:0] cur_theme_background,
    
    input [1:0] mode
    );
    
    wire open_option_condition;
    wire [7:0] option_condition;
    wire final_condition;
    reg options_toggle = 0;
    always @ (posedge button_clock) begin
        if (mode == 0) begin
            if (middle_button_out == 1) begin
                options_toggle = options_toggle + 1;
            end
        end
    end
    
    assign final_condition = (options_toggle == 0) ? open_option_condition : |option_condition[7:0];
        //option_condition[0] || option_condition[1] || option_condition[2] || option_condition[3] ||
        //option_condition[4] || option_condition[5] || option_condition[6]; 
    
    Pixel_On_text2 #(.displayText("Press middle button to open options")) open_option (
        CLK_VGA,
        15, // text position.x (top left)
        15, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        open_option_condition  // result, 1 if current pixel is on text, 0 otherwise
    );
       
    Pixel_On_text2 #(.displayText("Press middle button to close options")) options (
        CLK_VGA,
        15, // text position.x (top left)
        15, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        option_condition[0]  // result, 1 if current pixel is on text, 0 otherwise
    );
    Pixel_On_text2 #(.displayText("- sw0 toggles waveform")) sw0 (
        CLK_VGA,
        15, // text position.x (top left)
        30, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        option_condition[1]  // result, 1 if current pixel is on text, 0 otherwise
    );
    Pixel_On_text2 #(.displayText("- sw1 toggles grid")) sw1 (
        CLK_VGA,
        15, // text position.x (top left)
        45, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        option_condition[2]  // result, 1 if current pixel is on text, 0 otherwise
    );
    Pixel_On_text2 #(.displayText("- sw2 toggles axes")) sw2 (
        CLK_VGA,
        15, // text position.x (top left)
        60, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        option_condition[3]  // result, 1 if current pixel is on text, 0 otherwise
    );
    Pixel_On_text2 #(.displayText("- sw3 toggles ticks")) sw3 (
        CLK_VGA,
        15, // text position.x (top left)
        75, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        option_condition[4]  // result, 1 if current pixel is on text, 0 otherwise
    );
    Pixel_On_text2 #(.displayText("- sw14 pauses mic recording")) sw14 (
        CLK_VGA,
        15, // text position.x (top left)
        90, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        option_condition[5]  // result, 1 if current pixel is on text, 0 otherwise
    );
    Pixel_On_text2 #(.displayText("- sw15 toggles to test waveform")) sw15 (
        CLK_VGA,
        15, // text position.x (top left)
        105, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        option_condition[6]  // result, 1 if current pixel is on text, 0 otherwise
    );
    Pixel_On_text2 #(.displayText("- Use up and down buttons to change mode")) modes (
        CLK_VGA,
        15, // text position.x (top left)
        120, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        option_condition[7]  // result, 1 if current pixel is on text, 0 otherwise
    );
    
    assign VGA_red_text = final_condition ? cur_theme_wave[3:0] : cur_theme_background[3:0];
    assign VGA_green_text = final_condition ? cur_theme_wave[7:4] : cur_theme_background[7:4];
    assign VGA_blue_text = final_condition ? cur_theme_wave[11:8] : cur_theme_background[11:8];
endmodule
