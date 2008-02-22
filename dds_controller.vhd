-- -*- mode: Vhdl -*-
-- Time-stamp: "2008-02-22 11:43:10 c704271"
-- file dds_controller.vhd
-- copyright (c) Philipp Schindler 2008
-- url http://pulse-sequencer.sf.net


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ddslib;
use ddslib.instructions.all;
use ddslib.constants.all;
use ddslib.config.all;

entity dds_controller is
  port(
    clk0 : in std_logic;

    -- address in now used for debug_out
    address_in : in std_logic_vector(3 downto 0);


-------------------------------------------------------------------------------
-- This section is for debugging purpose only
-------------------------------------------------------------------------------
-- debug out
    debug_out : out std_logic_vector(3 downto 0);
-- reset_in : in std_logic;
-------------------------------------------------------------------------------
-- end of debugging section
-------------------------------------------------------------------------------


    -- DDS control pins
    sdo_pin     : out std_logic_vector(1 downto 0);
-- sdi_pin : out std_logic;
    sclk_pin    : out std_logic;
    ioreset_pin : out std_logic;

-- pdclk_pin : out std_logic;
    ioup_pin : out std_logic;

    drover_pin : out std_logic;
    drctl_pin  : out std_logic;
    drhold_pin : out std_logic;

    osk_pin     : out std_logic;
    pargain_pin : out std_logic_vector(1 downto 0);
    profile_pin : out std_logic_vector(2 downto 0) := B"000";
    txen_pin    : out std_logic;
    cs_pin      : out std_logic;

    -- DAC control pins
    parallel_data : out std_logic_vector(DATAWIDTH-1 downto 0);
    dac_wr_pin    : out std_logic;

    -- LVDS BUS input
    bus_in : in std_logic_vector(BUSWIDTH-1 downto 0)
    );

end dds_controller;

architecture behaviour of dds_controller is
  signal aux_reset      : std_logic;
  -- aux signals for serial control
  signal aux_ser_load   : std_logic;
  signal aux_ser_done   : std_logic;
  signal aux_ser_enable : std_logic;
  signal aux_ser_act    : std_logic;
  signal aux_ser_reset  : std_logic;
  signal aux_ser_cs     : std_logic;

  signal aux_ser_ovr                : std_logic_vector(SER_REGWIDTH-1 downto 0);
  signal aux_ser_state              : std_logic_vector(2 downto 0);
  signal aux_ser_cur_state          : std_logic_vector(2 downto 0);
  signal aux_ser_fifo_active        : std_logic;
  signal aux_ser_data               : std_logic_vector(DATAWIDTH-1 downto 0);
  -- aux_signals for FIFO control
  signal aux_rd_fifo                : std_logic;
  signal aux_wr_fifo                : std_logic;
  signal aux_fifo_empty             : std_logic;
  signal aux_fifo_out               : std_logic_vector(DATAWIDTH-1 downto 0);
  signal aux_fifo_state             : std_logic;
  -- aux signals for the phase registers
--  signal aux_phase_address_in       : std_logic_vector(PHASE_ADDRESS_WIDTH-1 downto 0);
  signal aux_phase_phase_in         : std_logic_vector(PHASE_DATA_WIDTH-1 downto 0);
  signal aux_phase_addend_in        : std_logic_vector(PHASE_DATA_WIDTH-1 downto 0);
  signal aux_phase_set_current_in   : std_logic;
  signal aux_phase_phase_adjust_out : std_logic_vector(PHASE_ADJUST_WIDTH-1 downto 0);
  signal aux_phase_wren_in          : std_logic;
  signal aux_phase_unused_port      : std_logic := '0';
  signal aux_phase_adjust_out :  std_logic_vector(PHASE_ADJUST_WIDTH-1 downto 0);

  -- aux signals for the dds ioupdate
  signal aux_profile_state : std_logic_vector(2 downto 0);
  --- The opcode from the bus
  alias opcode_data is bus_in(BUSWIDTH-1 downto BUSWIDTH-OPCODE_WIDTH);
  -- The address from the bus
  alias address_data is bus_in(BUSWIDTH-OPCODE_WIDTH-1 downto BUSWIDTH-OPCODE_WIDTH-ADDRESWIDTH);
  -- The handshake data from the bus
