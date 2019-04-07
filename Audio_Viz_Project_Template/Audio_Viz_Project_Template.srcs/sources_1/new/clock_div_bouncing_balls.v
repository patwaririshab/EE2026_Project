`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2019 16:12:49
// Design Name: 
// Module Name: clock_div_bouncing_balls
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

module clock_div_bouncing_balls(
    input CLK,
    input freq_20khz,
    output reg freq_bb
    );
    
    reg [20:0] counter;
    always @(posedge CLK) begin
        counter <= (counter[20] == 1) ? 0: counter + 1;
        freq_bb <= (counter == 0) ? ~freq_bb : freq_bb;
    end  
endmodule
