`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// You may study and modify the code inside this module to imporve the display feature or introduce other features
//////////////////////////////////////////////////////////////////////////////////

module Draw_Waveform(
    input clk_sample, //20kHz clock

    input [9:0] wave_sample,
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    output [3:0] VGA_Red_waveform,
    output [3:0] VGA_Green_waveform,
    output [3:0] VGA_Blue_waveform,
    
    input wave_switch,
    input pause_switch,
    
    input [11:0] cur_theme_wave,
    input [11:0] cur_theme_background
    );
    
    //The Sample_Memory represents the memory array used to store the voice samples.
    //There are 1280 points and each point can range from 0 to 1023. 
    reg [9:0] Sample_Memory[1279:0];
    reg [10:0] i = 0;
    
    //Each wave_sample is displayed on the screen from left to right. 
    always @ (posedge clk_sample) begin
        if (pause_switch == 0) begin
            i = (i==1279) ? 0 : i + 1;
            Sample_Memory[i] <= wave_sample;
        end       
    end
    
    wire Condition_For_Wave = wave_switch;     

    assign VGA_Red_waveform = Condition_For_Wave ? (((VGA_HORZ_COORD < 1280) && (VGA_VERT_COORD == (1024 - Sample_Memory[VGA_HORZ_COORD]))) ? cur_theme_wave[3:0] : cur_theme_background[3:0]) : cur_theme_background[3:0];
    assign VGA_Green_waveform = Condition_For_Wave ? (((VGA_HORZ_COORD < 1280) && (VGA_VERT_COORD == (1024 - Sample_Memory[VGA_HORZ_COORD]))) ? cur_theme_wave[7:4] : cur_theme_background[7:4]) : cur_theme_background[7:4];
    assign VGA_Blue_waveform = Condition_For_Wave ? (((VGA_HORZ_COORD < 1280) && (VGA_VERT_COORD == (1024 - Sample_Memory[VGA_HORZ_COORD]))) ? cur_theme_wave[11:8] : cur_theme_background[11:8]) : cur_theme_background[11:8];

    
endmodule
