--=============================================================================
--! @file dualSERDES_1to4_rtl.vhd
--=============================================================================
--
-------------------------------------------------------------------------------
-- --
-- University of Bristol, High Energy Physics Group.
-- --
------------------------------------------------------------------------------- --
-- VHDL Architecture work.dualSERDES_1to4.rtl
--
--! @brief Two 1:4 Deserializers. One has input delayed w.r.t. other\n
--! based on TDC by Alvaro Dosil\n
--
--! @author David Cussans , David.Cussans@bristol.ac.uk
--
--! @date 12:06:53 11/16/12
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

library unisim ;
use unisim.vcomponents.all;


ENTITY dualSERDES_1to4 IS
   PORT( 
      serdes_reset_i : IN     std_logic;                      --! Starts recalibration sequence
      data_i         : IN     std_logic;
      fastClk_i      : IN     std_logic;                      --! 4x fabric clock. e.g. 640MHz
      fabricClk_i    : IN     std_logic;                      --! clock for output to FPGA. e.g. 160MHz
      strobe_i       : IN     std_logic;                      --! Strobes once every 4 cycles of fastClk
      data_o         : OUT    std_logic_vector (7 DOWNTO 0);  --! Deserialized data. Lower 4-bits from prompt serdes, top 4-bits from delayed serdes
      serdes_ready_o : OUT    std_logic                       --! goes low during calibration sequence.
   );

-- Declarations

END ENTITY dualSERDES_1to4 ;

--
ARCHITECTURE rtl OF dualSERDES_1to4 IS

  constant c_S : positive := 4;         -- ! SERDES division ratio
  signal s_Data_i_d_p  , s_Data_i_d_2p : std_logic;
  signal s_Data_i_d_d  , s_Data_i_d_2d : std_logic;
  signal s_calibrate_idelay : std_logic := '0';  --! Take high to calibrate the IDELAY components
  signal s_idelay_p_delay,  s_idelay_d_delay  : std_logic;  -- Indicates that the IDELAY isn't calibrating.
  signal s_data_o : std_logic_vector(7 downto 0);  --! Deserialized data
  
