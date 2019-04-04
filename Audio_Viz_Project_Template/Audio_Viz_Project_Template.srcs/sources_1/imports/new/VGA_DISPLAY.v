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

    input [3:0] VGA_RED_WAVEFORM, 
    input [3:0] VGA_GREEN_WAVEFORM, 
    input [3:0] VGA_BLUE_WAVEFORM,
    
    input [3:0] VGA_RED_GRID,
    input [3:0] VGA_GREEN_GRID,
    input [3:0] VGA_BLUE_GRID,
    
    input [3:0] VGA_red_text,
    input [3:0] VGA_green_text,
    input [3:0] VGA_blue_text,
    
    output [11:0] VGA_HORZ_COORD,
    output [11:0] VGA_VERT_COORD, 

    output reg[3:0] VGA_RED,    // RGB outputs to VGA connector (4 bits per channel gives 4096 possible colors)
    output reg[3:0] VGA_GREEN,
    output reg[3:0] VGA_BLUE,
    output reg VGA_VS,          // horizontal & vertical sync outputs to VGA connector
    output reg VGA_HS,

    output CLK_VGA,
    input [1:0] mode,
    
    input [3:0] VGA_game_red_back,
    input [3:0] VGA_game_green_back,
    input [3:0] VGA_game_blue_back,
    input [3:0] VGA_game_red_text,
    input [3:0] VGA_game_green_text,
    input [3:0] VGA_game_blue_text,
    input [3:0] VGA_game_red_end,
    input [3:0] VGA_game_green_end,
    input [3:0] VGA_game_blue_end,
    input [3:0] VGA_game_red_waveform,
    input [3:0] VGA_game_green_waveform,
    input [3:0] VGA_game_blue_waveform,
    input [3:0] VGA_red_visualize, 
    input [3:0] VGA_green_visualize, 
    input [3:0] VGA_blue_visualize
    );
    
    //wire [100*8:0] test_string = "hahaha";
    
    // VGA Clock Generator (108MHz)
    //wire CLK_VGA;
    CLK_108M VGA_CLK_108M( 
        CLK,   // 100 MHz
        CLK_VGA     // 108 MHz
    );
    
    wire mode_condition0;
    Pixel_On_text2 #(.displayText("Mode: Waveform")) mc0 (
        CLK_VGA,
        1150, // text position.x (top left)
        1000, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        mode_condition0  // result, 1 if current pixel is on text, 0 otherwise
    );
    wire mode_condition1;
    Pixel_On_text2 #(.displayText("Mode: Game")) mc1 (
        CLK_VGA,
        1150, // text position.x (top left)
        1000, // text position.y (top left)
        VGA_HORZ_COORD, // current position.x
        VGA_VERT_COORD, // current position.y
        mode_condition1  // result, 1 if current pixel is on text, 0 otherwise
    );
    wire mode_box_condition = (VGA_HORZ_COORD > 1150) && (VGA_VERT_COORD > 950);
    
    wire [3:0] VGA_red_mode_label = (mode == 0) ? (mode_condition0 ? 4'hF : (mode_box_condition ? 4'hF : 0)) : (mode_condition1 ? 4'hF : (mode_box_condition ? 4'hF : 0)); 
    wire [3:0] VGA_green_mode_label = (mode == 0) ? (mode_condition0 ? 4'hF : (mode_box_condition ? 4'h0 : 0)) : (mode_condition1 ? 4'hF : (mode_box_condition ? 4'h0 : 0)); 
    wire [3:0] VGA_blue_mode_label = (mode == 0) ? (mode_condition0 ? 4'hF : (mode_box_condition ? 4'h0 : 0)) : (mode_condition1 ? 4'hF : (mode_box_condition ? 4'h0 : 0)); 
    
    // COMBINE ALL OUTPUTS ON EACH CHANNEL
    wire[3:0] VGA_RED_CHAN =
          (mode == 0) ? (VGA_RED_GRID | VGA_RED_WAVEFORM | VGA_red_text | VGA_red_mode_label) 
        : (mode == 1) ? (VGA_game_red_back | VGA_game_red_text | VGA_game_red_end | VGA_game_red_waveform | VGA_red_mode_label)
        : (VGA_red_visualize | VGA_red_mode_label);
    wire[3:0] VGA_GREEN_CHAN = 
          (mode == 0) ? (VGA_GREEN_GRID | VGA_GREEN_WAVEFORM | VGA_green_text | VGA_green_mode_label) 
        : (mode == 1) ? (VGA_game_green_back | VGA_game_green_text | VGA_game_green_end | VGA_game_green_waveform | VGA_green_mode_label) 
        : (VGA_green_visualize | VGA_green_mode_label); 
        
    wire[3:0] VGA_BLUE_CHAN = 
          (mode == 0) ? (VGA_BLUE_GRID | VGA_BLUE_WAVEFORM | VGA_blue_text | VGA_blue_mode_label) 
        : (mode == 1) ? (VGA_game_blue_back | VGA_game_blue_text | VGA_game_blue_end | VGA_game_blue_waveform | VGA_blue_mode_label)
        : (VGA_blue_visualize | VGA_blue_mode_label);   
        
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

    
    // CLOCK THEM OUT
    always@(posedge CLK_VGA) begin      
        
            VGA_RED <= {VGA_ACTIVE, VGA_ACTIVE, VGA_ACTIVE, VGA_ACTIVE} & VGA_RED_CHAN ;  
            VGA_GREEN <= {VGA_ACTIVE, VGA_ACTIVE, VGA_ACTIVE, VGA_ACTIVE} & VGA_GREEN_CHAN ; 
            VGA_BLUE <= {VGA_ACTIVE, VGA_ACTIVE, VGA_ACTIVE, VGA_ACTIVE} & VGA_BLUE_CHAN ; 
                // VGA_ACTIVE turns off output to screen if scan lines are outside the active screen area
            
            VGA_HS <= VGA_HORZ_SYNC ;
            VGA_VS <= VGA_VERT_SYNC ;
            
    end
    

endmodule
