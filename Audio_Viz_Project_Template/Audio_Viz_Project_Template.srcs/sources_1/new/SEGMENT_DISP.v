`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2019 03:23:54
// Design Name: 
// Module Name: SEGMENT_DISP
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
module SEGMENT_DISP(
    input FASTCLOCK,
    input[18:0] frequency, 
    input [3:0] interim_an, 
    output reg [7:0] seg
    );
    
    wire [3:0] digit0 = frequency %10;
    wire [3:0] digit1 = (frequency/10) %10;
    wire [3:0] digit2 = (frequency/100) %10;
    wire [3:0] digit3 = (frequency/1000) %10;
    
    reg [2:0] counter = 0;
    reg SLOWCLOCK = 1;
    
    always @(posedge FASTCLOCK) begin
            if(interim_an == 4'b01111) begin    
                if (digit0 == 0) seg <= 8'b11000000;
                else if (digit0 == 1) seg <= 8'b11111001;
                else if (digit0 == 2) seg <= 8'b10100100;
                else if (digit0 == 3) seg <= 8'b10110000;
                else if (digit0 == 4) seg <= 8'b10011001;
                else if (digit0 == 5) seg <= 8'b10010010;
                else if (digit0 == 6) seg <= 8'b10000010;
                else if (digit0 == 7) seg <= 8'b11111000;
                else if (digit0 == 8) seg <= 8'b10000000;
                else if (digit0 == 9) seg <= 8'b10011000;
                else seg <= 8'b11111111;
             end
            
            if ( interim_an == 4'b1110) begin
                if (digit1 == 0) seg <= 8'b11000000;
                else if (digit1 == 1) seg <= 8'b11111001;
                else if (digit1 == 2) seg <= 8'b10100100;
                else if (digit1 == 3) seg <= 8'b10110000;
                else if (digit1 == 4) seg <= 8'b10011001;
                else if (digit1 == 5) seg <= 8'b10010010;
                else if (digit1 == 6) seg <= 8'b10000010;
                else if (digit1 == 7) seg <= 8'b11111000;
                else if (digit1 == 8) seg <= 8'b10000000;
                else if (digit1 == 9) seg <= 8'b10011000;
                else seg <= 8'b11111111;
            end
            
            if ( interim_an == 4'b1101) begin
                 if (digit2 == 0) seg <= 8'b11000000;
                else if (digit2 == 1) seg <= 8'b11111001;
                else if (digit2 == 2) seg <= 8'b10100100;
                else if (digit2 == 3) seg <= 8'b10110000;
                else if (digit2 == 4) seg <= 8'b10011001;
                else if (digit2 == 5) seg <= 8'b10010010;
                else if (digit2 == 6) seg <= 8'b10000010;
                else if (digit2 == 7) seg <= 8'b11111000;
                else if (digit2 == 8) seg <= 8'b10000000;
                else if (digit2 == 9) seg <= 8'b10011000;
                else seg <= 8'b11111111;
            end
            
            if ( interim_an == 4'b1011) begin
                 if (digit3 == 0) seg <= 8'b11000000;
                else if (digit3 == 1) seg <= 8'b11111001;
                else if (digit3 == 2) seg <= 8'b10100100;
                else if (digit3 == 3) seg <= 8'b10110000;
                else if (digit3 == 4) seg <= 8'b10011001;
                else if (digit3 == 5) seg <= 8'b10010010;
                else if (digit3 == 6) seg <= 8'b10000010;
                else if (digit3 == 7) seg <= 8'b11111000;
                else if (digit3 == 8) seg <= 8'b10000000;
                else if (digit3 == 9) seg <= 8'b10011000;
                else seg <= 8'b11111111;
            end
    end

endmodule
