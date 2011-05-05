----- CELL pulse_shaper                       -----
--
--@file
--
--@brief Output goes high when input goes high ( asyncnronous to system clock).
--! Output goes low again a controllable number of clock cycles later,
--! synchronous with the rising edge of the clock.
--! Gap of at least one clock cycle before output goes high again.
--
--! Output won't retrigger if input is still high at end of pulse.
--
--! Put desired length of pulse (in clock cycles) into pulse_length
--
-- David Cussans, Feb 2011
--
Library IEEE;
use IEEE.STD_LOGIC_1164.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity pulse_shaper is
  port (
    D                   : in  std_logic;         --! Input pulse
    Q                   : out std_logic;         --! output pulse
    CLK                 : in  std_logic;         --! Clock , rising edge active
    PULSE_LENGTH        : in  std_logic_vector(3 downto 0));  -- ! Length in
                                                              -- clock cycles
                                                              -- of output pulse.

end pulse_shaper;

architecture rtl of pulse_shaper is

  component dtype_fdpe
    port(
      Q : out std_logic;      --! Output
      CLK   : in std_logic;   --! Clock - rising edge active
      D   : in std_logic;     --! Input
      CE  : in std_logic;     --! Clock enable
      PRE : in std_logic      --! Asynchronous preload
      );
  end component;

  component dtype_fd
    port(
      Q : out std_logic;      --! Output
      CLK   : in std_logic;   --! Clock - rising edge active
      D   : in std_logic     --! Input
      );
  end component;

  
  signal load_srl : std_logic := '0';   -- ! Pulses high to load shift reg
  
  signal internal_veto : std_logic := '0';  -- After output has risen high, this signal goes high to veto further pules
  
  signal vetoed_pulse : std_logic := '0';  --! input signal after internal veto

  signal async_pulse : std_logic := '0';  -- ! Output from pre-settable D-type
  
  signal srl_ce , srl_d , srl_q : std_logic := '0';  -- ! Input, output from shift reg.
  signal Q_R1 , Q_R2 , Q_R3 : std_logic := '0';       --! Output, delayed by one clock. Used to form veto.

  signal D_R1 , D_R2  : std_logic := '0';       --! Input, delayed by one clock. Used to form veto.
  
begin  -- rtl

  srl_d <= Q_R2 and (not Q_R3);         --! Pulses high for one cycle on rising edge
  srl_ce <= Q_R2 ;
  
  SRL16E_inst : SRL16E
    generic map (
      INIT => X"0000")
    port map (
      Q => SRL_Q, -- SRL data output
      A0 => PULSE_LENGTH(0), -- Select[0] input
      A1 => PULSE_LENGTH(1), -- Select[1] input
      A2 => PULSE_LENGTH(2), -- Select[2] input
      A3 => PULSE_LENGTH(3), -- Select[3] input
      CE => SRL_CE, -- Clock enable input
      CLK => CLK, -- Clock input
      D => SRL_D -- SRL data input
      );

  --! In order for a pulse to get to the PREset input, the output must be low
  --and the input must be low
  vetoed_pulse <= D and (not Q_R2) and (not D_R2);
  
  Q <= async_pulse;                     --! Connect output of FDPE to output.
  async_reg: dtype_fdpe
    port map (
      Q   => async_pulse,
      D   => '0',                       --! Clock in zero when shift reg. spits
                                        --out a '1'
      CLK => CLK,
      CE  => SRL_Q,
      PRE => vetoed_pulse ) ;
    
  q_reg1 : dtype_fd                     --! Delay the output signal
    port map (
      Q   => Q_R1,
      D   => async_pulse,     
      CLK => CLK
      ) ;

  q_reg2 : dtype_fd                     --! Delay the output signal
    port map (
      Q   => Q_R2,
      D   => Q_R1,     
      CLK => CLK
      ) ;

  q_reg3 : dtype_fd                     --! Delay the output signal
    port map (
      Q   => Q_R3,
      D   => Q_R2,     
      CLK => CLK
      ) ;

  d_reg1 : dtype_fd                     --! Delay the input
    port map (
      Q   => D_R1,
      D   => D,     
      CLK => CLK
      ) ;

  d_reg2 : dtype_fd                     --! Delay the input
    port map (
      Q   => D_R2,
      D   => D_R1,     
      CLK => CLK
      ) ;


  
end rtl;
