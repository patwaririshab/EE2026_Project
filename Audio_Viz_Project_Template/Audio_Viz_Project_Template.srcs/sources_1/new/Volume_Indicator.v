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
    output  [7:0]  seg,
    output reg [4:0] volumeval,
    output reg [11:0] max_value = 0
    );
    
    reg [24:0] counter = 0;
    always @(posedge CLK) begin
        if (counter[24] != 1) counter <= counter + 1;
        else counter <= 0;
    end
    
    //reg [11:0] max_value = 0;
    always @(posedge CLK) begin
        if (sound_sample > max_value) begin
            max_value[11:0] <= sound_sample[11:0];
        end
        if (counter[24] == 1) begin
           max_value <= 0;
        end
    end
         
    always @(posedge counter[24]) begin
        if      (max_value >= 3980) begin block_sample <= 12'b111111111111;  volumeval <= 12; end
        else if (max_value >= 3800) begin block_sample <= 12'b011111111111;  volumeval <= 11; end
        else if (max_value >= 3620) begin block_sample <= 12'b001111111111;  volumeval <= 10; end
        else if (max_value >= 3440) begin block_sample <= 12'b000111111111;  volumeval <= 9; end
        else if (max_value >= 3260) begin block_sample <= 12'b000011111111;  volumeval <= 8; end
        else if (max_value >= 3080) begin block_sample <= 12'b000001111111;  volumeval <= 7; end
        else if (max_value >= 2900) begin block_sample <= 12'b000000111111;  volumeval <= 6; end
        else if (max_value >= 2720) begin block_sample <= 12'b000000011111;  volumeval <= 5; end
        else if (max_value >= 2540) begin block_sample <= 12'b000000001111;  volumeval <= 4; end
        else if (max_value >= 2360) begin block_sample <= 12'b000000000111;  volumeval <= 3; end
        else if (max_value >= 2180) begin block_sample <= 12'b000000000011;  volumeval <= 2; end
        else if (max_value >= 2080) begin block_sample <= 12'b000000000001;  volumeval <= 1; end
        else                        begin block_sample <= 0;  volumeval <= 0; end
   end

    seven_seg_display ssd(CLK,counter[24], block_sample, an, seg);
endmodule
