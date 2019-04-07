`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2019 10:24:20
// Design Name: 
// Module Name: frequency_calculator
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

module frequency_calculator(
    input CLK,
    input freq_20kHz, 
    input [11:0] sound_sample,
    output reg [18:0] frequency = 0,
    output  [3:0] an,
    output  [7:0] seg
    );
   
   //This block stores the sample data for 1 second and determines the maximum and minimum values of the sample
   reg[15:0] i = 0;
   reg[15:0] i_max = 0;
   reg[15:0] max_amplitude = 0;
   reg[15:0] min_amplitude = 2048;
   reg[11:0] one_second_record[0:10000];
   reg[15:0] time_counter = 0; //If time_counter == 10000, termination condition (0.1 second completed)
   reg ender = 0;
   reg [15:0] max_counter = 0;
   reg [15:0] min_counter = 0;
   
  always @(posedge freq_20kHz) begin
        //This block stores recorded sample and its max, min amplitudes
        if (ender == 0) begin
            //This line resets the counter when it hits 10000 (time = 0.5 s) and toogled boolean register ender to 1
            if (time_counter == 10000) begin ender <= 1; time_counter <= 0; i_max <= i; i <= 0; end 
            else begin
            time_counter <= time_counter + 1;
            //This line stores the sound sample record for 0.1 seconds
            one_second_record[i] <= sound_sample;
            i <= i + 1; 
            
            //These lines store the maximum and minium amplitudes recorded
            if (sound_sample >= max_amplitude) max_amplitude <= sound_sample;
            if (sound_sample <= min_amplitude) min_amplitude <= sound_sample;
            end
            
        end

   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
        //This block counts the number of peaks and troughs in 0.1 second and gets their average, then x 10 to get Frequency
        //This block iterates thorugh the recorded sample and compares adjacent elements to determine peak and trough
         if (ender == 1) begin
            i <= i + 1;
            
            //These lines count the number of peaks and troughs in recorded sample
            if ((one_second_record[i-1] < one_second_record[i]) && (one_second_record[i+1] < one_second_record[i])) max_counter <= max_counter + 1;
            if ((one_second_record[i-1] > one_second_record[i]) && (one_second_record[i+1] > one_second_record[i])) min_counter <= min_counter + 1;
            
            //Termination condition
            if (i == i_max) begin 
            
                ender <= 0;
                frequency <= (min_counter + max_counter);
                max_counter <= 0;
                min_counter <= 0;
                max_amplitude <= 0;
                min_amplitude <= 0;
                i_max <= 0;
                i <= 0;

            end     
        end
end
 
    wire freq_1525Hz;
    wire [3:0] interim_an;
    clk_div_1525kHz my_1525kHz(CLK, freq_1525Hz);
    FLICKER_ANODE fa(freq_20kHz, interim_an); //Updates the anode configuration at 1525kHz
    
    wire[7:0] interim_seg;
    SEGMENT_DISP sd (freq_20kHz,frequency,an,interim_seg); 
    assign an = interim_an;
    assign seg = interim_seg;

endmodule
