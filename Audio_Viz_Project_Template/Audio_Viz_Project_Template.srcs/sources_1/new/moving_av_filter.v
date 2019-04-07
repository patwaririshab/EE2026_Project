`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2019 07:39:24
// Design Name: 
// Module Name: moving_av_filter
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


module bar_convertor( 
    input CLK_20KHZ, 
    input [11:0] input_wave,
    output reg [11:0] filtered_output
    );
    
    reg [10:0] new_counter = 0; //0 - 1279
    reg [11:0] cur_output = 0;
    always @ (posedge CLK_20KHZ) begin
        if (new_counter == 1280) new_counter = 0;
            
        if (new_counter % 40 == 0) begin
           cur_output = input_wave;
           filtered_output = cur_output;    
        end
        else if (new_counter % 40 >= 34 && new_counter % 40 <= 39) begin
            filtered_output = 0;
        end
        else filtered_output = cur_output;
        
        new_counter = new_counter + 1;
    end
endmodule
