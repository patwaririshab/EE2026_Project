`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2019 04:36:44
// Design Name: 
// Module Name: mode_changer
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


module mode_changer(
    input button_clock,
    input up_button_out,
    input down_button_out,
    output reg [1:0] mode = 0
    );
    
    always @ (posedge button_clock) begin
        if (up_button_out == 1 && down_button_out == 0) begin
            mode = mode + 1;
        end
        else if (down_button_out == 1 && up_button_out == 0) begin
            mode = (mode > 0) ? mode - 1 : 2;
        end
        
        if (mode == 3) mode = 0;
        
    end
endmodule
