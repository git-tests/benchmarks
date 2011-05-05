--------------------------------------------------------------------------------
-- Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: M.81d
--  \   \         Application: netgen
--  /   /         Filename: fmc_tlu_sp601_timesim.vhd
-- /___/   /\     Timestamp: Fri Feb 25 16:05:26 2011
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -s 2 -pcf fmc_tlu_sp601.pcf -rpw 100 -tpw 0 -ar Structure -tm fmc_tlu_sp601 -insert_pp_buffers true -w -dir netgen/par -ofmt vhdl -sim fmc_tlu_sp601.ncd fmc_tlu_sp601_timesim.vhd 
-- Device	: 6slx16csg324-2 (PRODUCTION 1.16 2011-01-20)
-- Input file	: fmc_tlu_sp601.ncd
-- Output file	: /afs/phy.bris.ac.uk/cad/designs/fmc-mtlu/trunk/firmware/synthesis/ise/mTLU/netgen/par/fmc_tlu_sp601_timesim.vhd
-- # of Entities	: 1
-- Design Name	: fmc_tlu_sp601
-- Xilinx	: /net/asimov/users/software/CAD/Xilinx/12.4_64b/ISE_DS/ISE/
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library SIMPRIM;
use SIMPRIM.VCOMPONENTS.ALL;
use SIMPRIM.VPACKAGE.ALL;

entity fmc_tlu_sp601 is
  port (
    SYSCLK_N : in STD_LOGIC := 'X'; 
    SYSCLK_P : in STD_LOGIC := 'X'; 
    D : in STD_LOGIC := 'X'; 
    Q : out STD_LOGIC; 
    pulse_length : in STD_LOGIC_VECTOR ( 3 downto 0 ) 
  );
end fmc_tlu_sp601;

architecture Structure of fmc_tlu_sp601 is
  signal pulse_length_0_IBUF_0 : STD_LOGIC; 
  signal pulse_length_1_IBUF_0 : STD_LOGIC; 
  signal buf_sysclk_SLAVEBUF_DIFFIN_75 : STD_LOGIC; 
  signal pulse_length_2_IBUF_0 : STD_LOGIC; 
  signal buffered_clock_0 : STD_LOGIC; 
  signal pulse_length_3_IBUF_0 : STD_LOGIC; 
  signal D_IBUF_0 : STD_LOGIC; 
  signal shaper_async_reg_Q_80 : STD_LOGIC; 
  signal shaper_q_reg2_Q_81 : STD_LOGIC; 
  signal shaper_d_reg2_Q_82 : STD_LOGIC; 
  signal shaper_srl_d : STD_LOGIC; 
  signal shaper_vetoed_pulse : STD_LOGIC; 
  signal shaper_q_reg3_Q_86 : STD_LOGIC; 
  signal pulse_length_0_IBUF_1 : STD_LOGIC; 
  signal pulse_length_1_IBUF_4 : STD_LOGIC; 
  signal pulse_length_2_IBUF_9 : STD_LOGIC; 
  signal buffered_clock : STD_LOGIC; 
  signal pulse_length_3_IBUF_16 : STD_LOGIC; 
  signal D_IBUF_19 : STD_LOGIC; 
  signal shaper_srl_q : STD_LOGIC; 
  signal shaper_q_reg2_Mshreg_Q_50 : STD_LOGIC; 
  signal shaper_d_reg2_Mshreg_Q_43 : STD_LOGIC; 
  signal NlwBufferSignal_Q_OBUF_I : STD_LOGIC; 
  signal NlwBufferSignal_shaper_async_reg_Q_CLK : STD_LOGIC; 
  signal NlwBufferSignal_shaper_SRL16E_inst_A0 : STD_LOGIC; 
  signal NlwBufferSignal_shaper_SRL16E_inst_A1 : STD_LOGIC; 
  signal NlwBufferSignal_shaper_SRL16E_inst_A2 : STD_LOGIC; 
  signal NlwBufferSignal_shaper_SRL16E_inst_A3 : STD_LOGIC; 
  signal NlwBufferSignal_shaper_SRL16E_inst_CLK : STD_LOGIC; 
  signal NlwBufferSignal_shaper_SRL16E_inst_D : STD_LOGIC; 
  signal NlwBufferSignal_shaper_d_reg2_Q_CLK : STD_LOGIC; 
  signal NlwBufferSignal_shaper_d_reg2_Mshreg_Q_CLK : STD_LOGIC; 
  signal NlwBufferSignal_shaper_d_reg2_Mshreg_Q_D : STD_LOGIC; 
  signal NlwBufferSignal_shaper_q_reg2_Q_CLK : STD_LOGIC; 
  signal NlwBufferSignal_shaper_q_reg2_Mshreg_Q_CLK : STD_LOGIC; 
  signal NlwBufferSignal_shaper_q_reg2_Mshreg_Q_D : STD_LOGIC; 
  signal NlwBufferSignal_shaper_q_reg3_Q_CLK : STD_LOGIC; 
  signal NlwBufferSignal_shaper_q_reg3_Q_IN : STD_LOGIC; 
  signal VCC : STD_LOGIC; 
  signal GND : STD_LOGIC; 
  signal NLW_shaper_SRL16E_inst_Q15_UNCONNECTED : STD_LOGIC; 
  signal NLW_shaper_d_reg2_Mshreg_Q_Q15_UNCONNECTED : STD_LOGIC; 
  signal NLW_shaper_q_reg2_Mshreg_Q_Q15_UNCONNECTED : STD_LOGIC; 