--  alias data_avail is bus_in(BUSWIDTH-OPCODE_WIDTH-ADDRESWIDTH-1);
  alias data_avail is bus_in(BUSWIDTH-OPCODE_WIDTH-1);
  -- The phase register from the bus
  alias aux_phase_address_in is bus_in(DATAWIDTH+PHASE_ADDRESS_WIDTH-1 downto DATAWIDTH);
  alias aux_phase_set_current is bus_in(DATAWIDTH+PHASE_ADDRESS_WIDTH );

  --- The async decoded signals
  signal decoded_reset         : boolean;
  signal decoded_fifo_wr       : boolean;
  signal decoded_dds_addr      : boolean;
  signal decoded_dds_profile   : boolean;
  signal decoded_dac_amplitude : boolean;
  signal decoded_dds_phase     : boolean;
  signal decoded_dds_update    : boolean;
  signal decoded_load_phase    : boolean;
  signal decoded_pulse_phase   : boolean;
  signal address_bit           : boolean;
  signal avail_bool            : boolean;
  signal aux_clk_state_cur     : unsigned(1 downto 0);
  signal aux_clk_state         : unsigned(1 downto 0);
  signal aux_clk               : std_logic;

-------------------------------------------------------------------------------
-- Serial bus controller
-------------------------------------------------------------------------------
  component dds_serial_bus
    port (
      reset       : in  std_logic;
      wb_clk      : in  std_logic;
      data        : in  std_logic_vector (DATAWIDTH-1 downto 0);
-- data2 : out std_logic_vector (DATAWIDTH-1 downto 0);
      load_reg    : in  std_logic;
      done_out    : out std_logic;
      sclk_out    : out std_logic;
      active_flag : in  std_logic;
      counter_ovr : in  std_logic_vector(SER_REGWIDTH-1 downto 0);
      sdo_out     : out std_logic
      );

  end component;

-------------------------------------------------------------------------------
-- The FIFO megafunction for buffering the data for the serial port
-------------------------------------------------------------------------------
  component fifo_mf
    port (
      aclr  : in  std_logic;
      clock : in  std_logic;
      data  : in  std_logic_vector(DATAWIDTH-1 downto 0);
      rdreq : in  std_logic;
      wrreq : in  std_logic;
      empty : out std_logic;
      q     : out std_logic_vector(DATAWIDTH-1 downto 0)
      );
  end component;

-------------------------------------------------------------------------------
-- The phaser registers
-------------------------------------------------------------------------------
  component phase_register
    port (
      clk              : in  std_logic;
      address_in       : in  std_logic_vector(PHASE_ADDRESS_WIDTH-1 downto 0);
      phase_in         : in  std_logic_vector(PHASE_DATA_WIDTH-1 downto 0);
      addend_in        : in  std_logic_vector(PHASE_DATA_WIDTH-1 downto 0);
      set_current_in   : in  std_logic;
      phase_adjust_out : out std_logic_vector(PHASE_ADJUST_WIDTH-1 downto 0);
      wren_in          : in  std_logic;
      unused_port      : in  std_logic := '0');
  end component;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Behaviour begins here !!
-------------------------------------------------------------------------------
-----------------------------------------------------------------------------

begin

-------------------------------------------------------------------------------
-- do some crappy debugging
-------------------------------------------------------------------------------

-- debug_out(0) <= sdo_pin(0);
-- debug_out(1) <= sclk_pin;
-- debug_out(2) <= aux_ser_reset;
-- aux_ser_reset <= '1' when decoded_dds_reset else '0';

