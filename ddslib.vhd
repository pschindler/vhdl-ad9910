library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package instructions is
  constant OPCODE_WIDTH : positive := 5;

  subtype OPCODE_TYPE is std_logic_vector(OPCODE_WIDTH-1 downto 0);

  constant nop_opcode           : OPCODE_TYPE := B"00000";
  ---- DDS serial write
  constant dds_addr_opcode      : OPCODE_TYPE := B"00001";
  constant fifo_wr_opcode       : OPCODE_TYPE := B"00010";
  ---- DDS Profile select
  constant dds_profile_opcode   : OPCODE_TYPE := B"00011";
  ---- DAC write
  constant dac_amplitude_opcode : OPCODE_TYPE := B"00111";
  ---- DDS phase coherent switching
  constant dds_phase_ctl_opcode : OPCODE_TYPE := B"01000";
  ---- DDS phase on parallel port
  constant dds_phase_parallel   : OPCODE_TYPE := B"01001";


end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package constants is
  constant DATAWIDTH : positive := 16;
  constant BUSWIDTH  : positive := 32;

  constant SER_REGWIDTH : positive                                  := 5;
  constant FULL_OVERRUN : std_logic_vector(SER_REGWIDTH-1 downto 0) := B"10000";
  constant BYTE_OVERRUN : std_logic_vector(SER_REGWIDTH-1 downto 0) := B"01000";
  constant AUX_RESET    : std_logic_vector(SER_REGWIDTH-1 downto 0) := B"00000";

end package;
