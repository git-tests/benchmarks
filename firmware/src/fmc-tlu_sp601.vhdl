--@file
--
--@brief Top level for AIDA Mini-TLU in FMC format using IPBUS.
--
-- David Cussans, February 2011
-------------------------------------------------------------------------------
--
library IEEE;
use IEEE.STD_LOGIC_1164.all;

--! Use library for instantiating Xilinx primitive components.
library UNISIM;
use UNISIM.vcomponents.all;

entity fmc_tlu_sp601 is
  port (
    SYSCLK_N , SYSCLK_P : in  std_logic;   --! 200MHz crystal clock
    D                   : in  std_logic;   --! pulse input
    Q                   : out std_logic;   --! pulse_output
    pulse_length          : in std_logic_vector(3 downto 0)  --!
                                                                       --Dummy
                                                                       --to
                                                                       --avoid pruning
    
    );  

end fmc_tlu_sp601;

architecture rtl of fmc_tlu_sp601 is

  -- constant MASK_WIDTH : integer := 16;  -- Number of registers in shift-reg
  
  component pulse_shaper
    port (
      D          : in  std_logic;         --! Input pulse
      Q          : out std_logic;         --! output pulse
      CLK        : in  std_logic;         --! Clock , rising edge active
      PULSE_LENGTH : in  std_logic_vector(3 downto 0));  -- ! Load with desired
                                                        -- width of pulse.
  end component;

  signal buffered_clock : std_logic := '0';
  
begin  -- rtl

 -- buf_sysclk : IBUFGDS
--    port map (
--      I  => sysclk_p,
--      IB => sysclk_n,
--      O  => buffered_clock);

  -- for simulation bodge up by connecting buffered_clock to sysclk_p
  buffered_clock <= sysclk_p;
  
  shaper : pulse_shaper
    port map (
      D          => D,
      Q          => Q,
      CLK        => buffered_clock,
      pulse_length => pulse_length);
  
end rtl;
