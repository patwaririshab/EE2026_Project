`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2019 17:39:24
// Design Name: 
// Module Name: average_amplifier
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


module average_amplifier( input freq_20kHz, [11:0] sound_sample, output reg [11:0] amplified_sound_sample); 
      
      
      reg [11:0] average = 0; 
      always @(posedge freq_20kHz) begin
       if (average == 0) average <= sound_sample;
       average <= (average + sound_sample)/2;  
      
      amplified_sound_sample <= (average*3)/2;
      end
        
endmodule
