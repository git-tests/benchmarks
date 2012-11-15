--=============================================================================
--! @file eventFormatter_rtl.vhd
--=============================================================================
--
-------------------------------------------------------------------------------
-- --
-- University of Bristol, High Energy Physics Group.
-- --
------------------------------------------------------------------------------- --
-- VHDL Architecture fmc_mTLU_lib.eventFormatter.rtl
--
--! @brief \n
--! \n
--
--! @author David Cussans , David.Cussans@bristol.ac.uk
--
--! @date 15:10:35 11/09/12
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

USE work.fmcTLU.all;

ENTITY eventFormatter IS
   GENERIC( 
      EVENT_DATA_WIDTH : positive := 64;
      IPBUS_WIDTH      : positive := 32;
      NUM_TRIG_INPUTS  : positive := 4
   );
   PORT( 
      clk_4x_logic_i  : IN     std_logic;                                        -- ! Rising edge active
      logic_strobe_i  : IN     std_logic;                                        -- ! Pulses high once every 4 cycles of clk_4x_logic
      trigger_i       : IN     std_logic;                                        -- goes high to load trigger data
      trigger_times_i : IN     t_triggerTimeArray (NUM_TRIG_INPUTS-1 DOWNTO 0);  -- Array of trigger times ( w.r.t. logic_strobe)
      data_strobe_o   : OUT    std_logic;                                        -- goes high when data ready to load into event buffer
      event_data_o    : OUT    std_logic_vector (EVENT_DATA_WIDTH-1 DOWNTO 0);
      trigger_count_o : OUT    std_logic_vector (IPBUS_WIDTH-1 DOWNTO 0)
   );

-- Declarations

END ENTITY eventFormatter ;

--
ARCHITECTURE rtl OF eventFormatter IS
BEGIN
END ARCHITECTURE rtl;

