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
      NUM_EXT_SLAVES : positive := 5
   );
   PORT( 
      gmii_rx_clk_i    : IN     std_logic;
      gmii_rx_dv_i     : IN     std_logic;
      gmii_rx_er_i     : IN     std_logic;
      gmii_rxd_i       : IN     std_logic_vector (7 DOWNTO 0);
      ipbr_i           : IN     ipb_rbus_array (NUM_EXT_SLAVES-1 DOWNTO 0);  -- ! IPBus read signals
      sysclk_n_i       : IN     std_logic;
      sysclk_p_i       : IN     std_logic;                                   -- ! 200 MHz xtal clock
      clocks_locked_o  : OUT    std_logic;
      gmii_gtx_clk_o   : OUT    std_logic;
      gmii_tx_en_o     : OUT    std_logic;
      gmii_tx_er_o     : OUT    std_logic;
      gmii_txd_o       : OUT    std_logic_vector (7 DOWNTO 0);
      ipb_clk_o        : OUT    std_logic;                                   -- ! IPBus clock to slaves
      ipb_rst_o        : OUT    std_logic;                                   -- ! IPBus reset to slaves
      ipbw_o           : OUT    ipb_wbus_array (NUM_EXT_SLAVES-1 DOWNTO 0);  -- ! IBus write signals
      onehz_o          : OUT    std_logic;
      phy_rstb_o       : OUT    std_logic;
      dip_switch_i     : IN     std_logic_vector (3 DOWNTO 0);
      clk_logic_xtal_o : OUT    std_logic
   );

-- Declarations

END ENTITY IPBusInterface ;

--
ARCHITECTURE rtl OF IPBusInterface IS
  
  --! Number of slaves inside the IPBusInterface block.
  constant c_NUM_INTERNAL_SLAVES : positive := 2;

 	signal clk125, locked, rst_125, rst_ipb: STD_LOGIC;
	signal mac_txd, mac_rxd : STD_LOGIC_VECTOR(7 downto 0);
	signal mac_txdvld, mac_txack, mac_rxclko, mac_rxdvld, mac_rxgoodframe, mac_rxbadframe : STD_LOGIC;
	signal ipb_master_out : ipb_wbus;
	signal ipb_master_in : ipb_rbus;
	signal mac_addr: std_logic_vector(47 downto 0);
	signal ip_addr: std_logic_vector(31 downto 0);
  signal s_ipb_clk : std_logic;
	signal hostbus_in: emac_hostbus_in;
	signal hostbus_out: emac_hostbus_out;
  signal s_ipbw_internal: ipb_wbus_array (NUM_EXT_SLAVES+c_NUM_INTERNAL_SLAVES-1 DOWNTO 0);
  signal s_ipbr_internal: ipb_rbus_array (NUM_EXT_SLAVES+c_NUM_INTERNAL_SLAVES-1 DOWNTO 0);
  signal s_sysclk : std_logic;
  
BEGIN
  

--	DCM clock generation for internal bus, ethernet
	clocks: entity work.clocks_s6_extphy port map(
          sysclk_p => sysclk_p_i,
          sysclk_n => sysclk_n_i,
          clk_logic_xtal_o => clk_logic_xtal_o,
          clko_125 => clk125,
          clko_ipb => s_ipb_clk,
          locked => clocks_locked_o,
          rsto_125 => rst_125,
          rsto_ipb => rst_ipb,
          onehz => onehz_o
          );
		
		-- Connect IPBus clock and reset to output ports.
		ipb_clk_o <= s_ipb_clk;
		ipb_rst_o <= rst_ipb;
		
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
	
	phy_rstb_o <= '1';
	
-- ipbus control logic

	ipbus: entity work.ipbus_ctrl_udponly port map(
		ipb_clk => s_ipb_clk,
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
       
	
	mac_addr <= X"020ddba115" & dip_switch_i & X"0"; -- Careful here, arbitrary addresses do not always work
	ip_addr   <= X"c0a8c8" & dip_switch_i & X"0"; -- 192.168.200.X
 
  fabric: entity work.ipbus_fabric
    generic map(NSLV => NUM_EXT_SLAVES+c_NUM_INTERNAL_SLAVES)
    port map(
      ipb_clk => s_ipb_clk,
      rst => rst_ipb,
      ipb_in => ipb_master_out,
      ipb_out => ipb_master_in,
      ipb_to_slaves => s_ipbw_internal,
      ipb_from_slaves => s_ipbr_internal
    );
    
    ipbw_o <= s_ipbw_internal(NUM_EXT_SLAVES-1 downto 0);

    s_ipbr_internal(NUM_EXT_SLAVES-1 downto 0) <= ipbr_i;
         
  -- Slave: firmware ID
  firmware_id: entity work.ipbus_ver
    port map(
      ipbus_in =>  s_ipbw_internal(NUM_EXT_SLAVES+c_NUM_INTERNAL_SLAVES-2),
      ipbus_out => s_ipbr_internal(NUM_EXT_SLAVES+c_NUM_INTERNAL_SLAVES-2)
      );
      
   -- Hostbus slave. Need to connect or IPBus_pre131_ral won't work...
   -- No point in passing host bus out in/out of block.
  hostbus_interface: entity work.ipbus_emac_hostbus
    port map(
      clk => s_ipb_clk,
      reset => rst_ipb,
      ipbus_in =>  s_ipbw_internal(NUM_EXT_SLAVES+c_NUM_INTERNAL_SLAVES-1),
      ipbus_out => s_ipbr_internal(NUM_EXT_SLAVES+c_NUM_INTERNAL_SLAVES-1),
      hostbus_out => hostbus_in,
      hostbus_in => hostbus_out);
     
END ARCHITECTURE rtl;

