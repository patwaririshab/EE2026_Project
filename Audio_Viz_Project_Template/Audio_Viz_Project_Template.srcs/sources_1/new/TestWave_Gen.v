`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2019 15:45:13
// Design Name: 
// Module Name: TestWave_Gen
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


module TestWave_Gen(input wave_clock, output reg [9:0] counter = 0, input [11:0] sound_sample);
        always @ (posedge wave_clock) begin

        if (counter >= 640) begin
                counter = 0;
        end
            counter = counter + 1; 
        end

endmodule
