`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2019 15:05:28
// Design Name: 
// Module Name: test_20khz
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


module test_20khz( );


reg CLK;
wire freq_20hz;
clk_div my_20khz(CLK,freq_20hz);

initial begin
CLK = 0;
end

always begin
CLK = ~CLK; #10;
end

endmodule
