`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2019 16:05:03
// Design Name: 
// Module Name: bouncing_balls
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

module ball_bounce (
    input clk,
    input freq_20kHz,
    input [10:0] wave_sample,
    
    input middle_button_out,
    input button_clock,
    
    input [3:0] volume,
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    output [14:0] VGA_ball_colour,
    output [14:0] VGA_ball_waveform
    );
    
    reg [43:0] ball_start_pos = 0;
    reg [9:0] sample_memory[1279:0];
    reg [10:0] k = 0;
    reg [5:0] pos_counter = 0;
    always @ (posedge freq_20kHz) begin
        if (k == 1279) begin
            k = 0;
        end
        else k = k + 1;
        
        if (pos_counter == 0) ball_start_pos[10:0] <= wave_sample;
        else if (pos_counter == 20) ball_start_pos[21:11] <= wave_sample;
        else if (pos_counter == 40) ball_start_pos[32:22] <= wave_sample;
        else if (pos_counter == 60) ball_start_pos[43:33] <= wave_sample;    
        
        pos_counter = pos_counter + 1;
        sample_memory[k] <= wave_sample[10:1];    
    end
    
    wire wave_condition = (VGA_HORZ_COORD % 40 >= 0 && VGA_HORZ_COORD % 40 <= 33) && 
        (VGA_VERT_COORD >= 1024 - sample_memory[VGA_HORZ_COORD]);
    
    reg [0:11] ball_colours [0:12];
    initial begin
        ball_colours[0] = 12'h0ff;
        ball_colours[1] = 12'h09f;
        ball_colours[2] = 12'h04f;
        ball_colours[3] = 12'h60f;
        ball_colours[4] = 12'hf0f;
        ball_colours[5] = 12'hf05;
        ball_colours[6] = 12'hf00;
        ball_colours[7] = 12'hf60;
        ball_colours[8] = 12'hfe0;
        ball_colours[9] = 12'h3f0;
        ball_colours[10] = 12'h0f8;
        ball_colours[11] = 12'h0fd;
        ball_colours[12] = 12'h0ff;
    end
    wire [3:0] b1_colour = volume;
    wire [3:0] b2_colour = (volume + 2 > 12) ? (volume + 2) % 13 : volume + 2;
    wire [3:0] b3_colour = (volume + 4 > 12) ? (volume + 4) % 13 : volume + 4;
    wire [3:0] b4_colour = (volume + 6 > 12) ? (volume + 6) % 13 : volume + 6;
    wire [3:0] bar_colour = (volume + 8 > 12) ? (volume + 8) % 13 : volume + 8;
        
    reg [21:0] b1_pos;
    reg [21:0] b2_pos;
    reg [21:0] b3_pos;
    reg [21:0] b4_pos;
    
    reg [1:0] b1_dir = 2'b11;
    reg [1:0] b2_dir = 2'b01;
    reg [1:0] b3_dir = 2'b10;
    reg [1:0] b4_dir = 2'b00; //1 is negative, 0 is positive

    reg [21:0] movement_counter = 0;
    
    //wire outer_wall;
    //assign outer_wall = (VGA_HORZ_COORD == 0 && VGA_VERT_COORD >= 0 && VGA_VERT_COORD <= 1023) ||
    //    (VGA_HORZ_COORD == 1279 && VGA_VERT_COORD >= 0 && VGA_VERT_COORD <= 1023) ||
    //    (VGA_VERT_COORD == 0 && VGA_HORZ_COORD >= 0 && VGA_HORZ_COORD <= 1279) ||
    //    (VGA_VERT_COORD == 1023 && VGA_HORZ_COORD >= 0 && VGA_HORZ_COORD <= 1279);
        
    //wire inner_box = (VGA_HORZ_COORD > 50 && VGA_HORZ_COORD < 1229) &&
    //    (VGA_VERT_COORD > 50 && VGA_VERT_COORD < 973);
        
    wire boundary_area = ((VGA_HORZ_COORD >= 0 && VGA_HORZ_COORD <= 1279) &&
        (VGA_VERT_COORD >= 0 && VGA_VERT_COORD <= 1023)) && 
        ~((VGA_HORZ_COORD >= 50 && VGA_HORZ_COORD <= 1229) &&
        (VGA_VERT_COORD >= 50 && VGA_VERT_COORD <= 973));

    wire b1_condition = ((VGA_HORZ_COORD - b1_pos[10:0]) * (VGA_HORZ_COORD - b1_pos[10:0]) 
        + (VGA_VERT_COORD - b1_pos[21:11]) * (VGA_VERT_COORD - b1_pos[21:11])) < 1800;
    
    wire b2_condition = ((VGA_HORZ_COORD - b2_pos[10:0]) * (VGA_HORZ_COORD - b2_pos[10:0]) 
        + (VGA_VERT_COORD - b2_pos[21:11]) * (VGA_VERT_COORD - b2_pos[21:11])) < 1800;
    
    wire b3_condition = ((VGA_HORZ_COORD - b3_pos[10:0]) * (VGA_HORZ_COORD - b3_pos[10:0]) 
        + (VGA_VERT_COORD - b3_pos[21:11]) * (VGA_VERT_COORD - b3_pos[21:11])) < 1800;
    
    wire b4_condition = ((VGA_HORZ_COORD - b4_pos[10:0]) * (VGA_HORZ_COORD - b4_pos[10:0]) 
        + (VGA_VERT_COORD - b4_pos[21:11]) * (VGA_VERT_COORD - b4_pos[21:11])) < 1800;
    
    wire b1_collision = (b1_condition) & (boundary_area                | b2_condition | b3_condition | b4_condition);
    wire b2_collision = (b2_condition) & (boundary_area | b1_condition                | b3_condition | b4_condition);
    wire b3_collision = (b3_condition) & (boundary_area | b1_condition | b2_condition                | b4_condition);
    wire b4_collision = (b4_condition) & (boundary_area | b1_condition | b2_condition | b3_condition               );
    
    initial begin
        b1_pos[10:0] = 300;//ball_start_pos[10:0];
        b1_pos[21:11] = 300;//ball_start_pos[10:0];
        b2_pos[10:0] = 640;//ball_start_pos[21:11];
        b2_pos[21:11] = 512;//ball_start_pos[21:11];
        b3_pos[10:0] = 640;//ball_start_pos[32:22];
        b3_pos[21:11] = 850;//ball_start_pos[32:22];
        b4_pos[10:0] = 400;//ball_start_pos[43:33];
        b4_pos[21:11] = 750;//ball_start_pos[43:33];
    end
    reg button_pressed = 0;
    always @ (posedge button_clock) begin
        if (middle_button_out == 1) begin
            button_pressed = 1;
        end
        else button_pressed = 0;
    end
    always @ (posedge clk) begin
        if (movement_counter[21] == 1) begin
            if (button_pressed == 1) begin
                b1_pos[10:0] = 300;//ball_start_pos[10:0];
                b1_pos[21:11] = 300;//ball_start_pos[10:0];
                b2_pos[10:0] = 640;//ball_start_pos[21:11];
                b2_pos[21:11] = 512;//ball_start_pos[21:11];
                b3_pos[10:0] = 640;//ball_start_pos[32:22];
                b3_pos[21:11] = 850;//ball_start_pos[32:22];
                b4_pos[10:0] = 400;//ball_start_pos[43:33];
                b4_pos[21:11] = 750;//ball_start_pos[43:33];
            end
            else begin
                b1_pos[10:0] = b1_dir[1] ? 
                    b1_pos[10:0] + (volume * 3)
                    : b1_pos[10:0] - (volume * 3);
                b1_pos[21:11] = b1_dir[0] ?
                    b1_pos[21:11] + (volume * 3)
                    : b1_pos[21:11] - (volume * 3);
                if (b1_pos[10:0] >= 1229) begin
                    b1_pos[10:0] = 1228;
                end
                if (b1_pos[21:11] >= 973) begin
                    b1_pos[21:11] = 972;
                end
                if (b1_pos[10:0] <= 50) begin
                    b1_pos[10:0] = 51;
                end
                if (b1_pos[21:11] <= 50) begin
                    b1_pos[21:11] = 51;
                end
                    
                b2_pos[10:0] = b2_dir[1] ? 
                    b2_pos[10:0] + (volume * 3)
                    : b2_pos[10:0] - (volume * 3);
                b2_pos[21:11] = b2_dir[0] ?
                    b2_pos[21:11] + (volume * 3)
                    : b2_pos[21:11] - (volume * 3);
                if (b2_pos[10:0] >= 1229) begin
                    b2_pos[10:0] = 1228;
                end
                if (b2_pos[21:11] >= 973) begin
                    b2_pos[21:11] = 972;
                end
                if (b2_pos[10:0] <= 50) begin
                    b2_pos[10:0] = 51;
                end
                if (b2_pos[21:11] <= 50) begin
                    b2_pos[21:11] = 51;
                end
                    
                b3_pos[10:0] = b3_dir[1] ? 
                    b3_pos[10:0] + (volume * 3)
                    : b3_pos[10:0] - (volume * 3);
                b3_pos[21:11] = b3_dir[0] ?
                    b3_pos[21:11] + (volume * 3)
                    : b3_pos[21:11] - (volume * 3);
                if (b3_pos[10:0] >= 1229) begin
                    b3_pos[10:0] = 1228;
                end
                if (b3_pos[21:11] >= 973) begin
                    b3_pos[21:11] = 972;
                end
                if (b3_pos[10:0] <= 50) begin
                    b3_pos[10:0] = 51;
                end
                if (b3_pos[21:11] <= 50) begin
                    b3_pos[21:11] = 51;
                end
                    
                b4_pos[10:0] = b4_dir[1] ? 
                    b4_pos[10:0] + (volume * 3)
                    : b4_pos[10:0] - (volume * 3);
                b4_pos[21:11] = b4_dir[0] ?
                    b4_pos[21:11] + (volume * 3)
                    : b4_pos[21:11] - (volume * 3);
                if (b4_pos[10:0] >= 1229) begin
                    b4_pos[10:0] = 1228;
                end
                if (b4_pos[21:11] >= 973) begin
                    b4_pos[21:11] = 972;
                end
                if (b4_pos[10:0] <= 50) begin
                    b4_pos[10:0] = 51;
                end
                if (b4_pos[21:11] <= 50) begin
                    b4_pos[21:11] = 51;
                end
            end
            movement_counter = 0;
        end
        else begin
            if (b1_collision) begin
                //if (boundary_area == 1) begin
                    /*if (b1_dir == 2'b01) begin
                        if (b1_pos[10:0] >= 1228) b1_dir = 2'b11;
                        if (b1_pos[21:11] <= 51) b1_dir = 2'b00;
                    end
                    else if (b1_dir == 2'b00) begin
                        if (b1_pos[10:0] >= 1228) b1_dir = 2'b10;
                        if (b1_pos[21:11] >= 972) b1_dir = 2'b01;
                    end
                    else if (b1_dir == 2'b11) begin
                        if (b1_pos[10:0] <= 51) b1_dir = 2'b01;
                        if (b1_pos[21:11] <= 51) b1_dir = 2'b10;
                    end
                    else if (b1_dir == 2'b10) begin
                        if (b1_pos[10:0] <= 51) b1_dir = 2'b00;
                        if (b1_pos[21:11] >= 972) b1_dir = 2'b11;
                    end*/
                //end 
                //else b1_dir = ~b1_dir;
                
                b1_pos[10:0] = b1_dir[1] ?
                    b1_pos[10:0] - 3
                    : b1_pos[10:0] + 3;
                b1_pos[21:11] = b1_dir[0] ?
                    b1_pos[21:11] - 3
                    : b1_pos[21:11] + 3;
                b1_dir = ~b1_dir;
            end
           
            if (b2_collision) begin
                //if (boundary_area == 1) begin
                    /*if (b2_dir == 2'b01) begin
                        if (b2_pos[10:0] >= 1228) b2_dir = 2'b11;
                        if (b2_pos[21:11] <= 51) b2_dir = 2'b00;
                    end
                    else if (b2_dir == 2'b00) begin
                        if (b2_pos[10:0] >= 1228) b2_dir = 2'b10;
                        if (b2_pos[21:11] >= 972) b2_dir = 2'b01;
                    end
                    else if (b2_dir == 2'b11) begin
                        if (b2_pos[10:0] <= 51) b2_dir = 2'b01;
                        if (b2_pos[21:11] <= 51) b2_dir = 2'b10;
                    end
                    else if (b2_dir == 2'b10) begin
                        if (b2_pos[10:0] <= 51) b2_dir = 2'b00;
                        if (b2_pos[21:11] >= 972) b2_dir = 2'b11;
                    end*/
                //end
                //else b2_dir = ~b2_dir;
                
                b2_pos[10:0] = b2_dir[1] ?
                    b2_pos[10:0] - 3
                    : b2_pos[10:0] + 3;
                b2_pos[21:11] = b2_dir[0] ?
                    b2_pos[21:11] - 3
                    : b2_pos[21:11] + 3;
                b2_dir = ~b2_dir;
            end
            
            if (b3_collision) begin
                //if (boundary_area == 1) begin
                    /*if (b3_dir == 2'b01) begin
                        if (b3_pos[10:0] >= 1228) b3_dir = 2'b11;
                        if (b3_pos[21:11] <= 51) b3_dir = 2'b00;
                    end
                    else if (b3_dir == 2'b00) begin
                        if (b3_pos[10:0] >= 1228) b3_dir = 2'b10;
                        if (b3_pos[21:11] >= 972) b3_dir = 2'b01;
                    end
                    else if (b3_dir == 2'b11) begin
                        if (b3_pos[10:0] <= 51) b3_dir = 2'b01;
                        if (b3_pos[21:11] <= 51) b3_dir = 2'b10;
                    end
                    else if (b3_dir == 2'b10) begin
                        if (b3_pos[10:0] <= 51) b3_dir = 2'b00;
                        if (b3_pos[21:11] >= 972) b3_dir = 2'b11;
                    end*/
                //end
                //else b3_dir = ~b3_dir;
                
                b3_pos[10:0] = b3_dir[1] ?
                    b3_pos[10:0] - 3
                    : b3_pos[10:0] + 3;
                b3_pos[21:11] = b3_dir[0] ?
                    b3_pos[21:11] - 3
                    : b3_pos[21:11] + 3;
                b3_dir = ~b3_dir;
            end
            
            if (b4_collision) begin
                //if (boundary_area == 1) begin
                    /*if (b4_dir == 2'b01) begin
                        if (b4_pos[10:0] >= 1228) b4_dir = 2'b11;
                        if (b4_pos[21:11] <= 51) b4_dir = 2'b00;
                    end
                    else if (b4_dir == 2'b00) begin
                        if (b4_pos[10:0] >= 1228) b4_dir = 2'b10;
                        if (b4_pos[21:11] >= 972) b4_dir = 2'b01;
                    end
                    else if (b4_dir == 2'b11) begin
                        if (b4_pos[10:0] <= 51) b4_dir = 2'b01;
                        if (b4_pos[21:11] <= 51) b4_dir = 2'b10;
                    end
                    else if (b4_dir == 2'b10) begin
                        if (b4_pos[10:0] <= 51) b4_dir = 2'b00;
                        if (b4_pos[21:11] >= 972) b4_dir = 2'b11;
                    end*/
                //end
                //else b4_dir = ~b4_dir;
                
                b4_pos[10:0] = b4_dir[1] ?
                    b4_pos[10:0] - 3
                    : b4_pos[10:0] + 3;
                b4_pos[21:11] = b4_dir[0] ?
                    b4_pos[21:11] - 3
                    : b4_pos[21:11] + 3;
                b4_dir = ~b4_dir;
            end
        end
        movement_counter = movement_counter + 1;
    end
    
    //wire all_ball_condition = b1_condition | b2_condition | b3_condition | b4_condition;
    assign VGA_ball_colour[4:0] = b1_condition ? {1'b1, ball_colours[b1_colour][0:3]}
        : b2_condition ? {1'b1, ball_colours[b2_colour][0:3]}
        : b3_condition ? {1'b1, ball_colours[b3_colour][0:3]}
        : b4_condition ? {1'b1, ball_colours[b4_colour][0:3]}
        : {1'b0, 4'h0};
        
    assign VGA_ball_colour[9:5] = b1_condition ? {1'b1, ball_colours[b1_colour][4:7]}
        : b2_condition ? {1'b1, ball_colours[b2_colour][4:7]}
        : b3_condition ? {1'b1, ball_colours[b3_colour][4:7]}
        : b4_condition ? {1'b1, ball_colours[b4_colour][4:7]}
        : {1'b0, 4'h0};

    assign VGA_ball_colour[14:10] = b1_condition ? {1'b1, ball_colours[b1_colour][8:11]}
        : b2_condition ? {1'b1, ball_colours[b2_colour][8:11]}
        : b3_condition ? {1'b1, ball_colours[b3_colour][8:11]}
        : b4_condition ? {1'b1, ball_colours[b4_colour][8:11]}
        : {1'b0, 4'h0};
        
    assign VGA_ball_waveform[4:0] = wave_condition ? {1'b1, ball_colours[bar_colour][0:3]}
        : {1'b0, 4'h0};
    assign VGA_ball_waveform[9:5] = wave_condition ? {1'b1, ball_colours[bar_colour][4:7]}
        : {1'b0, 4'h0};
    assign VGA_ball_waveform[14:10] = wave_condition ? {1'b1, ball_colours[bar_colour][8:11]}
        : {1'b0, 4'h0};
endmodule
