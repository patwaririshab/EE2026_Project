`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2019 14:04:43
// Design Name: 
// Module Name: clock_divider
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


module generate_button_clock(main_clk, button_clock);
    input main_clk;
    output reg button_clock;
    
    reg [20:0] counter = 0;
    
    always @ (posedge main_clk) begin
        if (counter[20] == 1) begin
            button_clock = 1;
        end
        else begin
            button_clock = 0;
        end
        counter = counter + 1;
    end
endmodule
