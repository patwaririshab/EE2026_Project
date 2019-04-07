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


module clk_div_100kHz(input CLK, output reg clk_100k = 0);
    reg [10:0] counter = 0;
    always @ (posedge CLK) begin
        counter <= counter + 1;
        clk_100k <= (counter == 0) ? 0 : clk_100k;

    end
endmodule
