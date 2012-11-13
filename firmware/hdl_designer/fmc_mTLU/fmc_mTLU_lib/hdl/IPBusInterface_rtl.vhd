--=============================================================================
--! @file IPBusInterface_rtl.vhd
--=============================================================================
--
-------------------------------------------------------------------------------
-- --
-- University of Bristol, High Energy Physics Group.
-- --
------------------------------------------------------------------------------- --
-- VHDL Architecture fmc_mTLU_lib.IPBusInterface.rtl
--
--! @brief \n
--! \n
--
--! @author David Cussans , David.Cussans@bristol.ac.uk
--
--! @date 16:06:57 11/09/12
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
use work.emac_hostbus_decl.all;

ENTITY IPBusInterface IS
   GENERIC( 
      NUM_SLAVES : positive := 6
   );
   PORT( 
      gmii_rx_clk_i   : IN     std_logic;
      gmii_rx_dv_i    : IN     std_logic;
      gmii_rx_er_i    : IN     std_logic;
      gmii_rxd_i      : IN     std_logic_vector (7 DOWNTO 0);
      ipbr_i          : IN     ipb_rbus_array (NUM_SLAVES-1 DOWNTO 0);  -- ! IPBus read signals
      sysclk_n_i      : IN     std_logic;
      sysclk_p_i      : IN     std_logic;                               -- ! 200 MHz xtal clock
      clk_4x_logic_o  : OUT    std_logic;                               -- ! normally 160MHz
      clocks_locked_o : OUT    std_logic;
      gmii_gtx_clk_o  : OUT    std_logic;
      gmii_tx_en_o    : OUT    std_logic;
      gmii_tx_er_o    : OUT    std_logic;
      gmii_txd_o      : OUT    std_logic_vector (7 DOWNTO 0);
      ipb_clk_o       : OUT    std_logic;                               -- ! IPBus clock to slaves
      ipb_rst_o       : OUT    std_logic;                               -- ! IPBus reset to slaves
      ipbw_o          : OUT    ipb_wbus_array (NUM_SLAVES-1 DOWNTO 0);  -- ! IBus write signals
      logic_strobe_o  : OUT    std_logic;                               -- ! 40MHz strobe sync with 160MHz clock
      onehz_o         : OUT    std_logic;
      phy_rstb_o      : OUT    std_logic;
      dip_switch_i    : IN     std_logic_vector (3 DOWNTO 0)
   );

-- Declarations

END ENTITY IPBusInterface ;

--
ARCHITECTURE rtl OF IPBusInterface IS
  
 	signal clk125, clk_fast, ipb_clk, locked, rst_125, rst_ipb: STD_LOGIC;
	signal mac_txd, mac_rxd : STD_LOGIC_VECTOR(7 downto 0);
	signal mac_txdvld, mac_txack, mac_rxclko, mac_rxdvld, mac_rxgoodframe, mac_rxbadframe : STD_LOGIC;
	signal ipb_master_out : ipb_wbus;
	signal ipb_master_in : ipb_rbus;
	signal mac_addr: std_logic_vector(47 downto 0);
	signal ip_addr: std_logic_vector(31 downto 0);
  signal s_ipb_clk : std_logic;

BEGIN
  

--	DCM clock generation for internal bus, ethernet
	clocks: entity work.clocks_s6_extphy port map(
          sysclk_p => sysclk_p_i,
          sysclk_n => sysclk_n_i,
          clko_125 => clk125,
          clko_fast => clk_fast,
          clko_ipb => ipb_clk,
          locked => locked_o,
          rsto_125 => rst_125,
          rsto_ipb => rst_ipb,
          onehz => onehz_o
          );
		
	-- leds <= ('0', '0', locked, onehz);
	
--	Ethernet MAC core and PHY interface
-- In this version, consists of hard MAC core and GMII interface to external PHY
-- Can be replaced by any other MAC / PHY combination

 	eth: entity work.eth_s6_gmii port map(
		clk125 => clk125,
		rst => rst_125,
		gmii_gtx_clk => gmii_gtx_clk_o,
		gmii_tx_en => gmii_tx_en_o,
		gmii_tx_er => gmii_tx_er_o,
		gmii_txd => gmii_txd_o,
		gmii_rx_clk => gmii_rx_clk_i,
		gmii_rx_dv => gmii_rx_dv_i,
		gmii_rx_er => gmii_rx_er_i,
		gmii_rxd => gmii_rxd_i,
		txd => mac_txd,
		txdvld => mac_txdvld,
		txack => mac_txack,
		rxd => mac_rxd,
		rxclko => mac_rxclko,
		rxdvld => mac_rxdvld,
		rxgoodframe => mac_rxgoodframe,
		rxbadframe => mac_rxbadframe,
		hostbus_in => hostbus_in,
		hostbus_out => hostbus_out
	);
	
	phy_rstb <= '1';
	
-- ipbus control logic

	ipbus: entity work.ipbus_ctrl_udponly port map(
		ipb_clk => ipb_clk,
		rst_ipb => rst_ipb,
		rst_macclk => rst_125,
		mac_txclk => clk125,
		mac_rxclk => mac_rxclko,
		mac_rxd => mac_rxd,
		mac_rxdvld => mac_rxdvld,
		mac_rxgoodframe => mac_rxgoodframe,
		mac_rxbadframe => mac_rxbadframe,
		mac_txd => mac_txd,
		mac_txdvld => mac_txdvld,
		mac_txack => mac_txack,
		ipb_out => ipb_master_out,
		ipb_in => ipb_master_in,
		mac_addr => mac_addr,
		ip_addr => ip_addr
	);
       
	
	mac_addr <= X"020ddba115" & dip_switch & X"0"; -- Careful here, arbitrary addresses do not always work
	ip_addr   <= X"c0a8c8" & dip_switch & X"0"; -- 192.168.200.X
        --ip_addr <= X"c0a8000a" ; -- 192.168.0.10 ( Match to FORTIS eth3)
-- ipbus slaves live in the entity below, and can expose top-level ports
-- The ipbus fabric is instantiated within.

  fabric: entity work.ipbus_fabric
    generic map(NSLV => NUM_SLAVES)
    port map(
      ipb_clk => ipb_clk,
      rst => rst,
      ipb_in => ipb_in,
      ipb_out => ipb_out,
      ipb_to_slaves => ipbw_o,
      ipb_from_slaves => ipbr_i
    );
    
END ARCHITECTURE rtl;

