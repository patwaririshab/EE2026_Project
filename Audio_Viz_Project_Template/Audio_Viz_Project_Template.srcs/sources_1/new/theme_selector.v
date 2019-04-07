`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2019 00:29:41
// Design Name: 
// Module Name: theme_selector
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


module theme_selector(
        input button_clock,
        input left_button_out,
        input right_button_out,
        output reg [11:0] cur_theme_wave,
        output reg [11:0] cur_theme_axes,
        output reg [11:0] cur_theme_grid,
        output reg [11:0] cur_theme_tick,
        output reg [11:0] cur_theme_background,
        input [1:0] mode
    );
    
    reg [11:0] cur_theme[0:4];
    reg [2:0] theme_counter = 0; // This value goes from 0 to a max of 4.
    
    always @ (posedge button_clock) begin
        if (mode == 0) begin
            if (left_button_out == 1 && right_button_out == 0) begin
                theme_counter = theme_counter - 1;
            end
            else if (right_button_out == 1 && left_button_out == 0) begin
                theme_counter = theme_counter + 1;
            end
            
            if (theme_counter == 5) theme_counter = 0;
            if (theme_counter == 7) theme_counter = 4;
            
            case (theme_counter)
                0: begin //Default
                    // Wave
                    cur_theme[0][3:0] = 4'hf;
                    cur_theme[0][7:4] = 4'hf;
                    cur_theme[0][11:8] = 4'hf;
                    // Axes
                    cur_theme[1][3:0] = 4'h0;
                    cur_theme[1][7:4] = 4'hD;
                    cur_theme[1][11:8] = 4'h0;
                    // Grid
                    cur_theme[2][3:0] = 4'h0;
                    cur_theme[2][7:4] = 4'hd;
                    cur_theme[2][11:8] = 4'h0;
                    // Tick
                    cur_theme[3][3:0] = 4'hf;
                    cur_theme[3][7:4] = 4'hf;
                    cur_theme[3][11:8] = 4'hf;
                    //Background
                    cur_theme[4][3:0] = 4'h0;
                    cur_theme[4][7:4] = 4'h0;
                    cur_theme[4][11:8] = 4'h0;
                end
                1: begin //Playful greens and blues
                    // Wave
                    cur_theme[0][3:0] = 4'h8;
                    cur_theme[0][7:4] = 4'ha;
                    cur_theme[0][11:8] = 4'h4;
                    // Axes
                    cur_theme[1][3:0] = 4'h7;
                    cur_theme[1][7:4] = 4'ha;
                    cur_theme[1][11:8] = 4'ha;
                    // Grid
                    cur_theme[2][3:0] = 4'h7;
                    cur_theme[2][7:4] = 4'ha;
                    cur_theme[2][11:8] = 4'ha;
                    // Tick
                    cur_theme[3][3:0] = 4'hc;
                    cur_theme[3][7:4] = 4'h0;
                    cur_theme[3][11:8] = 4'h0;
                    //Background
                    cur_theme[4][3:0] = 4'h3;
                    cur_theme[4][7:4] = 4'h4;
                    cur_theme[4][11:8] = 4'h5;
                end
                2: begin //Day and Night
                    // Wave
                    cur_theme[0][3:0] = 4'hf;
                    cur_theme[0][7:4] = 4'h8;
                    cur_theme[0][11:8] = 4'h0;
                    // Axes
                    cur_theme[1][3:0] = 4'h0;
                    cur_theme[1][7:4] = 4'h3;
                    cur_theme[1][11:8] = 4'h5;
                    // Grid
                    cur_theme[2][3:0] = 4'h0;
                    cur_theme[2][7:4] = 4'h3;
                    cur_theme[2][11:8] = 4'h5;
                    // Tick
                    cur_theme[3][3:0] = 4'he;
                    cur_theme[3][7:4] = 4'hd;
                    cur_theme[3][11:8] = 4'h4;
                    //Background
                    cur_theme[4][3:0] = 4'h0;
                    cur_theme[4][7:4] = 4'h1;
                    cur_theme[4][11:8] = 4'h2;
                end
                3: begin //Modern and crisp
                    // Wave
                    cur_theme[0][3:0] = 4'h7;
                    cur_theme[0][7:4] = 4'h2;
                    cur_theme[0][11:8] = 4'h0;
                    // Axes
                    cur_theme[1][3:0] = 4'hc;
                    cur_theme[1][7:4] = 4'hd;
                    cur_theme[1][11:8] = 4'h6;
                    // Grid
                    cur_theme[2][3:0] = 4'hc;
                    cur_theme[2][7:4] = 4'hd;
                    cur_theme[2][11:8] = 4'h6;
                    // Tick
                    cur_theme[3][3:0] = 4'hd;
                    cur_theme[3][7:4] = 4'h7;
                    cur_theme[3][11:8] = 4'h2;
                    //Background
                    cur_theme[4][3:0] = 4'ha;
                    cur_theme[4][7:4] = 4'ha;
                    cur_theme[4][11:8] = 4'ha;
                end
                4: begin //Fun and tropical
                    // Wave
                    cur_theme[0][3:0] = 4'hf;
                    cur_theme[0][7:4] = 4'hf;
                    cur_theme[0][11:8] = 4'hf;
                    // Axes
                    cur_theme[1][3:0] = 4'h5;
                    cur_theme[1][7:4] = 4'ha;
                    cur_theme[1][11:8] = 4'ha;
                    // Grid
                    cur_theme[2][3:0] = 4'h5;
                    cur_theme[2][7:4] = 4'ha;
                    cur_theme[2][11:8] = 4'ha;
                    // Tick
                    cur_theme[3][3:0] = 4'h0;
                    cur_theme[3][7:4] = 4'h0;
                    cur_theme[3][11:8] = 4'h0;
                    //Background
                    cur_theme[4][3:0] = 4'h4;
                    cur_theme[4][7:4] = 4'h4;
                    cur_theme[4][11:8] = 4'hf;
                end
            endcase
            
            cur_theme_wave = cur_theme[0];
            cur_theme_axes = cur_theme[1];
            cur_theme_grid = cur_theme[2];
            cur_theme_tick = cur_theme[3];
            cur_theme_background = cur_theme[4];
        end
    end     
endmodule
