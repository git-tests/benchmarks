--=============================================================================
--! @file logic_clocks_rtl.vhd
--=============================================================================
--
-------------------------------------------------------------------------------
-- --
-- University of Bristol, High Energy Physics Group.
-- --
------------------------------------------------------------------------------- --
-- VHDL Architecture fmc_mTLU_lib.logic_clocks.rtl
--
--! @brief Generates 160MHz , 640MHz clocks from an incoming 40MHz clock. \n
--! Can switch between clock generated from on-board Xtal ( clk_logic_xtal ) and external clock\n
--! Can also output clock to external clock pins.
--!
--! @author David Cussans , David.Cussans@bristol.ac.uk
--
--! @date 14:20:26 11/14/12
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
-- Based on output of Xilinx Coregen and Alvro Dosil TLU code.
------------------------------------------------------------------------------
-- "Output    Output      Phase     Duty      Pk-to-Pk        Phase"
-- "Clock    Freq (MHz) (degrees) Cycle (%) Jitter (ps)  Error (ps)"
------------------------------------------------------------------------------
-- CLK_OUT1___640.000______0.000______50.0______175.916____213.982
-- CLK_OUT2___160.000______0.000______50.0______223.480____213.982
-- CLK_OUT3____40.000______0.000______50.0______306.416____213.982
--
------------------------------------------------------------------------------
-- "Input Clock   Freq (MHz)    Input Jitter (UI)"
------------------------------------------------------------------------------
-- __primary__________40.000____________0.010

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

USE work.ipbus.all;

library unisim;
use unisim.vcomponents.all;

ENTITY logic_clocks IS
   PORT( 
      ipbus_clk_i        : IN     std_logic;
      ipbus_i            : IN     ipb_wbus;
      ipbus_reset_i      : IN     std_logic;
      clk_logic_xtal_i   : IN     std_logic;   -- ! 40MHz clock from onboard xtal
      clk_16x_logic_O    : OUT    std_logic;   -- 640MHz clock
      clk_4x_logic_o     : OUT    std_logic;   -- 160MHz clock
      ipbus_o            : OUT    ipb_rbus;
      strobe_16x_logic_O : OUT    std_logic;   -- strobes once every 4 cycles of clk_16x
      strobe_4x_logic_O  : OUT    std_logic;   -- one pulse every 4 cycles of clk_4x
      extclk_p_b         : INOUT  std_logic;   -- either external clock in, or a clock being driven out
      extclk_n_b         : INOUT  std_logic;
      clk_logic_o        : OUT    std_logic
   );

-- Declarations

END ENTITY logic_clocks ;

--
ARCHITECTURE rtl OF logic_clocks IS

  signal s_clk40_internal : std_logic;
  signal s_clk160_internal : std_logic;

  -- Eventually connect up clock control & status lines to IPBus
  signal s_extclk_is_input : std_logic := '1';
  signal s_clk_is_xtal : std_logic := '1';
  signal s_logic_clk_rst : std_logic := '0';
  signal s_locked_pll, s_locked_bufpll : std_logic;
    
  signal s_clk40 , s_clk : std_logic;

  signal s_clkfbout_buf , s_clkfbout : std_logic;
  
