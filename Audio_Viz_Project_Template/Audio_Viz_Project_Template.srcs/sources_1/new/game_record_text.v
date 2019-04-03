`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2019 04:50:45
// Design Name: 
// Module Name: game_record_text
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


module game_record_text(
    input CLK_VGA,
    input button_clock,
    
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    output [3:0] VGA_game_red_text,
    output [3:0] VGA_game_green_text,
    output [3:0] VGA_game_blue_text, 
    
    input middle_button_out
    );
    
    reg [11:0] recorded_wave [1279:0];
    
    wire final_condition;
    wire recording_ins_text;
    wire recording_status_text;
    reg recording = 0;
    always @ (posedge button_clock) begin
        if (middle_button_out == 1) begin
            recording = recording + 1;
        end
        
        if (recording == 1) begin
            // Code to record data into array stored here.
        end
    end
    
    assign final_condition = (recording == 0) ? recording_ins_text : (recording_ins_text || recording_status_text);
    
    Pixel_On_text2 #(.displayText("Press middle button to toggle recording")) record_ins (
        CLK_VGA,
        15, // text position.x (top left)
        15, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        recording_ins_text  // result, 1 if current pixel is on text, 0 otherwise
    );
    Pixel_On_text2 #(.displayText("Recording...")) record_status (
        CLK_VGA,
        1000, // text position.x (top left)
        1000, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        recording_status_text  // result, 1 if current pixel is on text, 0 otherwise
    );
    
    assign VGA_game_red_text = final_condition ? 4'hF : 0;
    assign VGA_game_green_text = final_condition ? 4'hF : 0;
    assign VGA_game_blue_text = final_condition ? 4'hF : 0;
endmodule
