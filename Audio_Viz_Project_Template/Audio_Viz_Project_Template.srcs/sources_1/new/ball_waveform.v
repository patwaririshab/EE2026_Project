`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2019 04:31:32
// Design Name: 
// Module Name: ball_waveform
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


module ball_waveform(
    input clk_sample,

    input [10:0] wave_sample,
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    output reg [43:0] ball_start_pos,
    output [14:0] VGA_ball_waveform 
    );
    
    reg [9:0] sample_memory[1279:0];
    reg [10:0] k = 0;
    reg [5:0] pos_counter = 0;
    always @ (posedge clk_sample) begin
        if (k == 1279) begin
            k = 0;
        end
        else k = k + 1;
        
        if (pos_counter == 0) ball_start_pos[10:0] <= wave_sample;
        else if (pos_counter == 20) ball_start_pos[21:11] <= wave_sample;
        else if (pos_counter == 40) ball_start_pos[32:22] <= wave_sample;
        else if (pos_counter == 60) ball_start_pos[43:33] <= wave_sample;    
        
        pos_counter = pos_counter + 1;
        sample_memory[k] <= wave_sample[10:1];    
    end
    
    assign VGA_ball_waveform[4:0] = VGA_HORZ_COORD < 1280 && 
        VGA_VERT_COORD == (1024 - sample_memory[VGA_HORZ_COORD]) ? {1'b1, 4'hF}
        : {1'b0, 4'h0};
    
    assign VGA_ball_waveform[9:5] = VGA_HORZ_COORD < 1280 && 
        VGA_VERT_COORD == (1024 - sample_memory[VGA_HORZ_COORD]) ? {1'b1, 4'hF}
        : {1'b0, 4'h0}; 
    
    assign VGA_ball_waveform[14:10] = VGA_HORZ_COORD < 1280 && 
        VGA_VERT_COORD == (1024 - sample_memory[VGA_HORZ_COORD]) ? {1'b1, 4'hF}
        : {1'b0, 4'h0};  
endmodule
