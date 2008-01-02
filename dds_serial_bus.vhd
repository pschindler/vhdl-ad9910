-- -*- mode: Vhdl -*-
-- Time-stamp: "2008-01-02 14:46:54 c704271"

--  file       dds_serial_bus.vhd
--  copyright  (c) Philipp Schindler 2008
--  url        http://pulse-sequencer.sf.net

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ddslib;
use ddslib.instructions.all;
use ddslib.constants.all;
use ddslib.config.all;

entity dds_serial_bus is
  port (
    wb_clk      : in  std_logic;
    data        : in  std_logic_vector (DATAWIDTH-1 downto 0);
    reset       : in std_logic;
-- data2 : out std_logic_vector (DATAWIDTH-1 downto 0);
    load_reg    : in  std_logic;
    done_out    : out std_logic;
    sclk_out    : out std_logic;
    active      : in  std_logic;
    counter_ovr : in  std_logic_vector(SER_REGWIDTH-1 downto 0);
    sdo_out     : out std_logic
    );
end dds_serial_bus;

architecture behaviour of dds_serial_bus is

  signal aux_reg      : std_logic_vector(DATAWIDTH-1 downto 0);
  signal aux_counter  : std_logic_vector(SER_REGWIDTH-1 downto 0);
  signal aux_finished : boolean;
--  signal load_reg     : std_logic;
  signal clk_counter  : std_logic_vector(1 downto 0);

-------------------------------------------------------------------------------
-- Behaviour starts here
-------------------------------------------------------------------------------

begin

  aux_finished <= (aux_counter = counter_ovr);  --whats bigger equal in vhdl??
--  sclk_out     <= '0' when (aux_finished or load_reg = '1' or active = '0') else wb_clk;
  done_out     <= '1' when aux_finished else '0';

-------------------------------------------------------------------------------
-- Serial write process now with state machine for the serial output
-- Untested !!!
-------------------------------------------------------------------------------
  write_serial_process : process(wb_clk, load_reg)
  begin

    if falling_edge(wb_clk) then
      if (load_reg = '0') and (not aux_finished) and (reset='0') and active='1'  then
        case clk_counter is
          when B"00" =>
            sdo_out     <= aux_reg(DATAWIDTH-1);
            sclk_out    <= '0';
            clk_counter <= B"01";
          when B"01" =>
            sclk_out    <= '1';
            clk_counter <= B"00";
            aux_counter <= std_logic_vector(unsigned(aux_counter) + 1);
            aux_reg     <= aux_reg(DATAWIDTH-2 downto 0) & '0';
          when others =>
            clk_counter <= B"00";
            sdo_out     <= '0';
            sclk_out    <= '0';
        end case;
      else
        sclk_out <= '0';
        sdo_out  <= '0';
        clk_counter <= B"00";
      end if;
    end if;
    if (load_reg = '1') then
      clk_counter <= B"00";
      aux_reg     <= data(DATAWIDTH-1 downto 0);
      aux_counter <= AUX_RESET;
    end if;

    if reset = '1' then
      clk_counter <= B"00";
      aux_reg     <= X"0000";
      aux_counter <= AUX_RESET;
    end if;
  end process;



end behaviour;
