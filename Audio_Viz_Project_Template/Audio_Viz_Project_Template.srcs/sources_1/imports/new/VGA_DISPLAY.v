`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// - VGA_HORZ_COORD changes at a rate of 108 MHz (CLK_VGA) to traverse each pixel in a row, while VGA_VERT_COORD changes at a rate of ~63.98 KHz to 
//   scan each row one by one and back to the top. These tech details are handled by vga_ctrl.vhd. One only needs to make use of these coordinates 
//   to output whatever they want at desired pixel locations. 
// 
// - VGA_ACTIVE is a binary indicator specifying when VGA_HORZ_COORD, VGA_VERT_COORD are valid (i.e., within the 1024 x 1280 pixel screen). For technical 
//   reasons the said coordinates do go outside this screen area for a short while and no VGA signal should be output during this time (it will and does
//   mess up the display). 
//
// - Hence, VGA_ACTIVE, VGA_HORZ_COORD and VGA_VERT_COORD may be used in conjunction with each other to generate VGA_RED, VGA_GREEN, VGA_BLUE. The Sync
//   signals should be output to the VGA port as well, and are responsible to generate the raster scan on the screen       
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA_DISPLAY(
    input CLK,
    output [11:0] VGA_HORZ_COORD,
    output [11:0] VGA_VERT_COORD, 
    output CLK_VGA,
    input [1:0] mode,
    input [14:0] VGA_mode_selector,
    
    output reg [3:0] VGA_RED, // RGB outputs to VGA connector (4 bits per channel gives 4096 possible colors)
    output reg [3:0] VGA_GREEN,
    output reg [3:0] VGA_BLUE,
    output reg VGA_VS, // horizontal & vertical sync outputs to VGA connector
    output reg VGA_HS,
    
    input [14:0] VGA_mode_one_text,
    input [14:0] VGA_mode_one_waveform,
    input [14:0] VGA_mode_one_tick,
    input [14:0] VGA_mode_one_grid,
    input [14:0] VGA_mode_one_back,    
    
    input [14:0] VGA_game_end_text,
    input [14:0] VGA_game_text,
    input [14:0] VGA_game_player,
    input [14:0] VGA_game_cliff,
    input [14:0] VGA_game_cloud,
    input [14:0] VGA_game_back,
    
    input [14:0] VGA_freq_text,
    input [14:0] VGA_freq_wave,
    input [14:0] VGA_freq_back,
    
    input [14:0] VGA_ball_text,
    input [14:0] VGA_ball_colour,
    input [14:0] VGA_ball_waveform,
    input [14:0] VGA_ball_back
    );   
    
    // VGA Clock Generator (108MHz)
    CLK_108M VGA_CLK_108M( 
        CLK,   // 100 MHz
        CLK_VGA     // 108 MHz
    );
    
    // COMBINE ALL OUTPUTS ON EACH CHANNEL
    wire [3:0] VGA_RED_CHAN = VGA_mode_selector[4] ? VGA_mode_selector[3:0]
        : (mode == 0) ?
            (VGA_mode_one_text[4] ? VGA_mode_one_text[3:0]
            : VGA_mode_one_waveform[4] ? VGA_mode_one_waveform[3:0]
            : VGA_mode_one_tick[4] ? VGA_mode_one_tick[3:0]
            : VGA_mode_one_grid[4] ? VGA_mode_one_grid[3:0]
            : VGA_mode_one_back[3:0])
        : (mode == 1) ?
            (VGA_game_end_text[4] ? VGA_game_end_text[3:0]
            : VGA_game_text[4] ? VGA_game_text[3:0]
            : VGA_game_player[4] ? VGA_game_player[3:0]
            : VGA_game_cliff[4] ? VGA_game_cliff[3:0]
            : VGA_game_cloud[4] ? VGA_game_cloud[3:0]
            : VGA_game_back[3:0])
        : (mode == 2) ?
            (VGA_freq_text[4] ? VGA_freq_text[3:0]
            : VGA_freq_wave[4] ? VGA_freq_wave[3:0]
            : VGA_freq_back[3:0])
        :
            (VGA_ball_text[4] ? VGA_ball_text[3:0]
            : VGA_ball_colour[4] ? VGA_ball_colour[3:0]
            : VGA_ball_waveform[4] ? VGA_ball_waveform[3:0]
            : VGA_ball_back[3:0]);
            
    wire [3:0] VGA_GREEN_CHAN = VGA_mode_selector[9] ? VGA_mode_selector[8:5]
        : (mode == 0) ?
            (VGA_mode_one_text[9] ? VGA_mode_one_text[8:5]
            : VGA_mode_one_waveform[9] ? VGA_mode_one_waveform[8:5]
            : VGA_mode_one_tick[9] ? VGA_mode_one_tick[8:5]
            : VGA_mode_one_grid[9] ? VGA_mode_one_grid[8:5]
            : VGA_mode_one_back[8:5])
        : (mode == 1) ?
            (VGA_game_end_text[9] ? VGA_game_end_text[8:5]
            : VGA_game_text[9] ? VGA_game_text[8:5]
            : VGA_game_player[9] ? VGA_game_player[8:5]
            : VGA_game_cliff[9] ? VGA_game_cliff[8:5]
            : VGA_game_cloud[9] ? VGA_game_cloud[8:5]
            : VGA_game_back[8:5])
        : (mode == 2) ?
            (VGA_freq_text[9] ? VGA_freq_text[8:5]
            : VGA_freq_wave[9] ? VGA_freq_wave[8:5]
            : VGA_freq_back[8:5])
        :
            (VGA_ball_text[9] ? VGA_ball_text[8:5]
            : VGA_ball_colour[9] ? VGA_ball_colour[8:5]
            : VGA_ball_waveform[9] ? VGA_ball_waveform[8:5]
            : VGA_ball_back[8:5]);
             
     wire [3:0] VGA_BLUE_CHAN = VGA_mode_selector[14] ? VGA_mode_selector[13:10]
        : (mode == 0) ?
            (VGA_mode_one_text[14] ? VGA_mode_one_text[13:10]
            : VGA_mode_one_waveform[14] ? VGA_mode_one_waveform[13:10]
            : VGA_mode_one_tick[14] ? VGA_mode_one_tick[13:10]
            : VGA_mode_one_grid[14] ? VGA_mode_one_grid[13:10]
            : VGA_mode_one_back[13:10])
        : (mode == 1) ?
            (VGA_game_end_text[14] ? VGA_game_end_text[13:10]
            : VGA_game_text[14] ? VGA_game_text[13:10]
            : VGA_game_player[14] ? VGA_game_player[13:10]
            : VGA_game_cliff[14] ? VGA_game_cliff[13:10]
            : VGA_game_cloud[14] ? VGA_game_cloud[13:10]
            : VGA_game_back[13:10])
        : (mode == 2) ?
            (VGA_freq_text[14] ? VGA_freq_text[13:10]
            : VGA_freq_wave[14] ? VGA_freq_wave[13:10]
            : VGA_freq_back[13:10])
        :
            (VGA_ball_text[14] ? VGA_ball_text[13:10]
            : VGA_ball_colour[14] ? VGA_ball_colour[13:10]
            : VGA_ball_waveform[14] ? VGA_ball_waveform[13:10]
            : VGA_ball_back[13:10]);   

    // VGA CONTROLLER   
    wire VGA_ACTIVE;
    wire VGA_HORZ_SYNC;
    wire VGA_VERT_SYNC; 
    
    VGA_CONTROL VGA_CONTROL(
            CLK_VGA,
            VGA_HORZ_SYNC,
            VGA_VERT_SYNC,
            VGA_ACTIVE,  
            VGA_HORZ_COORD,  
            VGA_VERT_COORD  
        ) ;

    // Do not touch this
    always@(posedge CLK_VGA) begin      
            VGA_RED <= {VGA_ACTIVE, VGA_ACTIVE, VGA_ACTIVE, VGA_ACTIVE} & VGA_RED_CHAN ;  
            VGA_GREEN <= {VGA_ACTIVE, VGA_ACTIVE, VGA_ACTIVE, VGA_ACTIVE} & VGA_GREEN_CHAN ; 
            VGA_BLUE <= {VGA_ACTIVE, VGA_ACTIVE, VGA_ACTIVE, VGA_ACTIVE} & VGA_BLUE_CHAN ; 
                // VGA_ACTIVE turns off output to screen if scan lines are outside the active screen area
            
            VGA_HS <= VGA_HORZ_SYNC ;
            VGA_VS <= VGA_VERT_SYNC ;
            
    end
endmodule
