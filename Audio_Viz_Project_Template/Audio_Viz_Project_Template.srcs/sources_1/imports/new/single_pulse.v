`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2019 15:15:09
// Design Name: 
// Module Name: single_pulse
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


module single_pulse(button_clock, button_in, button_out);
    input button_clock;
    input button_in;
    output button_out;
    
    wire dff_1_output;
    wire dff_2_output;
        
    d_flip_flop dff_1(button_clock, button_in, dff_1_output);
    d_flip_flop dff_2(button_clock, dff_1_output, dff_2_output);
    
    assign button_out = dff_1_output & ~dff_2_output;
endmodule
