-- Pulse Control Processor register file for DDS phase accumulators.
-------------------------------------------------------------------------------
-- MIT-NIST-ARDA Pulse Sequencer
-- http://pulse-sequencer.sf.net
-- Paul Pham
-- MIT Center for Bits and Atoms
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- This file was "borrowed" from the sequencer firmware
-- Tis file is copyright by Paul Pham
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library ddslib;
use ddslib.instructions.all;
use ddslib.constants.all;
use ddslib.config.all;

--library seqlib;
--use seqlib.constants.all;
--use seqlib.util.all;
--use seqlib.network.all;
--use seqlib.ptp.all;
--use seqlib.avr.all;
use ieee.numeric_std.all;


-------------------------------------------------------------------------------
entity phase_register is

  generic (
--  DATA_WIDTH         : positive := 32;
--  PHASE_ADJUST_WIDTH : positive := 16;
--  ADDRESS_WIDTH      : positive := 4;
--    REGISTER_COUNT : positive := 16;

    UNUSED_GENERIC : boolean := false
    );

  port (
    clk              : in  std_logic;
    address_in       : in  std_logic_vector(PHASE_ADDRESS_WIDTH-1 downto 0);
    phase_in         : in  std_logic_vector(PHASE_DATA_WIDTH-1 downto 0);
    addend_in        : in  std_logic_vector(PHASE_DATA_WIDTH-1 downto 0);
    set_current_in   : in  std_logic;
    phase_adjust_out : out std_logic_vector(PHASE_ADJUST_WIDTH-1 downto 0);
    wren_in          : in  std_logic;

    unused_port : in std_logic := '0'
    );

end phase_register;


library ieee;
use ieee.std_logic_1164.all;
library ddslib;
use ddslib.instructions.all;
use ddslib.constants.all;
use ddslib.config.all;

--library seqlib;
--use seqlib.constants.all;
--use seqlib.util.all;
--use seqlib.network.all;
--use seqlib.ptp.all;
--use seqlib.avr.all;
use ieee.numeric_std.all;


-------------------------------------------------------------------------------
architecture behaviour of phase_register is
  subtype index_type is natural range 0 to PHASE_REGISTER_COUNT-1;
  subtype reg is unsigned(PHASE_DATA_WIDTH-1 downto 0);
  type    reg_file_type is array(0 to PHASE_REGISTER_COUNT-1) of reg;

  signal current_index      : index_type;
  signal address_index      : index_type;
  signal total_phase_adjust : reg;

  signal phase_accumulators : reg_file_type;
  signal addends            : reg_file_type;
  signal current_phase      : reg;
  signal addressed_phase    : reg;
  signal addend             : reg;
  signal set_current_delay  : boolean;

  -- Don't get any smart ideas about changing this to a RAM.
  -- All phase accumulators need to be updated in parallel, ya hoser.

begin

  address_index <= to_integer(unsigned(address_in));

  phase_process : process(clk)

--    begin
--      if rising_edge(clk) then
--        if wren_in='1' then
--          addend <= unsigned(addend_in);
--        end if;
--        current_phase <= current_phase + addend;
--        if set_current_in ='1' then
--          set_current_delay <= true;
--          else
--          set_current_delay <= false;
--        end if;
--        if set_current_delay then
--          total_phase_adjust <= current_phase;
--        end if;
--      phase_adjust_out   <=
--        std_logic_vector(total_phase_adjust(PHASE_DATA_WIDTH-1 downto
--                                            PHASE_DATA_WIDTH-PHASE_ADJUST_WIDTH));
--      end if;
--    end process;

  begin
    if (rising_edge(clk)) then
      if (wren_in = '1') then
        addends(address_index) <= unsigned(addend_in);
      end if;

      if (set_current_in = '1') then
        current_index     <= address_index;
        -- only start the phase adjust pipeline on set current so we can access
        -- both halves of the word
        addend            <= unsigned(phase_in); --addend_in);
        set_current_delay <= true;
      else
        set_current_delay <= false;
      end if;

      -- Update all phase accumulators
      for i in 0 to PHASE_REGISTER_COUNT-1 loop
        if ((wren_in = '1') and (i = address_index)) then
          phase_accumulators(i) <= (others => '0') ; --unsigned(phase_in);
        else
          phase_accumulators(i) <=
            phase_accumulators(i) + addends(i);
        end if;
      end loop;

      if (set_current_delay) then
        current_phase <= phase_accumulators(current_index);
      end if;

      total_phase_adjust <= current_phase + addend;
      phase_adjust_out   <=
        std_logic_vector(total_phase_adjust(PHASE_DATA_WIDTH-1 downto
                                            PHASE_DATA_WIDTH-PHASE_ADJUST_WIDTH));
--      phase_adjust_out   <=std_logic_vector(current_phase(PHASE_DATA_WIDTH-1 downto
--                                            PHASE_DATA_WIDTH-PHASE_ADJUST_WIDTH));
    end if;

  end process phase_process;

-------------------------------------------------------------------------------

end behaviour;
