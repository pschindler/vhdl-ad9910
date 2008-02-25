-- -*- mode: Vhdl -*-
-- Time-stamp: "2008-02-22 14:04:00 c704271"

-- file ddslib.vhd
-- copyright (c) Philipp Schindler 2008
-- url http://pulse-sequencer.sf.net


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package instructions is
  constant OPCODE_WIDTH : positive := 5;

  subtype OPCODE_TYPE is std_logic_vector(OPCODE_WIDTH-1 downto 0);

  constant nop_opcode           : OPCODE_TYPE := B"00000";  -- nop 0x0
  ---- DDS serial write
  constant dds_addr_opcode      : OPCODE_TYPE := B"00001";  -- dds_addr 0x1
  constant fifo_wr_opcode       : OPCODE_TYPE := B"00010";  -- fifo_wr  0x2
  ---- DDS Profile select
  constant dds_profile_opcode   : OPCODE_TYPE := B"00011";  -- dds_prof 0x3
  ---- DDS update
  constant dds_update_opcode    : OPCODE_TYPE := B"00100";  -- dds_up 0x4
  ---- DAC write
  constant dac_amplitude_opcode : OPCODE_TYPE := B"00111";  -- dac_wr   0x7
  ---- DDS phase coherent switching
  constant dds_phase_ctl_opcode : OPCODE_TYPE := B"01000";
  ---- DDS phase on parallel port
  constant dds_phase_parallel   : OPCODE_TYPE := B"01001";
  constant load_phase_opcode    : OPCODE_TYPE := B"01010";
  constant pulse_phase_opcode   : OPCODE_TYPE := B"01011";
  ---- DDS reset opcode
  constant reset_opcode         : OPCODE_TYPE := B"11111";

end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package constants is
  constant DATAWIDTH   : positive := 16;
  constant BUSWIDTH    : positive := 32;
  constant ADDRESWIDTH : positive := 4;

  constant PHASE_ADDRESS_WIDTH  : positive := 4;
  constant PHASE_DATA_WIDTH     : positive := 32;
  constant PHASE_ADJUST_WIDTH   : positive := 16;
  constant PHASE_REGISTER_COUNT : positive := 16;

  constant SER_REGWIDTH : positive                                  := 5;
  constant FULL_OVERRUN : std_logic_vector(SER_REGWIDTH-1 downto 0) := B"10000";
  constant BYTE_OVERRUN : std_logic_vector(SER_REGWIDTH-1 downto 0) := B"01000";
  constant AUX_RESET    : std_logic_vector(SER_REGWIDTH-1 downto 0) := B"00000";

end package;


package config is

  constant USE_ADDRESSING : boolean := false;

end package;
