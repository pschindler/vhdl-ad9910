library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library ddslib;
use ddslib.instructions.all;
use ddslib.constants.all;

entity dds_serial_bus is
  port (
    wb_clk      : in  std_logic;
    data        : in  std_logic_vector (DATAWIDTH-1 downto 0);
-- data2 : out std_logic_vector (DATAWIDTH-1 downto 0);
    load        : in  std_logic;
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
  signal load         : std_logic;
  signal clk_counter  : std_logic(1 downto 0);

-------------------------------------------------------------------------------
-- Behaviour starts here
-------------------------------------------------------------------------------

begin

  aux_finished <= (aux_counter = counter_ovr);  --whats bigger equal in vhdl??
--  sclk_out     <= '0' when (aux_finished or load = '1' or active = '0') else wb_clk;
  done_out     <= '1' when aux_finished else '0';

-------------------------------------------------------------------------------
-- Serial write process now with state machine for the serial output
-- Untested !!!
-------------------------------------------------------------------------------
  write_serial_process : process(wb_clk, load)
  begin

    if (falling_edge(wb_clk) and (load = '0')) and (not aux_finished) then
      case clk_counter is
        when B"00" =>
          aux_counter <= std_logic_vector(unsigned(aux_counter) + 1);
          aux_reg     <= aux_reg(DATAWIDTH-2 downto 0) & '0';
          clk_counter <= B"01";
          sdo_out     <= aux_reg(DATAWIDTH-1);
          sclk_out    <= '0';
        when B"01" =>
          sclk_out    <= '1';
        when others => null;
      end case;
    end if;

    if (load = '1') then
      aux_reg     <= data(DATAWIDTH-1 downto 0);
      aux_counter <= AUX_RESET;
    end if;

  end process;



end behaviour;