-- debug_out(2 downto 0) <= aux_ser_state;
-- parallel_data(4 downto 0) <= opcode_data;
-- parallel_data(5) <= data_avail;
-- parallel_data(6) <= '1' when decoded_fifo_wr else '0';
-- parallel_data(0) <= clk0;
-- parallel_data(0) <= sclk_pin;
-- parallel_data(15 downto 3) <= aux_fifo_out(15 downto 3);
------------------------------------------------------------------------------
-- Asynchronious decoding
-------------------------------------------------------------------------------

  decoded_fifo_wr       <= (opcode_data = fifo_wr_opcode) and address_bit and avail_bool;
  decoded_reset         <= (opcode_data = reset_opcode) and address_bit and avail_bool;
  decoded_dds_addr      <= (opcode_data = dds_addr_opcode) and address_bit and avail_bool;
  decoded_dds_profile   <= (opcode_data = dds_profile_opcode) and address_bit and avail_bool;
  decoded_dds_update    <= (opcode_data = dds_update_opcode) and address_bit and avail_bool;
  decoded_dac_amplitude <= (opcode_data = dac_amplitude_opcode) and address_bit and avail_bool;
  decoded_dds_phase     <= (opcode_data = dds_phase_ctl_opcode) and address_bit and avail_bool;
  decoded_load_phase    <= (opcode_data = load_phase_opcode) and address_bit and avail_bool;
  decoded_pulse_phase   <= (opcode_data = pulse_phase_opcode) and address_bit and avail_bool;
  aux_ser_enable        <= '1'  when decoded_dds_addr else '0';
  avail_bool            <= true when data_avail = '1' else false;
  address_bit           <= true;
-- address_bit <= (address_data = address_in) when USE_ADDRESSING else true;

-------------------------------------------------------------------------------
-- Asynchronious reset
-------------------------------------------------------------------------------
  aux_ser_reset <= '1' when decoded_reset else '0';
  aux_reset     <= '1' when decoded_reset else '0';

-------------------------------------------------------------------------------
-- Asynchronous dds update and cs
-------------------------------------------------------------------------------
  ioup_pin      <= '1'                  when decoded_dds_update                        else '0';
  cs_pin        <= '0'                  when decoded_dds_update or (aux_ser_cs = '0')  else '1';
-- aux_clk <= '1' when clk0='0' and (decoded_fifo_wr or decoded_dds_addr) else '0';
-------------------------------------------------------------------------------
-- Asynchronious control the parallel data out
-------------------------------------------------------------------------------
  parallel_data <= aux_phase_adjust_out when decoded_pulse_phase or decoded_dds_update
                   else bus_in(DATAWIDTH-1 downto 0);
-- parallel_data <= phase_register_out when decoded_dds_phase else bus_in(DATAWIDTH-1 downto 0);

-------------------------------------------------------------------------------
-- The parallel to serial cconverter
-------------------------------------------------------------------------------
  dds_serial_out : dds_serial_bus
    port map(
      reset       => aux_ser_reset,
      wb_clk      => clk0,
-- wb_clk => aux_clk,
      data        => aux_ser_data,
      sdo_out     => sdo_pin(1),
      sclk_out    => sclk_pin,
      load_reg    => aux_ser_load,
      active_flag => aux_ser_act,
      counter_ovr => aux_ser_ovr,
      done_out    => aux_ser_done
      );

-------------------------------------------------------------------------------
-- The megafuntion FIFO
-------------------------------------------------------------------------------
  fifo_mf_inst : fifo_mf
    port map (
      aclr  => aux_reset,
      clock => aux_clk,
      data  => bus_in(DATAWIDTH-1 downto 0),
      rdreq => aux_rd_fifo,
      wrreq => aux_wr_fifo,
      empty => aux_fifo_empty,
      q     => aux_fifo_out
      );

-------------------------------------------------------------------------------
-- The phase registers
-------------------------------------------------------------------------------
  phase_register_inst : phase_register

    port map (
      clk              => clk0,
      address_in       => aux_phase_address_in,
      phase_in         => aux_phase_phase_in,
      addend_in        => aux_phase_addend_in,
      set_current_in   => aux_phase_set_current_in,
      phase_adjust_out => aux_phase_phase_adjust_out,
      wren_in          => aux_phase_wren_in,
      unused_port      => aux_phase_unused_port
      );

-------------------------------------------------------------------------------
-- All the control processes
-------------------------------------------------------------------------------

