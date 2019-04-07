`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// You may study and modify the code inside this module to imporve the display feature or introduce other features
//////////////////////////////////////////////////////////////////////////////////

module draw_freq_waveform(
    input clk_sample, //20kHz clock

    input [9:0] wave_sample,
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    output [14:0] VGA_freq_wave
    );
    
    //The Sample_Memory represents the memory array used to store the voice samples.
    //There are 1280 points and each point can range from 0 to 1023. 
    reg [9:0] Sample_Memory [1279:0];
    reg [10:0] i = 0;
    
    //Each wave_sample is displayed on the screen from left to right. 
    always @ (posedge clk_sample) begin
        i = (i==1279) ? 0 : i + 1;
        Sample_Memory[i] <= wave_sample;    
    end
     
    assign VGA_freq_wave[4:0] = VGA_HORZ_COORD < 1280 && 
        VGA_VERT_COORD == (1024 - Sample_Memory[VGA_HORZ_COORD]) ? {1'b1, 4'hF}
        : {1'b0, 4'h0};
    assign VGA_freq_wave[9:5] = VGA_HORZ_COORD < 1280 && 
        VGA_VERT_COORD == (1024 - Sample_Memory[VGA_HORZ_COORD]) ? {1'b1, 4'hF}
        : {1'b0, 4'h0};
    assign VGA_freq_wave[14:10] = VGA_HORZ_COORD < 1280 && 
        VGA_VERT_COORD == (1024 - Sample_Memory[VGA_HORZ_COORD]) ? {1'b1, 4'hF}
        : {1'b0, 4'h0};
endmodule