BEGIN

  --! Buffer external clock
  ext_clk_io : IOBUFDS
   generic map (
      IOSTANDARD => "BLVDS_25")
   port map (
      O => s_extclk,     -- Buffer output
      IO => extclk_p_b,   -- Diff_p inout (connect directly to top-level port)
      IOB => extclk_n_b, -- Diff_n inout (connect directly to top-level port)
      I => s_clk40_internal,     -- Buffer input
      T => s_extclk_is_input      -- 3-state enable input, high=input, low=output
   );

  --! For now just connect input of PLL to clock from Xtal...
  clock_mux : BUFGMUX
   generic map (
      CLK_SEL_TYPE => "SYNC"  -- Glitchles ("SYNC") or fast ("ASYNC") clock switch-over
   )
   port map (
      O => s_clk,   -- 1-bit output: Clock buffer output
      I0 => s_extclk, -- 1-bit input: Clock buffer input (S=0)
      I1 => clk_logic_xtal_i, -- 1-bit input: Clock buffer input (S=1)
      S => s_clk_is_xtal    -- 1-bit input: Clock buffer select
   );
  
  
  --! Clocking primitive
  -------------------------------------
  --! Instantiation of the PLL primitive
  pll_base_inst : PLL_BASE
  generic map
   (BANDWIDTH            => "OPTIMIZED",
    CLK_FEEDBACK         => "CLKFBOUT",
    COMPENSATION         => "SYSTEM_SYNCHRONOUS",
    DIVCLK_DIVIDE        => 1,
    CLKFBOUT_MULT        => 16,
    CLKFBOUT_PHASE       => 0.000,
    CLKOUT0_DIVIDE       => 1,
    CLKOUT0_PHASE        => 0.000,
    CLKOUT0_DUTY_CYCLE   => 0.500,
    CLKOUT1_DIVIDE       => 4,
    CLKOUT1_PHASE        => 0.000,
    CLKOUT1_DUTY_CYCLE   => 0.500,
    CLKOUT2_DIVIDE       => 16,
    CLKOUT2_PHASE        => 0.000,
    CLKOUT2_DUTY_CYCLE   => 0.500,
    CLKIN_PERIOD         => 25.000,
    REF_JITTER           => 0.010)
  port map(
    -- Output clocks
	  CLKFBOUT            => s_clkfbout,
    CLKOUT0             => s_clk640,
    CLKOUT1             => s_clk160,
    CLKOUT2             => s_clk40,
    CLKOUT3             => open,
    CLKOUT4             => open,
    CLKOUT5             => open,
    -- Status and control signals
    LOCKED              => s_locked_pll,
    RST                 => s_logic_clk_rst,
    -- Input clock control
    CLKFBIN             => s_clkfbout_buf,
    CLKIN               => s_clk);

 
  -- Buffer the 16x clock and generate the ISERDES strobe signal
   BUFPLL_inst : BUFPLL
   generic map (
      DIVIDE => 4)
   port map (
      IOCLK => s_clk640_internal,                -- 1-bit output: Output I/O clock
      LOCK => s_locked_bufpll,                     -- 1-bit output: Synchronized LOCK output
      SERDESSTROBE => strobe_16x_logic_O,   -- 1-bit output: Output SERDES strobe (connect to ISERDES2/OSERDES2)
      GCLK => s_clk160_internal,                     -- 1-bit input: BUFG clock input
      LOCKED => s_locked_pll,                  -- 1-bit input: LOCKED input from PLL
      PLLIN => s_clk640                -- 1-bit input: Clock input from PLL
   );

  clk_16x_logic_o <= s_clk640_internal;
 
 
  -- purpose: generates a strobe in time with rising edge of s_clk
  -- type   : combinational
  -- inputs : s_clk160 , s_clk
  -- outputs: strobe_4x_logic_o
  generate_4x_strobe: process (s_clk160 , s_clk)
  begin  -- process generate_4x_strobe
    if rising_edge(s_clk160) then
      s_clk_d1 <= s_clk;
      s_strobe_4x_p1 <= s_clk_d1 and not s_clk;
      s_strobe_4x_logic <=  s_strobe_4x_p1;
    end if;
  end process generate_4x_strobe;

  -- buffer 4x_strobe
  logic_4x_strobe_buf : BUFG
  port map(
    O  => strobe_4x_logic_o,
    I  => s_strobe_4x_logic);

  -- buffer feedback clock
  -------------------------------------
  clkf_buf : BUFG
  port map(
    O => s_clkfbout_buf,
    I => s_clkfbout);

  -- buffer 160MHz (4x) clock
  --------------------------------------
  clk160_o_buf : BUFG
  port map(
    O   => s_clk160_internal,
    I   => s_clk160);
    
  clk_4x_logic_o <= s_clk160_internal;
 
   -- buffer 40MHz (1x) clock
  --------------------------------------
  clk40_o_buf : BUFG
  port map(
    O   => s_clk40_internal,
    I   => s_clk40);

  clk_logic_o <= s_clk40_internal;

END ARCHITECTURE rtl;

