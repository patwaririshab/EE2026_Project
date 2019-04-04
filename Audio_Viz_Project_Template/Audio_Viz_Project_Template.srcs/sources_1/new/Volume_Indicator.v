`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2019 19:55:14
// Design Name: 
// Module Name: Volume_Indicator
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

module Volume_Indicator( 
    input CLK, 
    input [11:0] sound_sample, 
    output reg [11:0] block_sample = 0, 
    output  [3:0]  an,
    output  [7:0]  seg
    );
    
    reg [24:0] counter = 0;
    always @(posedge CLK) begin
        if (counter[24] != 1) counter <= counter + 1;
        else counter <= 0;
    end
    
    reg [11:0] max_value = 0;
    always @(posedge CLK) begin
        if (sound_sample > max_value) begin
            max_value[11:0] <= sound_sample[11:0];
        end
        if (counter[24] == 1) begin
           max_value = 0;
        end
    end
         
    always @(posedge counter[24]) begin
        if      (max_value >= 3980) block_sample <= 12'b111111111111;
        else if (max_value >= 3800) block_sample <= 12'b011111111111;
        else if (max_value >= 3620) block_sample <= 12'b001111111111;
        else if (max_value >= 3440) block_sample <= 12'b000111111111;
        else if (max_value >= 3260) block_sample <= 12'b000011111111;
        else if (max_value >= 3080) block_sample <= 12'b000001111111;
        else if (max_value >= 2900) block_sample <= 12'b000000111111;
        else if (max_value >= 2720) block_sample <= 12'b000000011111;
        else if (max_value >= 2540) block_sample <= 12'b000000001111;
        else if (max_value >= 2360) block_sample <= 12'b000000000111;
        else if (max_value >= 2180) block_sample <= 12'b000000000011;
        else if (max_value >= 2080) block_sample <= 12'b000000000001;
        else                        block_sample <= 0;
   end

    seven_seg_display ssd(CLK,counter[24], block_sample, an, seg);
endmodule