-- Generate a state machine for the serial port.
-- First the adrress byte is taken from the BUS and then the FIFO is emptied.
  state_control : process(clk0)
  begin
    if rising_edge(clk0) and aux_reset = '0' and aux_ser_enable = '1' then
      aux_ser_cur_state <= aux_ser_state;
    end if;
    if aux_ser_enable = '0' then
      aux_ser_cur_state <= B"000";
    end if;
    if aux_reset = '1' then
      aux_ser_cur_state <= B"000";
    end if;
  end process;

  debug_out(2) <= '1' when decoded_fifo_wr else '0';
  serial_control : process(aux_ser_cur_state)
  begin

    case aux_ser_cur_state is
      -- send an ioreset before ???
      when B"000" => aux_rd_fifo     <= '0';  -- Load the address byte
                     aux_ser_act     <= '0';
                     aux_ser_load    <= '0';
                     aux_ser_ovr     <= BYTE_OVERRUN;
                     aux_ser_state   <= B"001";
                     aux_ser_data    <= bus_in(DATAWIDTH -1 downto 0);
                     ioreset_pin     <= '0';
                     aux_ser_cs      <= '1';
      when B"001" => aux_rd_fifo     <= '0';  -- Load the address byte
                     aux_ser_act     <= '0';
                     aux_ser_load    <= '1';
                     aux_ser_ovr     <= BYTE_OVERRUN;
                     aux_ser_state   <= B"010";
                     aux_ser_data    <= bus_in(DATAWIDTH -1 downto 0);
                     ioreset_pin     <= '0';
                     aux_ser_cs      <= '0';
      when B"010" => aux_rd_fifo     <= '0';  -- Wait until the address byte is sent
                     aux_ser_act     <= '1';
                     aux_ser_load    <= '0';
                     ioreset_pin     <= '0';
                     aux_ser_ovr     <= BYTE_OVERRUN;
                     aux_ser_data    <= bus_in(DATAWIDTH -1 downto 0);
                     if aux_ser_done = '1' then
                       aux_ser_state <= B"011";
                     else
                       aux_ser_state <= B"010";
                     end if;
                     aux_ser_cs      <= '0';
      when B"011" => aux_rd_fifo     <= '0';  -- Load the FIFO word
                     aux_ser_act     <= '0';
                     aux_ser_load    <= '1';
                     aux_ser_ovr     <= FULL_OVERRUN;
                     ioreset_pin     <= '0';
                     aux_ser_state   <= B"100";
                     aux_ser_data    <= aux_fifo_out;
                     aux_ser_cs      <= '0';
                     -- Wait until the FIFO word is sent / loop until FIFO is empty

      when B"100" => aux_rd_fifo     <= '0';
                     aux_ser_act     <= '1';
                     aux_ser_ovr     <= FULL_OVERRUN;
                     aux_ser_data    <= aux_fifo_out;
                     aux_ser_load    <= '0';
                     ioreset_pin     <= '0';
                     if aux_ser_done = '1' then
                       aux_ser_state <= B"101";
                     else
                       aux_ser_state <= B"100";
                     end if;
                     aux_ser_cs      <= '0';
      when B"101" => aux_ser_state   <= B"110";
                     aux_rd_fifo     <= '1';
                     ioreset_pin     <= '0';
                     aux_ser_act     <= '0';
                     aux_ser_load    <= '0';
                     aux_ser_ovr     <= FULL_OVERRUN;
                     aux_ser_data    <= aux_fifo_out;
                     aux_ser_cs      <= '0';
      when B"110" => if aux_fifo_empty = '1' then
                       aux_ser_state <= B"111";
                     else
                       aux_ser_state <= B"011";
                     end if;  -- Wait until the FIFO has set the data
                     aux_ser_data    <= aux_fifo_out;
                     aux_ser_ovr     <= FULL_OVERRUN;
                     aux_ser_load    <= '1';
                     ioreset_pin     <= '0';
                     aux_ser_act     <= '0';
                     aux_rd_fifo     <= '1';
                     aux_ser_cs      <= '0';

      when B"111" => aux_rd_fifo   <= '0';
                     aux_ser_state <= B"111";  -- Wait until the opcode changes
                     ioreset_pin   <= '0';
                     aux_ser_act   <= '0';
                     aux_ser_load  <= '0';
                     aux_ser_cs    <= '1';
                     aux_ser_ovr     <= FULL_OVERRUN;
                     aux_ser_data  <= bus_in(DATAWIDTH -1 downto 0);
      when others => aux_ser_state <= B"000";  -- generate initial state
                     aux_ser_load  <= '0';
                     aux_rd_fifo   <= '0';
                     ioreset_pin   <= '0';
                     aux_ser_act   <= '0';
                     aux_ser_cs    <= '1';
                     aux_ser_ovr     <= FULL_OVERRUN;
                     aux_ser_data  <= bus_in(DATAWIDTH -1 downto 0);
    end case;
  end process;