BEGIN

    IODELAY2_Prompt : IODELAY2
  generic map (
    COUNTER_WRAPAROUND => "WRAPAROUND",     -- "STAY_AT_LIMIT" or "WRAPAROUND" 
    DATA_RATE          => "SDR",            -- "SDR" or "DDR" 
    DELAY_SRC          => "IDATAIN",        -- "IO", "ODATAIN" or "IDATAIN" 
    IDELAY_MODE        => "NORMAL",         -- "NORMAL" or "PCI" 
    IDELAY_TYPE        => "FIXED",          -- "FIXED", "DEFAULT", "VARIABLE_FROM_ZERO", "VARIABLE_FROM_HALF_MAX" 
                              --  or "DIFF_PHASE_DETECTOR" 
    IDELAY_VALUE     => 0,                -- Amount of taps for fixed input delay (0-255)
    IDELAY2_VALUE    => 0,                -- Delay value when IDELAY_MODE="PCI" (0-255)
    ODELAY_VALUE     => 0,                -- Amount of taps fixed output delay (0-255)
    SERDES_MODE      => "NONE"            -- "NONE", "MASTER" or "SLAVE" 
--    SIM_TAPDELAY_VALUE=> 43                -- Per tap delay used for simulation in ps
   )
  port map (
    BUSY     => s_idelay_p_delay,          -- 1-bit output: Busy output after CAL
    DATAOUT  => s_Data_i_d_p,     -- 1-bit output: Delayed data output to ISERDES/input register
    DATAOUT2 => s_Data_i_d_2p,    -- 1-bit output: Delayed data output to general FPGA fabric
    DOUT     => open,          -- 1-bit output: Delayed data output
    TOUT     => open,          -- 1-bit output: Delayed 3-state output
    CAL      => '0',           -- 1-bit input: Initiate calibration input
    CE       => '0',           -- 1-bit input: Enable INC input
    CLK      => fabricClk_i,           -- 1-bit input: Clock input
    IDATAIN  => Data_i,        -- 1-bit input: Data input (connect to top-level port or I/O buffer)
    INC      => '0',           -- 1-bit input: Increment / decrement input
    IOCLK0   => fastClk_i,           -- 1-bit input: Input from the I/O clock network
    IOCLK1   => '0',           -- 1-bit input: Input from the I/O clock network
    ODATAIN  => '0',           -- 1-bit input: Output data input from output register or OSERDES2.
    RST      => serdes_reset_i,         -- 1-bit input: reset_i to zero or 1/2 of total delay period
    T        => '0'            -- 1-bit input: 3-state input signal
   );


  IODELAY2_Delayed : IODELAY2
  generic map (
    COUNTER_WRAPAROUND => "WRAPAROUND",  -- "STAY_AT_LIMIT" or "WRAPAROUND" 
    DATA_RATE          => "SDR",         -- "SDR" or "DDR" 
    DELAY_SRC          => "IDATAIN",     -- "IO", "ODATAIN" or "IDATAIN" 
    IDELAY_MODE        => "NORMAL",      -- "NORMAL" or "PCI" 
    IDELAY_TYPE        => "FIXED",       -- "FIXED", "DEFAULT", "VARIABLE_FROM_ZERO", "VARIABLE_FROM_HALF_MAX" 
                              --  or "DIFF_PHASE_DETECTOR" 
    IDELAY_VALUE       => 10,--29,            -- Amount of taps for fixed input delay (0-255) 10->0.75nS, 11->0.825nS
    IDELAY2_VALUE      => 0,             -- Delay value when IDELAY_MODE="PCI" (0-255)
    ODELAY_VALUE       => 0,             -- Amount of taps fixed output delay (0-255)
    SERDES_MODE        => "NONE"         -- "NONE", "MASTER" or "SLAVE" 
    --SIM_TAPDELAY_VALUE => 43              -- Per tap delay used for simulation in ps
   )
  port map (
    BUSY     =>  s_idelay_p_delay,             -- 1-bit output: Busy output after CAL
    DATAOUT  => s_Data_i_d_d,        -- 1-bit output: Delayed data output to ISERDES/input register
    DATAOUT2 => s_Data_i_d_2d,       -- 1-bit output: Delayed data output to general FPGA fabric
    DOUT     => open,             -- 1-bit output: Delayed data output
    TOUT     => open,             -- 1-bit output: Delayed 3-state output
    CAL      => '0',              -- 1-bit input: Initiate calibration input
    CE       => '0',              -- 1-bit input: Enable INC input
    CLK      => fabricClk_i,              -- 1-bit input: Clock input
    IDATAIN  => Data_i,           -- 1-bit input: Data input (connect to top-level port or I/O buffer)
    INC      => '0',              -- 1-bit input: Increment / decrement input
    IOCLK0   => fastClk_i,          -- 1-bit input: Input from the I/O clock network
    IOCLK1   => '0',              -- 1-bit input: Input from the I/O clock network
    ODATAIN  => '0',              -- 1-bit input: Output data input from output register or OSERDES2.
    RST      => serdes_reset_i,            -- 1-bit input: reset_i to zero or 1/2 of total delay period
    T        => '0'               -- 1-bit input: 3-state input signal
   );


  ISERDES2_Prompt : ISERDES2
  generic map (
    BITSLIP_ENABLE => FALSE,         -- Enable Bitslip Functionality (TRUE/FALSE)
    DATA_RATE      => "SDR",         -- Data-rate ("SDR" or "DDR")
    DATA_WIDTH     => c_S,             -- Parallel data width selection (2-8)
    INTERFACE_TYPE => "RETIMED", -- "NETWORKING", "NETWORKING_PIPELINED" or "RETIMED" 
    SERDES_MODE    => "NONE"         -- "NONE", "MASTER" or "SLAVE" 
   )
  port map (
    -- Q1 - Q4: 1-bit (each) output Registered outputs to FPGA logic
    Q1     => s_Data_o(1),
    Q2     => s_Data_o(3),
    Q3     => s_Data_o(5),
    Q4     => s_Data_o(7), 
    --SHIFTOUT => SHIFTOUTsig,       -- 1-bit output Cascade output signal for master/slave I/O
    VALID   => open,                 -- 1-bit output Output status of the phase detector
    BITSLIP => '0',                  -- 1-bit input Bitslip enable input
    CE0     => '1',                  -- 1-bit input Clock enable input
    CLK0    => fastClk_i,                -- 1-bit input I/O clock network input
    CLK1    => '0',                  -- 1-bit input Secondary I/O clock network input
    CLKDIV  => fabricClk_i,               -- 1-bit input FPGA logic domain clock input
    D       => s_Data_i_d_p,         -- 1-bit input Input data
    IOCE    => strobe_i,             -- 1-bit input Data strobe_i input
    RST     => serdes_reset_i,              -- 1-bit input Asynchronous reset_i input
    SHIFTIN => '0'                   -- 1-bit input Cascade input signal for master/slave I/O
   );

  ISERDES2_Delayed : ISERDES2
  generic map (
    BITSLIP_ENABLE => FALSE,          -- Enable Bitslip Functionality (TRUE/FALSE)
    DATA_RATE      => "SDR",       -- Data-rate ("SDR" or "DDR")
    DATA_WIDTH     => c_S,             -- Parallel data width selection (2-8)
    INTERFACE_TYPE => "RETIMED", -- "NETWORKING", "NETWORKING_PIPELINED" or "RETIMED" 
    SERDES_MODE    => "NONE"          -- "NONE", "MASTER" or "SLAVE" 
   )
  port map (
    -- Q1 - Q4: 1-bit (each) output Registered outputs to FPGA logic
    Q1     => s_Data_o(0),
    Q2     => s_Data_o(2),
    Q3     => s_Data_o(4),
    Q4     => s_Data_o(6),
    --SHIFTOUT => SHIFTOUTsig,     -- 1-bit output Cascade output signal for master/slave I/O
    VALID   => open,               -- 1-bit output Output status of the phase detector
    BITSLIP => '0',                -- 1-bit input Bitslip enable input
    CE0     => '1',                -- 1-bit input Clock enable input
    CLK0    => fastClk_i,              -- 1-bit input I/O clock network input
    CLK1    => '0',                -- 1-bit input Secondary I/O clock network input
    CLKDIV  => fabricClk_i,             -- 1-bit input FPGA logic domain clock input
    D       => s_Data_i_d_d,       -- 1-bit input Input data
    IOCE    => strobe_i,           -- 1-bit input Data strobe_i input
    RST     => serdes_reset_i,            -- 1-bit input Asynchronous reset_i input
    SHIFTIN => '0'                 -- 1-bit input Cascade input signal for master/slave I/O
   );

reg_out : process(fabricClk_i)
begin
  if rising_edge(fabricClk_i) then
    Data_o <= s_Data_o;
  end if;
end process;

END ARCHITECTURE rtl;

