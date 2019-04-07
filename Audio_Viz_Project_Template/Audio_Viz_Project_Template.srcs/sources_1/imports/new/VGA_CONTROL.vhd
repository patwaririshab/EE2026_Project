----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2014 02:10:40 PM
-- Design Name: 
-- Module Name: vga_ctrl - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------

-- modified version of the example code for Basys 3 from Digilent Inc.
-- Shahzor Ahmad, NUS ECE

-----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.math_real.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity VGA_CONTROL is
    Port ( 
               pxl_clk : in STD_LOGIC ;
    
               VGA_horzSync : out STD_LOGIC ;
               VGA_vertSync : out STD_LOGIC ;

              VGA_active : out STD_LOGIC ;                              -- used to signal the active region of the screen (when not blank)
              VGA_horzCoord : inout std_logic_vector(11 downto 0) ;     -- horz & vert counters indicating screen coordinates
              VGA_vertCoord : inout std_logic_vector(11 downto 0)
           );
end VGA_CONTROL;



architecture Behavioral of VGA_CONTROL is


  --***1280x1024@60Hz***--
  constant FRAME_WIDTH : natural := 1280;
  constant FRAME_HEIGHT : natural := 1024;
  
  constant H_FP : natural := 48; --H front porch width (pixels)
  constant H_PW : natural := 112; --H sync pulse width (pixels)
  constant H_MAX : natural := 1688; --H total period (pixels)
  
  constant V_FP : natural := 1; --V front porch width (lines)
  constant V_PW : natural := 3; --V sync pulse width (lines)
  constant V_MAX : natural := 1066; --V total period (lines)
  
  constant H_POL : std_logic := '1';
  constant V_POL : std_logic := '1';
  
  -------------------------------------------------------------------------
  
  -- VGA Controller specific signals: Counters, Sync, R, G, B
  
  -------------------------------------------------------------------------
  
  -- Horizontal and Vertical counters
  signal h_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');
  signal v_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');
  
  
  -- Horizontal and Vertical Sync
  signal h_sync_reg : std_logic := not(H_POL);
  signal v_sync_reg : std_logic := not(V_POL);
 
  

begin
  

       ---------------------------------------------------------------
       
       -- Generate Horizontal, Vertical counters and the Sync signals
       
       ---------------------------------------------------------------
         -- Horizontal counter
         process (pxl_clk)
         begin
           if (rising_edge(pxl_clk)) then
             if (h_cntr_reg = (H_MAX - 1)) then
               h_cntr_reg <= (others =>'0');
             else
               h_cntr_reg <= h_cntr_reg + 1;
             end if;
           end if;
         end process;
         
         -- Vertical counter
         process (pxl_clk)
         begin
           if (rising_edge(pxl_clk)) then
             if ((h_cntr_reg = (H_MAX - 1)) and (v_cntr_reg = (V_MAX - 1))) then
               v_cntr_reg <= (others =>'0');
             elsif (h_cntr_reg = (H_MAX - 1)) then
               v_cntr_reg <= v_cntr_reg + 1; -- this really increments at a much slower freq ( 60 Hz? )
             end if;
           end if;
         end process;
         
         -- Horizontal sync
         process (pxl_clk)
         begin
           if (rising_edge(pxl_clk)) then
             if (h_cntr_reg >= (H_FP + FRAME_WIDTH - 1)) and (h_cntr_reg < (H_FP + FRAME_WIDTH + H_PW - 1)) then
               h_sync_reg <= H_POL; -- this tells VGA to keep drawing same line
             else
               h_sync_reg <= not(H_POL); -- new line (see pulse width in Fig. 14 Basys3_rm.pdf)
             end if;
           end if;
         end process;
         
         -- Vertical sync
         process (pxl_clk)
         begin
           if (rising_edge(pxl_clk)) then
             if (v_cntr_reg >= (V_FP + FRAME_HEIGHT - 1)) and (v_cntr_reg < (V_FP + FRAME_HEIGHT + V_PW - 1)) then
               v_sync_reg <= V_POL; 
             else
               v_sync_reg <= not(V_POL); -- this tells VGA to start a new page
             end if;
           end if;
         end process;
         
         
         
       --------------------
       
       -- GENERATE OUTPUTs
       
       --------------------  
        VGA_active <= '1' when h_cntr_reg < FRAME_WIDTH and v_cntr_reg < FRAME_HEIGHT
                   else '0';
          
       
        VGA_horzSync <= h_sync_reg ;
        VGA_vertSync <= v_sync_reg ;
        
        VGA_horzCoord <= h_cntr_reg ;
        VGA_vertCoord <= v_cntr_reg ;


end Behavioral;
