--=============================================================================
--! @file eventBuffer_rtl.vhd
--=============================================================================
--
-------------------------------------------------------------------------------
-- --
-- University of Bristol, High Energy Physics Group.
-- --
------------------------------------------------------------------------------- --
-- VHDL Architecture fmc_mTLU_lib.eventBuffer.rtl
--
--! @brief \n
--! \n
--
--! @author David Cussans , David.Cussans@bristol.ac.uk
--
--! @date 15:24:50 11/13/12
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

USE work.ipbus.all;

ENTITY eventBuffer IS
   GENERIC( 
      g_EVENT_DATA_WIDTH : positive := 64;
      g_IPBUS_WIDTH      : positive := 32
   );
   PORT( 
      clk_4x_logic_i    : IN     std_logic;
      data_strobe_i     : IN     std_logic;                                         -- Indicates data to transfer
      event_data_i      : IN     std_logic_vector (g_EVENT_DATA_WIDTH-1 DOWNTO 0);
      ipbus_clk_i       : IN     std_logic;
      ipbus_i           : IN     ipb_wbus;
      ipbus_reset_i     : IN     std_logic;
      strobe_4x_logic_i : IN     std_logic;
      trigger_count_i   : IN     std_logic_vector (g_IPBUS_WIDTH-1 DOWNTO 0);
      buffer_full_o     : OUT    std_logic;                                         --! Goes high when event buffer almost full
      ipbus_o           : OUT    ipb_rbus
   );

-- Declarations

END ENTITY eventBuffer ;

--
ARCHITECTURE rtl OF eventBuffer IS

  signal s_dummy : std_logic_vector(event_data_i'range);
  
BEGIN

  -- DUMMY DUMMY. Just put something in to create a netlist to keep ISE happy
  --s_dummy <= event_data_i;
  ipbus_o.ipb_rdata <= event_data_i(g_IPBUS_WIDTH-1 downto 0);
  
END ARCHITECTURE rtl;

