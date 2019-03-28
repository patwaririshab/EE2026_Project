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
    
    output [11:0] VGA_HORZ_COORD,
    output [11:0] VGA_VERT_COORD, 

    output reg[3:0] VGA_RED,    // RGB outputs to VGA connector (4 bits per channel gives 4096 possible colors)
    output reg[3:0] VGA_GREEN,
    output reg[3:0] VGA_BLUE,
    output reg VGA_VS,          // horizontal & vertical sync outputs to VGA connector
    output reg VGA_HS

    );
    
    
    // COMBINE ALL OUTPUTS ON EACH CHANNEL
    wire[3:0] VGA_RED_CHAN = VGA_RED_GRID | VGA_RED_WAVEFORM ;
    wire[3:0] VGA_GREEN_CHAN = VGA_GREEN_GRID | VGA_GREEN_WAVEFORM ; 
    wire[3:0] VGA_BLUE_CHAN = VGA_BLUE_GRID | VGA_BLUE_WAVEFORM;   
    
    
    // VGA Clock Generator (108MHz)
    wire CLK_VGA;
    CLK_108M VGA_CLK_108M( 
            CLK,   // 100 MHz
            CLK_VGA     // 108 MHz
        ) ; 
        
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
