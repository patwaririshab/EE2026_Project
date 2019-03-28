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
    output [3:0] VGA_Blue_Grid
    );
    
// The code below draws two grid lines. Modify the codes to draw more grid lines. 
    wire Condition_For_Grid = (VGA_HORZ_COORD == 800) ||  (VGA_VERT_COORD == 250) ;


// Using the gridline example, insert your code below to draw ticks on the x-axis and y-axis.
    wire Condition_For_Ticks;


    
// Please modify below codes to change the background color and to display ticks defined above
    assign VGA_Red_Grid = Condition_For_Grid ? 4'h0 : 4'h0 ;
    assign VGA_Green_Grid = Condition_For_Grid ? 4'hD : 4'h0 ;
    assign VGA_Blue_Grid = Condition_For_Grid ? 4'h0 : 4'h0 ;
                            // if true, a red pixel is put at coordinates (VGA_HORZ_COORD, VGA_VERT_COORD), 
     
endmodule
