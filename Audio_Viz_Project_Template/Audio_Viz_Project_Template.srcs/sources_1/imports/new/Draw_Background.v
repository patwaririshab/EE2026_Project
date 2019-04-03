`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------  
//                  DRAWING GRID LINES AND TICKS ON SCREEN
// Description:
// Grid lines are drawn at pixel # 320 along the x-axis, and
// pixel #768 along the y-axis

// Note the VGA controller is configured to produce a 1024 x 1280 pixel resolution
//-------------------------------------------------------------------------

//-------------------------------------------------------------------------
// TOOD:    Draw grid lines at every 80-th pixel along the horizontal axis, and every 64th pixel
//          along the vertical axis. This gives us a 16x16 grid on screen. 
//          
//          Further draw ticks on the central x and y grid lines spaced 16 and 8 pixels apart in the 
//          horizontal and vertical directions respectively. This gives us 5 sub-divisions per division 
//          in the horizontal and 8 sub-divisions per divsion in the vertical direction   
//-------------------------------------------------------------------------  
  
//////////////////////////////////////////////////////////////////////////////////


module Draw_Background(
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    output [3:0] VGA_Red_Grid,
    output [3:0] VGA_Green_Grid,
    output [3:0] VGA_Blue_Grid,
    
    input grid_switch,
    input tick_switch,
    input axes_switch,
    
    input [11:0] cur_theme_axes,
    input [11:0] cur_theme_grid,
    input [11:0] cur_theme_tick,
    input [11:0] cur_theme_background
    );
    
// The code below draws two grid lines. Modify the codes to draw more grid lines. 
    wire Condition_For_Grid = grid_switch ? ((VGA_HORZ_COORD % 80 == 0) ||  (VGA_VERT_COORD % 64 == 0)) : 0;
    wire Condition_For_Axes = axes_switch ? ((VGA_HORZ_COORD == 640) || (VGA_VERT_COORD == 512)) : 0; 

// Using the gridline example, insert your code below to draw ticks on the x-axis and y-axis.
    wire Condition_For_Ticks = tick_switch ? (((VGA_HORZ_COORD % 10 == 0) && ((VGA_VERT_COORD < 518) && (VGA_VERT_COORD > 506))) ||
        ((VGA_VERT_COORD % 8 == 0) && ((VGA_HORZ_COORD < 646) && (VGA_HORZ_COORD > 634)))) : 0;
    
// Please modify below codes to change the background color and to display ticks defined above
    assign VGA_Red_Grid = (Condition_For_Ticks ? cur_theme_tick[3:0] : (Condition_For_Axes ? cur_theme_axes[3:0] : (Condition_For_Grid ? cur_theme_grid[3:0] : cur_theme_background[3:0])));
    assign VGA_Green_Grid = (Condition_For_Ticks ? cur_theme_tick[7:4] : (Condition_For_Axes ? cur_theme_axes[7:4] : (Condition_For_Grid ? cur_theme_grid[7:4] : cur_theme_background[7:4])));
    assign VGA_Blue_Grid = (Condition_For_Ticks ? cur_theme_tick[11:8] : (Condition_For_Axes ? cur_theme_axes[11:8] : (Condition_For_Grid ? cur_theme_grid[11:8] : cur_theme_background[11:8])));
                            // if true, a red pixel is put at coordinates (VGA_HORZ_COORD, VGA_VERT_COORD), 
endmodule