-------------------------------------------------------------------------------
-- Generate the WR signal for the DAC
-------------------------------------------------------------------------------
  set_dac : process(clk0)
  begin
    if rising_edge(clk0) then
      if decoded_dac_amplitude or decoded_dds_phase then
        dac_wr_pin <= '1';
      else
        dac_wr_pin <= '0';
      end if;
    end if;
  end process;

-------------------------------------------------------------------------------
-- Write Bus data to FIFO
-------------------------------------------------------------------------------
  -- add a state machine to ensure the data is used only once
  state_fifo : process(clk0)
  begin
    if rising_edge(clk0) then
      if decoded_fifo_wr and aux_clk_state_cur = B"01" then
        aux_fifo_state <= '0';
      end if;
      if not decoded_fifo_wr then
        aux_fifo_state <= '1';
      end if;
    end if;
  end process;

  control_fifo : process(clk0)
  begin
    if rising_edge(clk0) then
      if (decoded_fifo_wr and aux_fifo_state = '1') then
        aux_wr_fifo <= '1';
      else
        aux_wr_fifo <= '0';
      end if;
    end if;
  end process;

-------------------------------------------------------------------------------
-- Change profile pins and send ioupdate
-------------------------------------------------------------------------------
  control_profile : process(clk0)
  begin
    if rising_edge(clk0) then
      if aux_reset = '0' then
        if decoded_dds_profile then
          aux_profile_state <= bus_in(2 downto 0);
        end if;
        profile_pin         <= B"000";  -- <= aux_profile_state
      else
        aux_profile_state   <= B"000";
      end if;

    end if;
  end process;


-------------------------------------------------------------------------------
-- Clock divider for the FIFO
-------------------------------------------------------------------------------
  clk_divider : process(clk0)
  begin

    if rising_edge(clk0) then
      aux_clk_state_cur <= aux_clk_state;
    end if;

    if aux_reset = '1' then
      aux_clk_state_cur <= B"00";
    end if;

    case aux_clk_state_cur is
      when B"00"  => aux_clk       <= '0';
                     aux_clk_state <= B"01";
      when B"01"  => aux_clk       <= '1';
                     aux_clk_state <= B"00";
      when others => aux_clk_state <= B"00";

    end case;
  end process;

-------------------------------------------------------------------------------
-- Phase register control
-------------------------------------------------------------------------------
 aux_phase_addend_in(PHASE_DATA_WIDTH-1 downto PHASE_DATA_WIDTH-DATAWIDTH) <= bus_in(DATAWIDTH -1 downto 0);
 aux_phase_addend_in(PHASE_DATA_WIDTH-DATAWIDTH-1 downto 0)              <= X"0000";

  load_phase : process(clk0)
  begin
    -- This won't work
    if rising_edge(clk0) then
      if decoded_pulse_phase and aux_phase_set_current_in = '1' then
        aux_phase_set_current_in <= '1';
      else
        aux_phase_set_current_in <= '0';
      end if;

      if decoded_load_phase and aux_phase_set_current_in = '1' then
        aux_phase_wren_in <= '1';
      else
        aux_phase_wren_in <= '0';
      end if;
    end if;
  end process;
end behaviour;
