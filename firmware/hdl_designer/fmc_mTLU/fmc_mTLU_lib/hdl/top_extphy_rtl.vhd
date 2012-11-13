--=============================================================================
--! @file top_extphy_rtl.vhd
--=============================================================================
--
-------------------------------------------------------------------------------
-- --
-- University of Bristol, High Energy Physics Group.
-- --
------------------------------------------------------------------------------- --
-- VHDL Architecture fmc_mTLU_lib.top_extphy.rtl
--
--! @brief \n
--! \n
--
--! @author David Cussans , David.Cussans@bristol.ac.uk
--
--! @date 15:11:55 11/09/12
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

ENTITY top_extphy IS
   GENERIC( 
      NUM_DUTS        : positive := 3;
      NUM_TRIG_INPUTS : positive := 4
   );
   PORT( 
      busy_i            : IN     std_logic_vector (NUM_DUTS-1 DOWNTO 0);
      cfd_discr_i       : IN     std_logic_vector (NUM_TRIG_INPUTS-1 DOWNTO 0);
      dut_clk           : IN     std_logic_vector (NUM_DUTS-1 DOWNTO 0);
      gmii_rx_clk_i     : IN     std_logic;
      gmii_rx_dv_i      : IN     std_logic;
      gmii_rx_er_i      : IN     std_logic;
      gmii_rxd_i        : IN     std_logic_vector (7 DOWNTO 0);
      sysclk_n_i        : IN     std_logic;
      sysclk_p_i        : IN     std_logic;                                      -- ! 200 MHz xtal clock
      threshold_discr_i : IN     std_logic_vector (NUM_TRIG_INPUTS-1 DOWNTO 0);
      gmii_gtx_clk_o    : OUT    std_logic;
      gmii_tx_en_o      : OUT    std_logic;
      gmii_tx_er_o      : OUT    std_logic;
      gmii_txd_o        : OUT    std_logic_vector (7 DOWNTO 0);
      i2c_scl_o         : OUT    std_logic;
      leds_o            : OUT    std_logic_vector (3 DOWNTO 0);
      phy_rstb_o        : OUT    std_logic;
      reset_or_clk_o    : OUT    std_logic_vector (NUM_DUTS-1 DOWNTO 0);
      triggers_o        : OUT    std_logic_vector (NUM_DUTS-1 DOWNTO 0);
      i2c_sda_d         : INOUT  std_logic
   );

-- Declarations

END ENTITY top_extphy ;

--
ARCHITECTURE rtl OF top_extphy IS
BEGIN
END ARCHITECTURE rtl;

