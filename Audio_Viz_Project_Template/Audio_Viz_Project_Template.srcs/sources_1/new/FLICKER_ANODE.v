`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2019 01:39:29
// Design Name: 
// Module Name: FLICKER_ANODE
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


module FLICKER_ANODE(input SOMECLK, output reg [3:0] an);
reg [3:0] an_counter = 0;
always @(posedge SOMECLK) begin
        an_counter <= (an_counter == 4)?  0 : an_counter + 1;
        case (an_counter) 
            0: an <= 4'b1110;
            1: an <= 4'b1101;
            2: an <= 4'b1011;
            3: an <= 4'b0111;
            4: an <= 4'b1111;
       endcase
end
endmodule
