--=============================================================================
--! @file arrivalTimeLUT_rtl.vhd
--=============================================================================
--
-------------------------------------------------------------------------------
-- --
-- University of Bristol, High Energy Physics Group.
-- --
------------------------------------------------------------------------------- --
-- VHDL Architecture work.ArivalTimeLUT.rtl
--
--! @brief Uses a look-up-table to convert the eight bits from the two 1:4 deserializers\n
--! into a 5-bit time ( 3 bits from the position in 8-bit deserialized data \n
--! plus two bits from position w.r.t. the strobe_4x_logic_i signal ( one pulse
--! every 4 cycles of clk_4x_logic_i 
--
--! @author David Cussans , David.Cussans@bristol.ac.uk
--
--! @date 12:46:34 11/21/12
--
--! @version v0.1
--
--! @details
--!
--!
--! <b>Dependencies:</b>\n
--!
--! <b>References:</b>\n
--!
--! <b>Modified by:</b>\n
--! Author: 
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
-------------------------------------------------------------------------------
--! @todo <next thing to do> \n
--! <another thing to do> \n
--
--------------------------------------------------------------------------------
-- 
-- Created using using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY arrivalTimeLUT IS
   GENERIC( 
      g_NUM_FINE_BITS   : positive := 3;
      g_NUM_COARSE_BITS : positive := 2
   );
   PORT( 
      clk_4x_logic_i      : IN     std_logic;                                                        -- ! Rising edge active
      strobe_4x_logic_i   : IN     std_logic;                                                        -- ! Pulses high once every 4 cycles of clk_4x_logic
      deserialized_data_i : IN     std_logic_vector (7 DOWNTO 0);                                    -- Output from the two 4-bit deserializers. Clocked by clk_4x_logic_i
      arrival_time_o      : OUT    std_logic_vector (g_NUM_FINE_BITS+g_NUM_COARSE_BITS-1 DOWNTO 0);  -- Position of rising edge w.r.t. 40MHz strobe. Clocked by clk_4x_logic_i
      rising_edge_o       : OUT    std_logic;                                                        -- goes high if there is a rising edge in the data. Clocked by clk_4x_logic_i
      falling_edge_o      : OUT    std_logic                                                         -- goes high if there is a falling edge in the data.Clocked by clk_4x_logic_i
   );

-- Declarations

END ENTITY arrivalTimeLUT ;

--
ARCHITECTURE rtl OF arrivalTimeLUT IS

  constant c_FALLING_EDGE_BIT : positive := g_NUM_FINE_BITS-2+1;  --! Bit position of bit set when falling edge detected
  constant c_RISING_EDGE_BIT : positive :=  g_NUM_FINE_BITS-2+2;  --! Bit position of bit set when falling edge detected

  signal s_coarse_bits : std_logic_vector(g_NUM_COARSE_BITS-1 downto 0) := "00";  --! phase w.r.t. strobe

  signal s_LUT_entry : std_logic_vector(g_NUM_FINE_BITS+2-1 downto 0);  -- stores intermediate LUT value.
  
  type t_LUT is array (natural range <>) of std_logic_vector(g_NUM_FINE_BITS+2-1 downto 0);
  --! Lookup table for arrival time and rising/falling edge detection (3bits
  --! for position in 8-bit deserialized data plus two bits for rising/falling 
  constant c_LUT : t_LUT(0 to 255) :=
    ( "00001" , "00001" ,  "00001" , "00001" ,"00001" , "00001" ,  "00001" , "00001" ,
      "00010" , "00010" ,  "00010" , "00010" ,"00010" , "00010" ,  "00010" , "00010" ,
      "00100" , "00100" ,  "00100" , "00100" ,"00100" , "00100" ,  "00100" , "00100" ,
      "01000" , "01000" ,  "01000" , "01000" ,"01000" , "01000" ,  "01000" , "01000" ,
      "10000" , "10000" ,  "10000" , "10000" ,"10000" , "10000" ,  "10000" , "10000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" ,
      "00000" , "00000" ,  "00000" , "00000" ,"00000" , "00000" ,  "00000" , "00000" 
      );  
    
BEGIN

  -- purpose: uses the deserialized data as a index into
  --          a lookup table holding the position of the first rising edge (if any)
  --          and if there is a rising or falling edge
  -- type   : combinational
  -- inputs : clk_4x_logic_i
  -- outputs: arrival_time_o , rising_edge_o , falling_edge_o
  examine_lut: process (clk_4x_logic_i , deserialized_data_i)
--    variable v_LUT_entry : std_logic_vector(g_NUM_FINE_BITS+2-1 downto 0);  --! Entry in LUT pointed to by deserialized data
  begin  -- process examine_lut
    
--    v_LUT_entry := c_LUT(to_integer(unsigned(deserialized_data_i)));

    if rising_edge(clk_4x_logic_i) then
      s_LUT_entry <= c_LUT(to_integer(unsigned(deserialized_data_i)));
      arrival_time_o <= s_coarse_bits & s_LUT_ENTRY(g_NUM_FINE_BITS-1 downto 0);
      rising_edge_o  <= s_LUT_ENTRY(c_RISING_EDGE_BIT);
      falling_edge_o <= s_LUT_ENTRY(c_FALLING_EDGE_BIT);
    end if;

    end process examine_lut;
  
END ARCHITECTURE rtl;

