-- generated by newgenasym Tue May 22 11:51:55 2012

library ieee;
use     ieee.std_logic_1164.all;
use     work.all;
entity pc036a_fmc_lpc_connector is
    port (    
	DP0_C2M:   INOUT  std_logic;    
	\dp0_c2m*\: INOUT  std_logic;    
	DP0_M2C:   INOUT  std_logic;    
	\dp0_m2c*\: INOUT  std_logic;    
	FMC_CLK0_M2C: INOUT  std_logic;    
	\fmc_clk0_m2c*\: INOUT  std_logic;    
	FMC_CLK1_M2C: INOUT  std_logic;    
	\fmc_clk1_m2c*\: INOUT  std_logic;    
	FMC_LA:    INOUT  std_logic_vector (33 DOWNTO 0);    
	\fmc_la*\: INOUT  std_logic_vector (33 DOWNTO 0);    
	FMC_PRSNT_M2C_L: OUT    std_logic;    
	FMC_PWR_GOOD_FLASH_RST_B: OUT    std_logic;    
	FMC_TCK_BUF: IN     std_logic;    
	FMC_TDO:   OUT    std_logic;    
	FMC_TMS_BUF: IN     std_logic;    
	FPGA_TDO:  IN     std_logic;    
	GA0:       IN     std_logic;    
	GA1:       IN     std_logic;    
	GBTCLK0_M2C: IN     std_logic;    
	\gbtclk0_m2c*\: IN     std_logic;    
	GND:       IN     std_logic;    
	IIC_SCL_MAIN: IN     std_logic;    
	IIC_SDA_MAIN: INOUT  std_logic;    
	P12V:      IN     std_logic;    
	P2V5:      IN     std_logic;    
	P3V3:      IN     std_logic;    
	TRST_L:    IN     std_logic;    
	VREF_A_M2C: IN     std_logic);
end pc036a_fmc_lpc_connector;