begin
  pulse_length_0_IBUF : X_BUF
    generic map(
      LOC => "PAD123",
      PATHPULSE => 240 ps
    )
    port map (
      O => pulse_length_0_IBUF_1,
      I => pulse_length(0)
    );
  ProtoComp0_IMUX : X_BUF
    generic map(
      LOC => "PAD123",
      PATHPULSE => 240 ps
    )
    port map (
      I => pulse_length_0_IBUF_1,
      O => pulse_length_0_IBUF_0
    );
  pulse_length_1_IBUF : X_BUF
    generic map(
      LOC => "PAD124",
      PATHPULSE => 240 ps
    )
    port map (
      O => pulse_length_1_IBUF_4,
      I => pulse_length(1)
    );
  ProtoComp0_IMUX_1 : X_BUF
    generic map(
      LOC => "PAD124",
      PATHPULSE => 240 ps
    )
    port map (
      I => pulse_length_1_IBUF_4,
      O => pulse_length_1_IBUF_0
    );
  buf_sysclk_SLAVEBUF_DIFFIN : X_BUF
    generic map(
      LOC => "PAD94",
      PATHPULSE => 240 ps
    )
    port map (
      I => SYSCLK_N,
      O => buf_sysclk_SLAVEBUF_DIFFIN_75
    );
  pulse_length_2_IBUF : X_BUF
    generic map(
      LOC => "PAD125",
      PATHPULSE => 240 ps
    )
    port map (
      O => pulse_length_2_IBUF_9,
      I => pulse_length(2)
    );
  ProtoComp0_IMUX_2 : X_BUF
    generic map(
      LOC => "PAD125",
      PATHPULSE => 240 ps
    )
    port map (
      I => pulse_length_2_IBUF_9,
      O => pulse_length_2_IBUF_0
    );
  buf_sysclk_IBUFDS : X_IBUFDS
    generic map(
      LOC => "PAD93"
    )
    port map (
      IB => buf_sysclk_SLAVEBUF_DIFFIN_75,
      O => buffered_clock,
      I => SYSCLK_P
    );
  ProtoComp2_IMUX : X_BUF
    generic map(
      LOC => "PAD93",
      PATHPULSE => 240 ps
    )
    port map (
      I => buffered_clock,
      O => buffered_clock_0
    );
  pulse_length_3_IBUF : X_BUF
    generic map(
      LOC => "PAD126",
      PATHPULSE => 240 ps
    )
    port map (
      O => pulse_length_3_IBUF_16,
      I => pulse_length(3)
    );
  ProtoComp0_IMUX_3 : X_BUF
    generic map(
      LOC => "PAD126",
      PATHPULSE => 240 ps
    )
    port map (
      I => pulse_length_3_IBUF_16,
      O => pulse_length_3_IBUF_0
    );
  D_IBUF : X_BUF
    generic map(
      LOC => "PAD129",
      PATHPULSE => 240 ps
    )
    port map (
      O => D_IBUF_19,
      I => D
    );
  ProtoComp0_IMUX_4 : X_BUF
    generic map(
      LOC => "PAD129",
      PATHPULSE => 240 ps
    )
    port map (
      I => D_IBUF_19,
      O => D_IBUF_0
    );
  Q_OBUF : X_OBUF
    generic map(
      LOC => "PAD130"
    )
    port map (
      I => NlwBufferSignal_Q_OBUF_I,
      O => Q
    );
  shaper_vetoed_pulse1 : X_LUT6
    generic map(
      LOC => "SLICE_X34Y2",
      INIT => X"000000000000FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => D_IBUF_0,
      ADR4 => shaper_d_reg2_Q_82,
      ADR5 => shaper_q_reg2_Q_81,
      O => shaper_vetoed_pulse
    );
  shaper_async_reg_Q : X_FF
    generic map(
      LOC => "SLICE_X34Y3",
      INIT => '1'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_shaper_async_reg_Q_CLK,
      I => shaper_srl_q,
      O => shaper_async_reg_Q_80,
      SET => shaper_vetoed_pulse,
      RST => GND
    );
  shaper_SRL16E_inst : X_SRLC16E
    generic map(
      LOC => "SLICE_X34Y3",
      INIT => X"0000"
    )
    port map (
      A0 => NlwBufferSignal_shaper_SRL16E_inst_A0,
      A1 => NlwBufferSignal_shaper_SRL16E_inst_A1,
      A2 => NlwBufferSignal_shaper_SRL16E_inst_A2,
      A3 => NlwBufferSignal_shaper_SRL16E_inst_A3,
      CLK => NlwBufferSignal_shaper_SRL16E_inst_CLK,
      D => NlwBufferSignal_shaper_SRL16E_inst_D,
      Q15 => NLW_shaper_SRL16E_inst_Q15_UNCONNECTED,
      Q => shaper_srl_q,
      CE => shaper_q_reg2_Q_81
    );
  shaper_d_reg2_Q : X_FF
    generic map(
      LOC => "SLICE_X34Y4",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_shaper_d_reg2_Q_CLK,
      I => shaper_d_reg2_Mshreg_Q_43,
      O => shaper_d_reg2_Q_82,
      RST => GND,
      SET => GND
    );
  shaper_d_reg2_Mshreg_Q : X_SRLC16E
    generic map(
      LOC => "SLICE_X34Y4",
      INIT => X"0000"
    )
    port map (
      A0 => '0',
      A1 => '0',
      A2 => '0',
      A3 => '0',
      CLK => NlwBufferSignal_shaper_d_reg2_Mshreg_Q_CLK,
      D => NlwBufferSignal_shaper_d_reg2_Mshreg_Q_D,
      Q15 => NLW_shaper_d_reg2_Mshreg_Q_Q15_UNCONNECTED,
      Q => shaper_d_reg2_Mshreg_Q_43,
      CE => '1'
    );
  shaper_q_reg2_Q : X_FF
    generic map(
      LOC => "SLICE_X34Y4",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_shaper_q_reg2_Q_CLK,
      I => shaper_q_reg2_Mshreg_Q_50,
      O => shaper_q_reg2_Q_81,
      RST => GND,
      SET => GND
    );
  shaper_q_reg2_Mshreg_Q : X_SRLC16E
    generic map(
      LOC => "SLICE_X34Y4",
      INIT => X"0000"
    )
    port map (
      A0 => '0',
      A1 => '0',
      A2 => '0',
      A3 => '0',
      CLK => NlwBufferSignal_shaper_q_reg2_Mshreg_Q_CLK,
      D => NlwBufferSignal_shaper_q_reg2_Mshreg_Q_D,
      Q15 => NLW_shaper_q_reg2_Mshreg_Q_Q15_UNCONNECTED,
      Q => shaper_q_reg2_Mshreg_Q_50,
      CE => '1'
    );
  shaper_srl_d1 : X_LUT6
    generic map(
      LOC => "SLICE_X35Y9",
      INIT => X"0F0F0F0F00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR4 => '1',
      ADR3 => '1',
      ADR5 => shaper_q_reg2_Q_81,
      ADR2 => shaper_q_reg3_Q_86,
      O => shaper_srl_d
    );
  shaper_q_reg3_Q : X_FF
    generic map(
      LOC => "SLICE_X35Y11",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_shaper_q_reg3_Q_CLK,
      I => NlwBufferSignal_shaper_q_reg3_Q_IN,
      O => shaper_q_reg3_Q_86,
      RST => GND,
      SET => GND
    );
  NlwBufferBlock_Q_OBUF_I : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => shaper_async_reg_Q_80,
      O => NlwBufferSignal_Q_OBUF_I
    );
  NlwBufferBlock_shaper_async_reg_Q_CLK : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => buffered_clock_0,
      O => NlwBufferSignal_shaper_async_reg_Q_CLK
    );
  NlwBufferBlock_shaper_SRL16E_inst_A0 : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => pulse_length_0_IBUF_0,
      O => NlwBufferSignal_shaper_SRL16E_inst_A0
    );
  NlwBufferBlock_shaper_SRL16E_inst_A1 : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => pulse_length_1_IBUF_0,
      O => NlwBufferSignal_shaper_SRL16E_inst_A1
    );
  NlwBufferBlock_shaper_SRL16E_inst_A2 : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => pulse_length_2_IBUF_0,
      O => NlwBufferSignal_shaper_SRL16E_inst_A2
    );
  NlwBufferBlock_shaper_SRL16E_inst_A3 : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => pulse_length_3_IBUF_0,
      O => NlwBufferSignal_shaper_SRL16E_inst_A3
    );
  NlwBufferBlock_shaper_SRL16E_inst_CLK : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => buffered_clock_0,
      O => NlwBufferSignal_shaper_SRL16E_inst_CLK
    );
  NlwBufferBlock_shaper_SRL16E_inst_D : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => shaper_srl_d,
      O => NlwBufferSignal_shaper_SRL16E_inst_D
    );
  NlwBufferBlock_shaper_d_reg2_Q_CLK : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => buffered_clock_0,
      O => NlwBufferSignal_shaper_d_reg2_Q_CLK
    );
  NlwBufferBlock_shaper_d_reg2_Mshreg_Q_CLK : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => buffered_clock_0,
      O => NlwBufferSignal_shaper_d_reg2_Mshreg_Q_CLK
    );
  NlwBufferBlock_shaper_d_reg2_Mshreg_Q_D : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => D_IBUF_0,
      O => NlwBufferSignal_shaper_d_reg2_Mshreg_Q_D
    );
  NlwBufferBlock_shaper_q_reg2_Q_CLK : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => buffered_clock_0,
      O => NlwBufferSignal_shaper_q_reg2_Q_CLK
    );
  NlwBufferBlock_shaper_q_reg2_Mshreg_Q_CLK : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => buffered_clock_0,
      O => NlwBufferSignal_shaper_q_reg2_Mshreg_Q_CLK
    );
  NlwBufferBlock_shaper_q_reg2_Mshreg_Q_D : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => shaper_async_reg_Q_80,
      O => NlwBufferSignal_shaper_q_reg2_Mshreg_Q_D
    );
  NlwBufferBlock_shaper_q_reg3_Q_CLK : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => buffered_clock_0,
      O => NlwBufferSignal_shaper_q_reg3_Q_CLK
    );
  NlwBufferBlock_shaper_q_reg3_Q_IN : X_BUF
    generic map(
      PATHPULSE => 240 ps
    )
    port map (
      I => shaper_q_reg2_Q_81,
      O => NlwBufferSignal_shaper_q_reg3_Q_IN
    );
  NlwBlock_fmc_tlu_sp601_VCC : X_ONE
    port map (
      O => VCC
    );
  NlwBlock_fmc_tlu_sp601_GND : X_ZERO
    port map (
      O => GND
    );
  NlwBlockROC : X_ROC
    generic map (ROC_WIDTH => 100 ns)
    port map (O => GSR);
  NlwBlockTOC : X_TOC
    port map (O => GTS);

end Structure;

