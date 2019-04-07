`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2019 14:10:58
// Design Name: 
// Module Name: clk_div
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


module clk_div(
    input CLK,
    output reg clk_20k = 0
    );
    
    reg [12:0] counter = 0;
    always @(posedge CLK) begin
        counter <= (counter == 2499) ? 0 : counter + 1;
        clk_20k <= (counter == 0) ? ~clk_20k : clk_20k;
    end
    
    
    
endmodule
