`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2019 07:39:24
// Design Name: 
// Module Name: moving_av_filter
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


module moving_av_filter( 
    input freq_20kHz, 
    [11:0] sound_sample,
    output reg [11:0] filtered_output          

    );

    reg [15:0]sum = 16'b0;
    reg [11:0] dat_buffer[0:1023];
    integer x;
    integer y = 10;
    reg [3:0] cnt = 4'b0; reg [9:0] i = 4; reg[9:0] j = 0;
    
    initial begin
    for(x=0; x < 1023; x=x+1) begin
        dat_buffer[x] = 0;
    end
    
    end
    
    initial begin
        filtered_output = 0;
    end
    
    always @ (posedge freq_20kHz) begin
        dat_buffer[i] = sound_sample;
        sum = sum + dat_buffer[j];
        i <= (i == 1023) ? 0 : i+1;
        j <= (j == 1023) ? 0 : j + 1;
        cnt <= (cnt == y) ? 0 : cnt + 1;
        
        if (cnt == y) begin
            filtered_output = sum/11;
            sum = 16'b0;
        end
        else begin
            filtered_output = filtered_output;
        end
    end
     
endmodule
