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


module draw_game(
    input CLK_VGA,
    input freq_20kHz,
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    output [14:0] VGA_game_end_text,
    output [14:0] VGA_game_player,
    output [14:0] VGA_game_cliff,
    output [14:0] VGA_game_cloud,
    
    input [1:0] mode,
    input game_running,
    input restart,
    input start_recording,
    input [9:0] draw_sound,
    
    input [11:0] cur_volume
    );
    
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
    
    //Creates 10 bars of width 50%, determined by the horizontal coordinates, and vertical coordinates determined by recorded wave     
    wire obstacle_condition = //(VGA_HORZ_COORD >= 0 && VGA_VERT_COORD >= 180 && VGA_VERT_COORD <= 240) ||
        (VGA_HORZ_COORD % 128 <= 100)
        && VGA_HORZ_COORD < 1280 && (VGA_VERT_COORD >= 1500 - recorded_wave[VGA_HORZ_COORD]);
    wire floor_condition = VGA_VERT_COORD > 950;
    
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
        505, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        game_over_text  // result, 1 if current pixel is on text, 0 otherwise
    );
    wire game_won_text;
    Pixel_On_text2 #(.displayText("Congratulations! You won!")) gwt (
        CLK_VGA,
        540, // text position.x (top left)
        505, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        game_won_text  // result, 1 if current pixel is on text, 0 otherwise
    );
    wire hp_condition;
    Pixel_On_text2 #(.displayText("HP")) hp_bar_text (
        CLK_VGA,
        1090, // text position.x (top left)
        15, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        hp_condition  // result, 1 if current pixel is on text, 0 otherwise
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
        //else if (mode == 1 && game_running == 1 && (game_over == 0 && game_won == 0)) begin
        if (mode == 1) begin
            if (cloud_move_counter[24] == 1) begin
                cloud_move_counter = 0; 
                cloud_horz_lower[0] = (cloud_horz_lower[0] + 1);
                cloud_horz_upper[0] = (cloud_horz_upper[0] + 1);
                cloud_horz_lower[1] = (cloud_horz_lower[1] + 3);
                cloud_horz_upper[1] = (cloud_horz_upper[1] + 3); 
                cloud_horz_lower[2] = (cloud_horz_lower[2] - 2);
                cloud_horz_upper[2] = (cloud_horz_upper[2] - 2);
                cloud_horz_lower[3] = (cloud_horz_lower[3] - 1);
                cloud_horz_upper[3] = (cloud_horz_upper[3] - 1);
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
    
    // PLAYER STUFF
    reg [7:0] player_char [0:899];
    reg [7:0] hill [0:38808];
    initial begin
        $readmemh ("player.mem", player_char);
        $readmemh ("hill.mem", hill);
    end
    
    reg [11:0] hill_horz_lower = 400;
    reg [11:0] hill_horz_upper = 597;
    reg [11:0] hill_vert_lower = 753;
    reg [11:0] hill_vert_upper = 950;  
    wire hill_condition = (VGA_HORZ_COORD >= hill_horz_lower && VGA_HORZ_COORD < hill_horz_upper) &&
        (VGA_VERT_COORD >= hill_vert_lower && VGA_VERT_COORD < hill_vert_upper);
    
    // Player position and stuff
    reg [20:0] player_horz_counter = 0;
    reg [11:0] player_horz_lower = 5;
    reg [11:0] player_horz_upper = 35;
    reg [11:0] player_vert_lower = 320;
    reg [11:0] player_vert_upper = 350;   
    // HP bar
    reg [11:0] HP = 1265;
    reg jumped = 0;
    reg [23:0] jump_counter = 0;
    wire inner_bar_condition = (VGA_HORZ_COORD > 1115 && VGA_HORZ_COORD < HP) && 
        (VGA_VERT_COORD > 15 && VGA_VERT_COORD < 30);
    wire outer_bar_condition = (VGA_HORZ_COORD == 1115 && (VGA_VERT_COORD >= 15 && VGA_VERT_COORD <= 30)) ||
        (VGA_HORZ_COORD == 1265 && (VGA_VERT_COORD >= 15 && VGA_VERT_COORD <= 30)) ||
        (VGA_VERT_COORD == 15 && (VGA_HORZ_COORD >= 1115 && VGA_HORZ_COORD <= 1265)) ||
        (VGA_VERT_COORD == 30 && (VGA_HORZ_COORD >= 1115 && VGA_HORZ_COORD <= 1265));
    // Player movement
    wire player_condition = (VGA_HORZ_COORD >= player_horz_lower && VGA_HORZ_COORD < player_horz_upper) &&
        (VGA_VERT_COORD >= player_vert_lower && VGA_VERT_COORD < player_vert_upper); 
    always @ (posedge CLK_VGA) begin
        if (restart == 1) begin
           player_horz_lower = 5;
           player_horz_upper = 35;
           player_vert_lower = 320;
           player_vert_upper = 350;
           game_over = 0;
           game_won = 0;
           HP = 1265;
        end
        else if (mode == 1 && game_running == 1 && (game_over == 0 && game_won == 0)) begin
            if (jumped == 1) begin
                if (jump_counter[23] == 1) begin
                    jumped = 0;
                    jump_counter = 0;
                end
                jump_counter = jump_counter + 1;
            end
            else if (cur_volume >= 256 && jumped == 0) begin
                jumped = 1; 
            end
            
            if (player_horz_counter[20] == 1) begin
                player_horz_counter = 0;
                player_horz_lower = player_horz_lower + 1;
                player_horz_upper = player_horz_upper + 1;
                if (jumped == 1) begin
                    player_vert_lower = player_vert_lower - 3;
                    player_vert_upper = player_vert_upper - 3;
                end
                else begin
                    player_vert_lower = player_vert_lower + 2;
                    player_vert_upper = player_vert_upper + 2;
                end  
            end
            player_horz_counter = player_horz_counter + 1;
            
            if (player_condition & obstacle_condition == 1) begin
                HP = HP - 50;
                if (HP <= 1116) begin
                     game_over = 1;     
                end
                player_horz_lower = 5;
                player_horz_upper = 35;
                player_vert_lower = 320;
                player_vert_upper = 350;
            end
            else if (player_condition & game_end_condition == 1) begin
                game_won = 1;
            end
        end
    end
    
    assign VGA_game_end_text[4:0] = hp_condition ? {1'b1, 4'hF}
        : inner_bar_condition ? {1'b1, 4'h0}
        : outer_bar_condition ? {1'b1, 4'hF}
        : (game_won == 1) ?
           (game_won_text ? {1'b1, 4'hF}
           : game_dialog_condition ? {1'b1, 4'h0}
           : game_dialog_outline ? {1'b1, 4'hF}
           : {1'b0, 4'h0})
        : (game_over == 1) ?
            (game_over_text ? {1'b1, 4'hF}
            : game_dialog_condition ? {1'b1, 4'h0}
            : game_dialog_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0})
        : {1'b0, 4'h0};   
    assign VGA_game_end_text[9:5] = hp_condition ? {1'b1, 4'hF}
        : inner_bar_condition ? {1'b1, 4'hF}
        : outer_bar_condition ? {1'b1, 4'hF}
        : (game_won == 1) ?
           (game_won_text ? {1'b1, 4'hF}
           : game_dialog_condition ? {1'b1, 4'h0}
           : game_dialog_outline ? {1'b1, 4'hF}
           : {1'b0, 4'h0})
        : (game_over == 1) ?
            (game_over_text ? {1'b1, 4'hF}
            : game_dialog_condition ? {1'b1, 4'h0}
            : game_dialog_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0})
        : {1'b0, 4'h0};
    assign VGA_game_end_text[14:10] = hp_condition ? {1'b1, 4'hF}
        : inner_bar_condition ? {1'b1, 4'h0}
        : outer_bar_condition ? {1'b1, 4'hF}
        : (game_won == 1) ?
           (game_won_text ? {1'b1, 4'hF}
           : game_dialog_condition ? {1'b1, 4'h0}
           : game_dialog_outline ? {1'b1, 4'hF}
           : {1'b0, 4'h0})
        : (game_over == 1) ?
            (game_over_text ? {1'b1, 4'hF}
            : game_dialog_condition ? {1'b1, 4'h0}
            : game_dialog_outline ? {1'b1, 4'hF}
            : {1'b0, 4'h0})
        : {1'b0, 4'h0};
    
    wire [9:0] player_char_point;
    assign player_char_point = ((VGA_VERT_COORD - player_vert_lower) * 30) + (VGA_HORZ_COORD - player_horz_lower);
    
    assign VGA_game_player[4:0] = player_condition ? 
        (player_char[player_char_point] == 8'b00000111 ? {1'b0, 4'h0} : {1'b1, player_char[player_char_point][2:0], 1'b1})
        : {1'b0, 4'h0};
    assign VGA_game_player[9:5] = player_condition ? 
        (player_char[player_char_point] == 8'b00000111 ? {1'b0, 4'h0} : {1'b1, player_char[player_char_point][5:3], 1'b1})
        : {1'b0, 4'h0};
    assign VGA_game_player[14:10] = player_condition ?
        (player_char[player_char_point] == 8'b00000111 ? {1'b0, 4'h0} : {1'b1, player_char[player_char_point][7:6], 2'b11})
        : {1'b0, 4'h0};
    
    wire [15:0] hill_point;
    assign hill_point = ((VGA_VERT_COORD - hill_vert_lower) * 197) + (VGA_HORZ_COORD - hill_horz_lower);
    assign VGA_game_cliff[4:0] = VGA_VERT_COORD == 950 ? 
        {1'b1, 4'h0} : floor_condition ?
        {1'b1, 4'b0101} 
        : hill_condition ? (hill[hill_point] == 8'b00000111 ? 
        obstacle_condition ? {1'b1, 4'hb} : {1'b0, 4'h0}
        : {1'b1, hill[hill_point][2:0], 1'b1})
        : obstacle_condition ? 
        {1'b1, 4'hb} : {1'b0, 4'h0};
        
    assign VGA_game_cliff[9:5] = VGA_VERT_COORD == 950 ?
        {1'b1, 4'h0} : floor_condition ?
        {1'b1, 4'b1101} 
        : hill_condition ? (hill[hill_point] == 8'b00000111 ? 
        obstacle_condition ? {1'b1, 4'h6} : {1'b0, 4'h0}
        : {1'b1, hill[hill_point][5:3], 1'b1})
        : obstacle_condition ? 
        {1'b1, 4'h6} : {1'b0, 4'h0};
        
    assign VGA_game_cliff[14:10] = VGA_VERT_COORD == 950 ?
        {1'b1, 4'h0} : floor_condition ?
        {1'b1, 4'b0111} 
        : hill_condition ? (hill[hill_point] == 8'b00000111 ? 
        obstacle_condition ? {1'b1, 4'h2} : {1'b0, 4'h0}
        : {1'b1, hill[hill_point][7:6], 2'b11})
        : obstacle_condition ? 
        {1'b1, 4'h2} : {1'b0, 4'h0};
    
    assign VGA_game_cloud[4:0] = final_cloud_condition ? {1'b1, 4'hF} : {1'b0, 4'h0};
    assign VGA_game_cloud[9:5] = final_cloud_condition ? {1'b1, 4'hF} : {1'b0, 4'h0};
    assign VGA_game_cloud[14:10] = final_cloud_condition ? {1'b1, 4'hF} : {1'b0, 4'h0};
endmodule
