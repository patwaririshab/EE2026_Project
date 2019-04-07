`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2019 07:49:04
// Design Name: 
// Module Name: clk_div_100kHz
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


module clk_div_1525kHz(input CLK, output reg clk_1525k = 0);
    reg [14:0] counter = 0;
    always @ (posedge CLK) begin
        counter <= (counter[14] == 1) ? 0 :counter + 1;
        clk_1525k <= (counter == 0) ? ~clk_1525k : clk_1525k;
    end
endmodule
