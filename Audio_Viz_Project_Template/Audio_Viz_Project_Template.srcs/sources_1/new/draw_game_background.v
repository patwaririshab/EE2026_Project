`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2019 05:03:24
// Design Name: 
// Module Name: draw_game_background
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


module draw_game_background(
    input CLK_VGA,
    input freq_20kHz,
    
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    output [3:0] VGA_game_red_back,
    output [3:0] VGA_game_green_back,
    output [3:0] VGA_game_blue_back,
    
    output [3:0] VGA_game_red_end,
    output [3:0] VGA_game_green_end,
    output [3:0] VGA_game_blue_end,
    
    output [3:0] VGA_game_red_waveform,
    output [3:0] VGA_game_green_waveform,
    output [3:0] VGA_game_blue_waveform,
    
    input [1:0] mode,
    input game_running,
    input restart,
    input start_recording,
    
    input [9:0] draw_sound
    );
    
//       reg [9:0] recorded_wave [1279:0];
//       reg [3:0] i = 0;
       //reg [24:0] recording_counter = 0; 
//    always @ (posedge CLK_VGA) begin
//        if (start_recording == 1 && i <= 1279) begin
//            if (recording_counter[24] == 1) begin
//                recorded_wave[i] = draw_sound;
//                recording_counter = 0;
//                i = i + 128;
//            end
//            recording_counter = recording_counter + 1;
//        end 
//    end
    
//    reg freq_slow;
//    reg [3:0] slow_counter = 0;
//    always @ (posedge CLK_VGA) begin
//        slow_counter <= (slow_counter[3] == 1) ? 0: slow_counter + 1;
//        freq_slow <= (slow_counter == 0) ? ~freq_slow : freq_slow;
//    end
    
    reg [9:0] recorded_wave [1279:0];
    reg [11:0] i = 0;
    reg [10:0] recording_counter = 0; 
    always @ (posedge CLK_VGA) begin
        if (recording_counter[10] == 1) begin
            if (restart == 1) begin
                i = 0;
            end
            else if (start_recording == 1) begin
                i <= (i == 1279) ? 0 : i + 1;
                recorded_wave[i] <= draw_sound;
            end
            recording_counter = 0;
        end
        recording_counter = recording_counter + 1;
    end
    
    wire [11:0] temp_cur_horz;
    assign temp_cur_horz = VGA_HORZ_COORD;
    //assign obstacle_condition = (VGA_HORZ_COORD % 128 == 0) && (VGA_HORZ_COORD % 128 <= 75) && (VGA_VERT_COORD >= 1024 - recorded_wave[VGA_HORZ_COORD]);   
    
    //Creates 10 bars of width 50%, determined by the horizontal coordinates, and vertical coordinates determined by recorded wave     
    wire obstacle_condition = VGA_VERT_COORD >= 950 && (VGA_HORZ_COORD % 128 <= 100) && VGA_HORZ_COORD < 1280 && (VGA_VERT_COORD >= 1500 - recorded_wave[VGA_HORZ_COORD]);  
    
    reg game_over = 0;
    reg game_won = 0;
    
    wire game_dialog_condition = (VGA_HORZ_COORD > 500 && VGA_HORZ_COORD < 780) &&
        (VGA_VERT_COORD > 490 && VGA_VERT_COORD < 534);
    wire game_dialog_outline = (VGA_HORZ_COORD == 500 && (VGA_VERT_COORD >= 490 && VGA_VERT_COORD <= 534)) ||
        (VGA_HORZ_COORD == 780 && (VGA_VERT_COORD >= 490 && VGA_VERT_COORD <= 534)) ||
        (VGA_VERT_COORD == 490 && (VGA_HORZ_COORD >= 500 && VGA_HORZ_COORD <= 780)) ||
        (VGA_VERT_COORD == 534 && (VGA_HORZ_COORD >= 500 && VGA_HORZ_COORD <= 780));
    wire game_over_text;
    Pixel_On_text2 #(.displayText("Oh no! You Lost!")) got (
        CLK_VGA,
        580, // text position.x (top left)
        512, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        game_over_text  // result, 1 if current pixel is on text, 0 otherwise
    );
    wire game_won_text;
    Pixel_On_text2 #(.displayText("Congratulations! You won!")) gwt (
        CLK_VGA,
        580, // text position.x (top left)
        512, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        game_won_text  // result, 1 if current pixel is on text, 0 otherwise
    );
    
    wire text_condition;
    Pixel_On_text2 #(.displayText("HP")) hp_bar_text (
        CLK_VGA,
        1090, // text position.x (top left)
        15, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        text_condition  // result, 1 if current pixel is on text, 0 otherwise
    );
    
    // Cloud movement code
    reg [10:0] cloud_horz_lower [0:5];
    reg [10:0] cloud_horz_upper [0:5];
    initial begin
        cloud_horz_lower[0] = 600; cloud_horz_upper[0] = 800;
        cloud_horz_lower[1] = 200; cloud_horz_upper[1] = 500;
        cloud_horz_lower[2] = 800; cloud_horz_upper[2] = 950;
        cloud_horz_lower[3] = 400; cloud_horz_upper[3] = 500;
        cloud_horz_lower[4] = 0; cloud_horz_upper[4] = 50;
        cloud_horz_lower[5] = 1100; cloud_horz_upper[5] = 1280;
    end
    reg [24:0] cloud_move_counter = 0;
    always @ (posedge CLK_VGA) begin
        if (restart == 1) begin
            cloud_horz_lower[0] = 600; cloud_horz_upper[0] = 800;
            cloud_horz_lower[1] = 200; cloud_horz_upper[1] = 500;
            cloud_horz_lower[2] = 800; cloud_horz_upper[2] = 950;
            cloud_horz_lower[3] = 400; cloud_horz_upper[3] = 500;
            cloud_horz_lower[4] = 0; cloud_horz_upper[4] = 50;
            cloud_horz_lower[5] = 1100; cloud_horz_upper[5] = 1280;
        end
        else if (mode == 1 && game_running == 1 && (game_over == 0 && game_won == 0)) begin
            if (cloud_move_counter[24] == 1) begin
                cloud_move_counter = 0; 
                cloud_horz_lower[0] = (cloud_horz_lower[0] + 2);
                cloud_horz_upper[0] = (cloud_horz_upper[0] + 2);
                cloud_horz_lower[1] = (cloud_horz_lower[1] + 2);
                cloud_horz_upper[1] = (cloud_horz_upper[1] + 2); 
                cloud_horz_lower[2] = (cloud_horz_lower[2] - 2);
                cloud_horz_upper[2] = (cloud_horz_upper[2] - 2);
                cloud_horz_lower[3] = (cloud_horz_lower[3] - 2);
                cloud_horz_upper[3] = (cloud_horz_upper[3] - 2);
                cloud_horz_lower[4] = (cloud_horz_lower[4] + 2);
                cloud_horz_upper[4] = (cloud_horz_upper[4] + 2);
                cloud_horz_lower[5] = (cloud_horz_lower[5] - 2);
                cloud_horz_upper[5] = (cloud_horz_upper[5] - 2);
            end
            cloud_move_counter = cloud_move_counter + 1;
        end
    end
    wire [5:0] cloud_condition;
    assign cloud_condition[0] = (VGA_HORZ_COORD > cloud_horz_lower[0] && VGA_HORZ_COORD < cloud_horz_upper[0]) &&
        (VGA_VERT_COORD > 100 && VGA_VERT_COORD < 150);
    assign cloud_condition[1] = (VGA_HORZ_COORD > cloud_horz_lower[1] && VGA_HORZ_COORD < cloud_horz_upper[1]) &&
        (VGA_VERT_COORD > 300 && VGA_VERT_COORD < 375);
    assign cloud_condition[2] = (VGA_HORZ_COORD > cloud_horz_lower[2] && VGA_HORZ_COORD < cloud_horz_upper[2]) &&
        (VGA_VERT_COORD > 150 && VGA_VERT_COORD < 220);
    assign cloud_condition[3] = (VGA_HORZ_COORD > cloud_horz_lower[3] && VGA_HORZ_COORD < cloud_horz_upper[3]) &&
        (VGA_VERT_COORD > 50 && VGA_VERT_COORD < 100);
    assign cloud_condition[4] = (VGA_HORZ_COORD > cloud_horz_lower[4] && VGA_HORZ_COORD < cloud_horz_upper[4]) &&
        (VGA_VERT_COORD > 300 && VGA_VERT_COORD < 350);
    assign cloud_condition[5] = (VGA_HORZ_COORD > cloud_horz_lower[5] && VGA_HORZ_COORD < cloud_horz_upper[5]) &&
        (VGA_VERT_COORD > 200 && VGA_VERT_COORD < 275);
    wire final_cloud_condition = |cloud_condition[5:0];
    
    wire game_end_condition;
    assign game_end_condition = ((VGA_HORZ_COORD == 1279) & ~obstacle_condition);
    
    // Player position and stuff
    reg [20:0] player_horz_counter = 0;
    reg [11:0] player_horz_lower = 15;
    reg [11:0] player_horz_upper = 35;
    reg [11:0] player_vert_lower = 100;
    reg [11:0] player_vert_upper = 120;    
    // HP bar
    reg [11:0] HP = 1265;
    wire inner_bar_condition = (VGA_HORZ_COORD > 1115 && VGA_HORZ_COORD < HP) && 
        (VGA_VERT_COORD > 15 && VGA_VERT_COORD < 30);
    wire outer_bar_condition = (VGA_HORZ_COORD == 1115 && (VGA_VERT_COORD >= 15 && VGA_VERT_COORD <= 30)) ||
        (VGA_HORZ_COORD == 1265 && (VGA_VERT_COORD >= 15 && VGA_VERT_COORD <= 30)) ||
        (VGA_VERT_COORD == 15 && (VGA_HORZ_COORD >= 1115 && VGA_HORZ_COORD <= 1265)) ||
        (VGA_VERT_COORD == 30 && (VGA_HORZ_COORD >= 1115 && VGA_HORZ_COORD <= 1265));
    // Player movement
    wire player_condition = (VGA_HORZ_COORD > player_horz_lower && VGA_HORZ_COORD < player_horz_upper) &&
        (VGA_VERT_COORD > player_vert_lower && VGA_VERT_COORD < player_vert_upper); 
    always @ (posedge CLK_VGA) begin
        if (restart == 1) begin
           player_horz_lower = 15;
           player_horz_upper = 35;
           player_vert_lower = 100;
           player_vert_upper = 120;
           game_over = 0;
           game_won = 0;
           HP = 1265;
           //recorded_wave[0] = 0;
           //recorded_wave[128] = 0;
           //recorded_wave[256] = 0;
           //recorded_wave[384] = 0;
           //recorded_wave[512] = 0;
           //recorded_wave[640] = 0;
           //recorded_wave[768] = 0;
           //recorded_wave[896] = 0;
           //recorded_wave[1024] = 0;
           //recorded_wave[1152] = 0;
        end
        else if (mode == 1 && game_running == 1 && (game_over == 0 && game_won == 0)) begin
            if (player_horz_counter[20] == 1) begin
                player_horz_counter = 0;
                player_horz_lower = player_horz_lower + 1;
                player_horz_upper = player_horz_upper + 1;
                player_vert_lower = player_vert_lower + 6;
                player_vert_upper = player_vert_upper + 6;
            end
            player_horz_counter = player_horz_counter + 1;
            
            if (player_condition & obstacle_condition == 1) begin
                HP = HP - 30;
                if (HP <= 1116) begin
                     game_over = 1;     
                end
                player_horz_lower = 15;
                player_horz_upper = 35;
                player_vert_lower = 100;
                player_vert_upper = 120;
            end
            else if (player_condition & game_end_condition == 1) begin
                game_won = 1;
            end
        end
    end
  
    // Final game output channels
    assign VGA_game_red_back = text_condition ? 4'hF : (player_condition ? 4'hF :
        (final_cloud_condition ? 4'he : 
            (inner_bar_condition ? 4'h0 : 
                (outer_bar_condition ? 4'hF : 4'h4))));
    assign VGA_game_green_back = text_condition ? 4'hF : (player_condition ? 4'h0 :
        (final_cloud_condition ? 4'he : 
            (inner_bar_condition ? 4'hF : 
                (outer_bar_condition ? 4'hF : 4'h9))));
    assign VGA_game_blue_back = text_condition ? 4'hF : (player_condition ? 4'h0 :
        (final_cloud_condition ? 4'he : 
            (inner_bar_condition ? 4'h0 : 
                (outer_bar_condition ? 4'hF : 4'hD))));
                    
    assign VGA_game_red_end = (game_won == 1) ? (game_won_text ? 4'hF : (game_dialog_condition ? 4'h9 : (game_dialog_outline ? 4'hF : 0))) : 
        (game_over == 1) ? (game_over_text ? 4'hF : (game_dialog_condition ? 4'h9 : (game_dialog_outline ? 4'hF : 0))) : 0;
    assign VGA_game_green_end = (game_won == 1) ? (game_won_text ? 4'hF : (game_dialog_condition ? 4'h9 : (game_dialog_outline ? 4'hF : 0))) : 
        (game_over == 1) ? (game_over_text ? 4'hF : (game_dialog_condition ? 4'h9 : (game_dialog_outline ? 4'hF : 0))) : 0;
    assign VGA_game_blue_end = (game_won == 1) ? (game_won_text ? 4'hF : (game_dialog_condition ? 4'h9 : (game_dialog_outline ? 4'hF : 0))) : 
        (game_over == 1) ? (game_over_text ? 4'hF : (game_dialog_condition ? 4'h9 : (game_dialog_outline ? 4'hF : 0))) : 0;                 
    
    assign VGA_game_red_waveform = obstacle_condition ? 4'hE : 0;
    assign VGA_game_green_waveform = obstacle_condition ? 4'h5 : 0;
    assign VGA_game_blue_waveform = obstacle_condition ? 4'h3 : 0;
endmodule
