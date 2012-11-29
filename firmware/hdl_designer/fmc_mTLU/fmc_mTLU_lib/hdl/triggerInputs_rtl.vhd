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
--! @brief Measures arrival time of trigger pulses using two deserializers
--! clocked on 14x clock ( 640MHz) \n
--! Based on TDC code by Alvaro Dosil\n
--
--! @author David Cussans , David.Cussans@bristol.ac.uk
--!
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

library unisim ;
use unisim.vcomponents.all;

ENTITY triggerInputs IS
   GENERIC( 
      g_NUM_INPUTS : natural := 4
   );
   PORT( 
      cfd_discr_p_i       : IN     std_logic_vector (g_NUM_INPUTS-1 DOWNTO 0);
      cfd_discr_n_i       : IN     std_logic_vector (g_NUM_INPUTS-1 DOWNTO 0);
      clk_4x_logic        : IN     std_logic;                                     -- ! Rising edge active
      strobe_4x_logic_i   : IN     std_logic;                                     -- ! Pulses high once every 4 cycles of clk_4x_logic
      threshold_discr_p_i : IN     std_logic_vector (g_NUM_INPUTS-1 DOWNTO 0);    -- ! inputs from threshold comparators
      threshold_discr_n_i : IN     std_logic_vector (g_NUM_INPUTS-1 DOWNTO 0);    -- ! inputs from threshold comparators
      trigger_times_o     : OUT    t_triggerTimeArray (g_NUM_INPUTS-1 DOWNTO 0);  -- ! trigger arrival time ( w.r.t. logic_strobe)
      trigger_o           : OUT    std_logic_vector (g_NUM_INPUTS-1 DOWNTO 0);    -- ! High when trigger active
      ipbus_clk_i         : IN     std_logic;
      ipbus_reset_i       : IN     std_logic;
      ipbus_i             : IN     ipb_wbus;                                      -- Signals from IPBus core to slave
      ipbus_o             : OUT    ipb_rbus;                                      -- signals from slave to IPBus core
      clk_16x_logic_i     : IN     std_logic;                                     --! 640MHz clock ( 16x 40MHz )
      strobe_16x_logic_i  : IN     std_logic                                      --! Pulses one cycle every 4 of 16x clock.
   );

-- Declarations

END ENTITY triggerInputs ;

--
ARCHITECTURE rtl OF triggerInputs IS

  signal s_threshold_discr_input , s_cfd_discr_input : std_logic_vector(g_NUM_INPUTS-1 downto 0);  -- ! inputs from comparator

  type t_deserialized_trigger_data_array is array ( natural range <> ) of std_logic_vector(7 downto 0); --

  signal s_deserialized_threshold_data , s_deserialized_cfd_data : t_deserialized_trigger_data_array(g_NUM_INPUTS-1 downto 0);

  signal s_serdes_reset : std_logic := '0';  -- ! Take high to reset serdes and initiate IODELAY calibration

  signal s_threshold_falling_edge : std_logic_vector(g_NUM_INPUTS-1 downto 0); --

  signal s_cfd_trigger_times : t_triggerTimeArray (g_NUM_INPUTS-1 DOWNTO 0);
  
  signal s_CFD_rising_edge : std_logic_vector(g_NUM_INPUTS-1 downto 0); 
  signal s_CFD_falling_edge : std_logic_vector(g_NUM_INPUTS-1 downto 0); 
  
  
BEGIN

  trigger_input_loop: for triggerInput in 0 to (g_NUM_INPUTS-1) generate

    thresholdInputBuffer: IBUFDS
      generic map (
        DIFF_TERM        => true,
        IBUF_LOW_PWR     => false,
        IOSTANDARD       => "LVDS_25")
      port map (
        O  => s_threshold_discr_input(triggerInput),
        I  => threshold_discr_p_i(triggerInput),
        IB => threshold_discr_n_i(triggerInput)
        );

    thresholdDeserializer: entity work.dualSERDES_1to4
      port map (
        serdes_reset_i => s_serdes_reset,
        data_i         => s_threshold_discr_input(triggerInput),
        fastClk_i      => clk_16x_logic_i,
        fabricClk_i    => clk_4x_logic,
        strobe_i       => strobe_16x_logic_i,
        data_o         => s_deserialized_threshold_data(triggerInput)
        );
      
    thresholdLUT : entity work.arrivalTimeLUT
      port map (
        clk_4x_logic_i      => clk_4x_logic,
        strobe_4x_logic_i   => strobe_4x_logic_i,
        deserialized_data_i => s_deserialized_threshold_data(triggerInput),
        arrival_time_o      => trigger_times_o(triggerInput),
        rising_edge_o       => trigger_o(triggerInput),
        falling_edge_o      => s_threshold_falling_edge(triggerInput)
        );
        
    CFDInputBuffer: IBUFDS
      generic map (
        DIFF_TERM        => true,
        IBUF_LOW_PWR     => false,
        IOSTANDARD       => "LVDS_25")
      port map (
        O  => s_CFD_discr_input(triggerInput),
        I  => CFD_discr_p_i(triggerInput),
        IB => CFD_discr_n_i(triggerInput)
        );

    CFDDeserializer: entity work.dualSERDES_1to4
      port map (
        serdes_reset_i => s_serdes_reset,
        data_i         => s_CFD_discr_input(triggerInput),
        fastClk_i      => clk_16x_logic_i,
        fabricClk_i    => clk_4x_logic,
        strobe_i       => strobe_16x_logic_i,
        data_o         => s_deserialized_CFD_data(triggerInput)
        );
      
    CFDLUT : entity work.arrivalTimeLUT
      port map (
        clk_4x_logic_i      => clk_4x_logic,
        strobe_4x_logic_i   => strobe_4x_logic_i,
        deserialized_data_i => s_deserialized_CFD_data(triggerInput),
        arrival_time_o      => s_cfd_trigger_times(triggerInput),
        rising_edge_o       => s_CFD_rising_edge(triggerInput),
        falling_edge_o      => s_CFD_falling_edge(triggerInput)
        );
        
  end generate trigger_input_loop;
  
END ARCHITECTURE rtl;

