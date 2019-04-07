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
    
    output [14:0] VGA_game_text, 
    
    input middle_button_out,
    input left_button_out,
    input right_button_out,
    input [1:0] mode,
    
    output reg game_running = 0,
    output reg restart = 0,
    output reg start_recording = 0
    );
    
    wire final_condition;
    wire recording_ins_text;
    wire recording_status_text;
    wire proceed_text;
    wire recording_completed_text;
    wire escape_text;
    
    reg recording = 0;
    reg recorded = 0;
    reg [8:0] recording_counter = 0;
    always @ (posedge button_clock) begin
        if (mode == 1) begin
            if (middle_button_out == 1 && recorded == 1) begin
                game_running = 1;
                recording = 0;
                recorded = 0;
                restart = 0;
            end
            else if (middle_button_out == 1 && game_running == 1) begin
                game_running = 0;
                recording = 0;
                recorded = 0;
                restart = 1;
            end
            else if (middle_button_out == 1 && recording == 0 && recorded == 0 && game_running == 0) begin
                recording = 1;
                restart = 0;
            end
            else if (recording == 1) begin
                // Code to record data into array stored here.
                start_recording = 1;
                if (recording_counter[8] == 1) begin
                    recording = 0;
                    recorded = 1;
                    recording_counter = 0;
                    start_recording = 0;
                end
                recording_counter = recording_counter + 1;
            end
        end
    end
    // Once recording is started, this block below runs.
    
    wire dialog_box_condition = (VGA_HORZ_COORD > 5 && VGA_HORZ_COORD < 350) && (VGA_VERT_COORD > 5 && VGA_VERT_COORD < 55);
    wire dialog_box_edge_condition = (VGA_HORZ_COORD == 5 && (VGA_VERT_COORD >= 5 && VGA_VERT_COORD <= 55)) ||
        (VGA_HORZ_COORD == 350 && (VGA_VERT_COORD >= 5 && VGA_VERT_COORD <= 55)) ||
        (VGA_VERT_COORD == 5 && (VGA_HORZ_COORD >= 5 && VGA_HORZ_COORD <= 350)) ||
        (VGA_VERT_COORD == 55 && (VGA_HORZ_COORD >= 5 && VGA_HORZ_COORD <= 350));
    
    assign final_condition = (game_running == 1) ? escape_text
        : (recorded == 1) ? proceed_text || recording_completed_text
        : (recording == 1) ? recording_ins_text || recording_status_text
        : recording_ins_text;
    
    Pixel_On_text2 #(.displayText("Press middle button to restart")) escape (
        CLK_VGA,
        15, // text position.x (top left)
        15, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        escape_text  // result, 1 if current pixel is on text, 0 otherwise
    ); 
    Pixel_On_text2 #(.displayText("Press middle button to proceed")) proceed (
        CLK_VGA,
        15, // text position.x (top left)
        30, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        proceed_text  // result, 1 if current pixel is on text, 0 otherwise
    );
    Pixel_On_text2 #(.displayText("Recording completed")) record_completed (
       CLK_VGA,
       15, // text position.x (top left)
       15, // text position.y (top left)
       VGA_HORZ_COORD, // current position.x
       VGA_VERT_COORD, // current position.y
       recording_completed_text  // result, 1 if current pixel is on text, 0 otherwise
    );
    Pixel_On_text2 #(.displayText("Press middle button to start recording")) record_ins (
        CLK_VGA,
        15, // text position.x (top left)
        15, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        recording_ins_text  // result, 1 if current pixel is on text, 0 otherwise
    );
    Pixel_On_text2 #(.displayText("Recording...")) record_status (
        CLK_VGA,
        15, // text position.x (top left)
        30, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        recording_status_text  // result, 1 if current pixel is on text, 0 otherwise
    );
    
    assign VGA_game_text[4:0] = final_condition ? {1'b1, 4'hF} 
        : dialog_box_condition ? {1'b1, 4'h0} 
        : dialog_box_edge_condition ? {1'b1, 4'hF} 
        : {1'b0, 4'h0};
        
    assign VGA_game_text[9:5] = final_condition ? {1'b1, 4'hF} 
        : dialog_box_condition ? {1'b1, 4'h0} 
        : dialog_box_edge_condition ? {1'b1, 4'hF} 
        : {1'b0, 4'h0};
        
    assign VGA_game_text[14:10] = final_condition ? {1'b1, 4'hF} 
        : dialog_box_condition ? {1'b1, 4'h0} 
        : dialog_box_edge_condition ? {1'b1, 4'hF} 
        : {1'b0, 4'h0};
endmodule
