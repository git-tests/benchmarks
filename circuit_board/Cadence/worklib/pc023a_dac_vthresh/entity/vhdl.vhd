-- generated by newgenasym Thu Mar  3 17:08:29 2011

library ieee;
use     ieee.std_logic_1164.all;
use     work.all;
entity PC023A_DAC_VTHRESH is
    port (    
	A0:        IN     std_logic;    
	A1:        IN     std_logic;    
	SCL:       IN     std_logic;    
	SDA:       IN     std_logic;    
	VREF:      OUT    std_logic;    
	VTHRESH:   OUT    std_logic_vector (3 DOWNTO 0));
end PC023A_DAC_VTHRESH;
