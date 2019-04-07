`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2019 23:52:28
// Design Name: 
// Module Name: seven_seg_display
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

module seven_seg_display(
    input CLK,
    input SLOWCLK, 
    input [11:0] block_sample, 
    output reg [3:0] an, 
    output reg [7:0] seg 
    );
    
    reg count = 0;
    reg [7:0] status1;
    reg [7:0] status2;
    reg [16:0] highfreq = 0;
    always @(posedge CLK) begin
        if (highfreq[16] == 1) begin
        highfreq = 0;
        end
        else begin
        highfreq = highfreq + 1;
        end
    end
    
    always @(posedge highfreq[16]) begin
        //count = ~count;
        if (count == 0) begin
            seg = 8'b1;
            an = 4'b1110; // Turn on last bit
            seg = status1;
                              
        end
        else begin
            seg = 8'b1;
            an  = 4'b1101;
            seg = status2;
        end
        count = count + 1;
    end

    always @(posedge SLOWCLK) begin
        if (block_sample == 12'b111111111111) begin //12
                status2 = 8'b11111001; //1
                status1 = 8'b10100100; //2
        end
        else if (block_sample == 12'b011111111111) begin //11
                status2 = 8'b11111001; //1
                status1 = 8'b11111001; //1
        end
        else if (block_sample == 12'b001111111111) begin //10
                status2 = 8'b11111001; //1
                status1 = 8'b11000000; //0
        end
        else if (block_sample == 12'b000111111111) begin //9
                status1 = 8'b10011000;
                status2 = 8'b11111111;
        end
        else if (block_sample == 12'b000011111111) begin //8 
                status1 = 8'b10000000;
                status2 = 8'b11111111;
        end
        else if (block_sample == 12'b000001111111) begin //7
                status1 = 8'b11111000;
                status2 = 8'b11111111;
        end
        else if (block_sample == 12'b000000111111) begin //6
                status1 = 8'b10000010;
                status2 = 8'b11111111;
        end
        else if (block_sample == 12'b000000011111) begin //5
                status1 = 8'b10010010;
                status2 = 8'b11111111;
        end
        else if (block_sample == 12'b000000001111) begin //4
                status1 = 8'b10011001;
                status2 = 8'b11111111;
        end
        else if (block_sample == 12'b000000000111) begin //3
                status1 = 8'b10110000;
                status2 = 8'b11111111;
        end
        else if (block_sample == 12'b000000000011) begin //2
                status1 = 8'b10100100;
                status2 = 8'b11111111;
        end
        else if (block_sample == 12'b000000000001) begin //1
                status1 = 8'b11111001;
                status2 = 8'b11111111;
        end
        else if (block_sample == 0) begin //0
                status1 = 8'b11000000;
                status2 = 8'b11111111;
        end
    end
endmodule
