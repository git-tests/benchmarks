--=============================================================================
--! @file triggerLogic_rtl.vhd
--=============================================================================
--
-------------------------------------------------------------------------------
-- --
-- University of Bristol, High Energy Physics Group.
-- --
------------------------------------------------------------------------------- --
-- VHDL Architecture fmc_mTLU_lib.triggerLogic.rtl
--
--! @brief \n
--! \n
--
--! @author David Cussans , David.Cussans@bristol.ac.uk
--
--! @date 16:06:19 11/09/12
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

ENTITY triggerLogic IS
   GENERIC( 
      g_NUM_INPUTS : positive := 4
   );
   PORT( 
      clk_4x_logic_i   : IN     std_logic;                                   -- ! Rising edge active
      ipbus_clk_i      : IN     std_logic;
      ipbus_i          : IN     ipb_wbus;                                    -- Signals from IPBus core to slave
      ipbus_reset_i    : IN     std_logic;
      logic_strobe_i   : IN     std_logic;                                   -- ! Pulses high once every 4 cycles of clk_4x_logic
      trigger_i        : IN     std_logic_vector (g_NUM_INPUTS-1 DOWNTO 0);  -- ! High when trigger from input conector active
      veto_i           : IN     std_logic;                                   -- ! Halts triggers when high
      ipbus_o          : OUT    ipb_rbus;                                    -- signals from slave to IPBus core
      trigger_active_o : OUT    std_logic;                                   --! Goes high when triggers are active ( ie. not veoted)
      trigger_o        : OUT    std_logic                                    -- ! goes high when trigger passes
   );

-- Declarations

END ENTITY triggerLogic ;

--
ARCHITECTURE rtl OF triggerLogic IS
BEGIN

  --! For now just a dummy....
   trigGen : process  ( clk_4x_logic_i , trigger_i) 
  			begin 
        if rising_edge(clk_4x_logic_i) then
          trigger_o <= trigger_i(0);
        end if;
  			end process; 
END ARCHITECTURE rtl;

