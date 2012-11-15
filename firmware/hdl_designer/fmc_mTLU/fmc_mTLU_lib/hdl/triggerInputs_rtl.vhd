--=============================================================================
--! @file triggerInputs_rtl.vhd
--=============================================================================
--
-------------------------------------------------------------------------------
-- --
-- University of Bristol, High Energy Physics Group.
-- --
------------------------------------------------------------------------------- --
-- VHDL Architecture fmc_mTLU_lib.triggerInputs.rtl
--
--! @brief \n
--! \n
--
--! @author David Cussans , David.Cussans@bristol.ac.uk
--
--! @date 15:43:57 11/08/12
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
USE work.fmcTLU.all;


ENTITY triggerInputs IS
   GENERIC( 
      NUM_INPUTS : natural := 4
   );
   PORT( 
      cfd_discr_i       : IN     std_logic_vector (NUM_INPUTS-1 DOWNTO 0);
      clk_4x_logic      : IN     std_logic;                                   -- ! Rising edge active
      logic_strobe_i    : IN     std_logic;                                   -- ! Pulses high once every 4 cycles of clk_4x_logic
      threshold_discr_i : IN     std_logic_vector (NUM_INPUTS-1 DOWNTO 0);    -- ! inputs from threshold comparators
      trigger_times_o   : OUT    t_triggerTimeArray (NUM_INPUTS-1 DOWNTO 0);  -- ! trigger arrival time ( w.r.t. logic_strobe)
      trigger_o         : OUT    std_logic_vector (NUM_INPUTS-1 DOWNTO 0);    -- ! High when trigger active
      ipbus_clk_i       : IN     std_logic;
      ipbus_reset_i     : IN     std_logic;
      ipbus_i           : IN     ipb_wbus;                                    -- Signals from IPBus core to slave
      ipbus_o           : OUT    ipb_rbus                                     -- signals from slave to IPBus core
   );

-- Declarations

END ENTITY triggerInputs ;

--
ARCHITECTURE rtl OF triggerInputs IS
BEGIN
END ARCHITECTURE rtl;

