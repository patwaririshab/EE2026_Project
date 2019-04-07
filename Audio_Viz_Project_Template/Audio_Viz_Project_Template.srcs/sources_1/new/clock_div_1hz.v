`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2019 10:40:44
// Design Name: 
// Module Name: clock_div_1hz
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


module clock_div_1hz(input freq_6hz, output reg freq_1hz);
    
//Create a 1hz clock 
        reg [3:0] counter = 0;
        always @(posedge freq_6hz) begin
            counter <= (counter == 5) ? 0 : counter + 1;
            freq_1hz <= (counter == 0) ? ~freq_1hz : freq_1hz;
        end
endmodule
