--=============================================================================
--! @file DUTInterfaces_rtl.vhd
--=============================================================================
--
-------------------------------------------------------------------------------
-- --
-- University of Bristol, High Energy Physics Group.
-- --
------------------------------------------------------------------------------- --
-- VHDL Architecture fmc_mTLU_lib.DUTInterfaces.rtl
--
--! @brief \n
--! \n
--
--! @author David Cussans , David.Cussans@bristol.ac.uk
--
--! @date 15:09:50 11/09/12
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

ENTITY DUTInterfaces IS
   GENERIC( 
      NUM_DUTS    : positive := 3;
      IPBUS_WIDTH : positive := 32
   );
   PORT( 
      busy_from_dut_i       : IN     std_logic_vector (NUM_DUTS-1 DOWNTO 0);     -- BUSY input from DUTs
      clk_4x_logic_i        : IN     std_logic;
      clk_from_dut_i        : IN     std_logic_vector (NUM_DUTS-1 DOWNTO 0);     -- clocks trigger data when in EUDET mode
      ipbus_clk_i           : IN     std_logic;
      ipbus_i               : IN     ipb_wbus;                                   -- Signals from IPBus core to slave
      ipbus_reset_i         : IN     std_logic;
      logic_strobe_i        : IN     std_logic;                                  -- ! goes high every 4th clock cycle
      trigger_counter_i     : IN     std_logic_vector (IPBUS_WIDTH-1 DOWNTO 0);
      trigger_i             : IN     std_logic;                                  -- goes high when trigger logic issues a trigger
      ipbus_o               : OUT    ipb_rbus;                                   -- signals from slave to IPBus core
      reset_or_clk_to_dut_o : OUT    std_logic_vector (NUM_DUTS-1 DOWNTO 0);     -- ! Either reset line or trigger
      trigger_to_dut_o      : OUT    std_logic_vector (NUM_DUTS-1 DOWNTO 0);     -- ! Trigger output
      veto_o                : OUT    std_logic                                   -- goes high when one or more DUT are busy
   );

-- Declarations

END ENTITY DUTInterfaces ;

--
ARCHITECTURE rtl OF DUTInterfaces IS
BEGIN
END ARCHITECTURE rtl;

