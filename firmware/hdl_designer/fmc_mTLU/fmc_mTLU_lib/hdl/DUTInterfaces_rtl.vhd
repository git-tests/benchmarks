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

USE work.ipbus.all;

library unisim;
use unisim.VComponents.all;


ENTITY DUTInterfaces IS
   GENERIC( 
      g_NUM_DUTS    : positive := 3;
      g_IPBUS_WIDTH : positive := 32
   );
   PORT( 
      busy_from_dut_n_i       : IN     std_logic_vector (g_NUM_DUTS-1 DOWNTO 0);     -- BUSY input from DUTs
      busy_from_dut_p_i       : IN     std_logic_vector (g_NUM_DUTS-1 DOWNTO 0);     -- BUSY input from DUTs
      clk_4x_logic_i          : IN     std_logic;
      clk_from_dut_n_i        : IN     std_logic_vector (g_NUM_DUTS-1 DOWNTO 0);     -- clocks trigger data when in EUDET mode
      clk_from_dut_p_i        : IN     std_logic_vector (g_NUM_DUTS-1 DOWNTO 0);     -- clocks trigger data when in EUDET mode
      ipbus_clk_i             : IN     std_logic;
      ipbus_i                 : IN     ipb_wbus;                                     -- Signals from IPBus core to slave
      ipbus_reset_i           : IN     std_logic;
      strobe_4x_logic_i       : IN     std_logic;                                    -- ! goes high every 4th clock cycle
      trigger_counter_i       : IN     std_logic_vector (g_IPBUS_WIDTH-1 DOWNTO 0);
      trigger_i               : IN     std_logic;                                    -- goes high when trigger logic issues a trigger
      ipbus_o                 : OUT    ipb_rbus;                                     -- signals from slave to IPBus core
      reset_or_clk_to_dut_n_o : OUT    std_logic_vector (g_NUM_DUTS-1 DOWNTO 0);     -- ! Either reset line or trigger
      reset_or_clk_to_dut_p_o : OUT    std_logic_vector (g_NUM_DUTS-1 DOWNTO 0);     -- ! Either reset line or trigger
      trigger_to_dut_n_o      : OUT    std_logic_vector (g_NUM_DUTS-1 DOWNTO 0);     -- ! Trigger output
      trigger_to_dut_p_o      : OUT    std_logic_vector (g_NUM_DUTS-1 DOWNTO 0);     -- ! Trigger output
      veto_o                  : OUT    std_logic                                     -- goes high when one or more DUT are busy
   );

-- Declarations

END ENTITY DUTInterfaces ;

--
ARCHITECTURE rtl OF DUTInterfaces IS

  signal s_intermediate_busy_or : std_logic_vector(g_NUM_DUTS downto 0);  -- OR tree
  signal s_veto : std_logic;
  signal s_strobe_4x_logic_d1 : std_logic;
  signal s_busy_from_dut , s_clk_from_dut , s_reset_or_clk_to_dut , s_trigger_to_dut : std_logic_vector(g_NUM_DUTS-1 downto 0);
  
BEGIN

  -- Dummy code.
  s_intermediate_busy_or(0) <= '0';
  
  duts: for dut in 1 to g_NUM_DUTS generate
    
    busy_IBUFDS_inst : IBUFDS
      generic map (
        DIFF_TERM => TRUE, -- Differential Termination 
        IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
        IOSTANDARD => "LVDS_25")
      port map (
        O => s_busy_from_dut(dut-1),  -- Buffer output
        I => busy_from_dut_p_i(dut-1),  -- Diff_p buffer input (connect directly to top-level port)
        IB => busy_from_dut_n_i(dut-1) -- Diff_n buffer input (connect directly to top-level port)
      );
   
    trig_OBUFDS_inst : OBUFDS
      generic map (
        IOSTANDARD => "LVDS_25")
      port map (
        O =>  trigger_to_dut_p_o(dut-1),     -- Diff_p output (connect directly to top-level port)
        OB => trigger_to_dut_n_o(dut-1),   -- Diff_n output (connect directly to top-level port)
        I =>  s_trigger_to_dut(dut-1)      -- Buffer input 
      );
     
    clk_rst_OBUFDS_inst : OBUFDS
      generic map (
        IOSTANDARD => "LVDS_25")
      port map (
        O =>  reset_or_clk_to_dut_p_o(dut-1),     -- Diff_p output (connect directly to top-level port)
        OB => reset_or_clk_to_dut_n_o(dut-1),   -- Diff_n output (connect directly to top-level port)
        I =>  s_reset_or_clk_to_dut(dut-1)      -- Buffer input 
      );

     
    s_intermediate_busy_or(dut) <= s_intermediate_busy_or(dut-1) or
                                   s_busy_from_dut(dut-1);
                                     
  end generate duts;

    s_veto <=  s_intermediate_busy_or(g_NUM_DUTS);
  
  -- purpose: register for internal signals and output signals
  -- type   : combinational
  -- inputs : clk_4x_logic_i , strobe_4x_logic_i , s_veto
  -- outputs: veto_o
  register_signals: process (clk_4x_logic_i , strobe_4x_logic_i , s_veto)
  begin  -- process register_signals
    if rising_edge(clk_4x_logic_i) then
      veto_o <= s_veto;
      s_strobe_4x_logic_d1 <= strobe_4x_logic_i;
      s_reset_or_clk_to_dut <= ( others => (s_strobe_4x_logic_d1 or strobe_4x_logic_i));      
      s_trigger_to_dut <= ( others => trigger_i );
    end if;
  end process register_signals;

  
END ARCHITECTURE rtl;

