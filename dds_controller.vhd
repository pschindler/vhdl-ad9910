-- -*- mode: Vhdl -*-
-- Time-stamp: "03-Jan-2008 23:20:17 viellieb"

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

  signal aux_ser_ovr           : std_logic_vector(SER_REGWIDTH-1 downto 0);
  signal aux_ser_state         : std_logic_vector(2 downto 0);
  signal aux_ser_fifo_active   : std_logic;
  signal aux_ser_data          : std_logic_vector(DATAWIDTH-1 downto 0);
  -- aux_signals for FIFO control
  signal aux_rd_fifo           : std_logic;
  signal aux_wr_fifo           : std_logic;
  signal aux_fifo_empty        : std_logic;
  signal aux_fifo_out          : std_logic_vector(DATAWIDTH-1 downto 0);
  -- aux signals for the dds ioupdate
  signal aux_profile_state     : std_logic_vector(2 downto 0);
  --- The opcode from the bus
  alias opcode_data is bus_in(BUSWIDTH-1 downto BUSWIDTH-OPCODE_WIDTH);
  -- The address from the bus
  alias address_data is bus_in(BUSWIDTH-OPCODE_WIDTH-1 downto BUSWIDTH-OPCODE_WIDTH-ADDRESWIDTH);
  -- The handshake data from the bus
  alias data_avail is bus_in(BUSWIDTH-OPCODE_WIDTH-ADDRESWIDTH-1);
  --- The async decoded signals
  signal decoded_reset         : boolean;
  signal decoded_fifo_wr       : boolean;
  signal decoded_dds_addr      : boolean;
  signal decoded_dds_profile   : boolean;
  signal decoded_dac_amplitude : boolean;
  signal decoded_dds_phase     : boolean;
  signal address_bit           : boolean;
  signal avail_bool            : boolean;

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
      active      : in  std_logic;
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
  debug_out(1) <= '1' when decoded_dds_profile else '0';
-- debug_out(2) <= aux_ser_reset;
-- aux_ser_reset <= '1' when decoded_dds_reset else '0';

-- debug_out(2 downto 0) <= aux_ser_state;


------------------------------------------------------------------------------
-- Asynchronious decoding
-------------------------------------------------------------------------------

  decoded_fifo_wr       <= (opcode_data = fifo_wr_opcode) and address_bit and avail_bool;
  decoded_reset         <= (opcode_data = reset_opcode) and address_bit and avail_bool;
  decoded_dds_addr      <= (opcode_data = dds_addr_opcode) and address_bit and avail_bool;
  decoded_dds_profile   <= (opcode_data = dds_profile_opcode) and address_bit and avail_bool;
  decoded_dac_amplitude <= (opcode_data = dac_amplitude_opcode) and address_bit and avail_bool;
  decoded_dds_phase     <= (opcode_data = dds_phase_ctl_opcode) and address_bit and avail_bool;
  aux_ser_enable        <= '1'  when decoded_dds_addr else '0';
  avail_bool            <= true when data_avail = '1' else false;
  address_bit           <= (address_data = address_in) when USE_ADDRESSING else true;
-------------------------------------------------------------------------------
-- Asynchronious reset
-------------------------------------------------------------------------------
aux_ser_reset           <= '1'  when decoded_reset    else '0';
  aux_reset             <= '1'  when decoded_reset    else '0';

-------------------------------------------------------------------------------
-- Asynchronious control the parallel data out
-------------------------------------------------------------------------------
  parallel_data <= bus_in(DATAWIDTH-1 downto 0);
-- parallel_data <= phase_register_out when decoded_dds_phase else bus_in(DATAWIDTH-1 downto 0);

-------------------------------------------------------------------------------
-- The parallel to serial cconverter
-------------------------------------------------------------------------------
  dds_serial_out : dds_serial_bus
    port map(
      reset       => aux_ser_reset,
      wb_clk      => clk0,
      data        => aux_ser_data,
      sdo_out     => sdo_pin(0),
      sclk_out    => sclk_pin,
      load_reg    => aux_ser_load,
      active      => aux_ser_act,
      counter_ovr => aux_ser_ovr,
      done_out    => aux_ser_done
      );
-------------------------------------------------------------------------------
-- The megafuntion FIFO
-------------------------------------------------------------------------------
  fifo_mf_inst   : fifo_mf
    port map (
      aclr        => aux_reset,
      clock       => clk0,
      data        => bus_in(DATAWIDTH-1 downto 0),
      rdreq       => aux_rd_fifo,
      wrreq       => aux_wr_fifo,
      empty       => aux_fifo_empty,
      q           => aux_fifo_out
      );


-------------------------------------------------------------------------------
-- All the control processes
-------------------------------------------------------------------------------

-- Generate a state machine for the serial port.
-- First the adrress byte is taken from the BUS and then the FIFO is emptied.
  serial_control : process(clk0)
  begin
    if rising_edge(clk0) then
      if aux_ser_enable = '1' then
        case aux_ser_state is
          -- send an ioreset before ???
          when B"000" => aux_rd_fifo     <= '0';  -- Load the address byte
                         aux_ser_act     <= '0';
                         aux_ser_load    <= '1';
                         aux_ser_ovr     <= BYTE_OVERRUN;
                         aux_ser_state   <= B"001";
                         aux_ser_data    <= bus_in(DATAWIDTH -1 downto 0);
                         ioreset_pin     <= '1';
          when B"001" => aux_rd_fifo     <= '0';  -- Wait until the address byte is sent
                         aux_ser_act     <= '1';
                         aux_ser_load    <= '0';
                         ioreset_pin     <= '0';
                         if aux_ser_done = '1' then
                           aux_ser_state <= B"010";
                         else
                           aux_ser_state <= B"001";
                         end if;
          when B"010" => aux_rd_fifo     <= '1';  -- Load the FIFO word
                         aux_ser_act     <= '0';
                         aux_ser_load    <= '0';
                         aux_ser_ovr     <= FULL_OVERRUN;
                         ioreset_pin     <= '0';
                         aux_ser_state   <= B"011";
                         aux_ser_data    <= aux_fifo_out;

          when B"011" => aux_ser_state <= B"100";
                         aux_ser_act   <= '0';
                         aux_rd_fifo   <= '0';
                         aux_ser_data  <= aux_fifo_out;
                         ioreset_pin   <= '0';
          when B"100" => aux_ser_state <= B"101";  -- Wait until the FIFO has set the data
                         aux_ser_data  <= aux_fifo_out;
                         ioreset_pin   <= '0';
                         aux_ser_act   <= '0';
          when B"101" => aux_ser_state <= B"110";  -- Wait until the FIFO has set the data
                         aux_ser_data  <= aux_fifo_out;
                         ioreset_pin   <= '0';
                         aux_ser_act   <= '0';
                         -- Wait until the FIFO word is sent / loop until FIFO is empty

          when B"110" => aux_rd_fifo       <= '0';
                         aux_ser_act       <= '1';
                         aux_ser_data      <= aux_fifo_out;
                         aux_ser_load      <= '0';
                         ioreset_pin       <= '0';
                         if aux_ser_done = '1' then
                           if aux_fifo_empty = '1' then
                             aux_ser_state <= B"111";
                           else
                             aux_ser_state <= B"010";
                           end if;
                         end if;
          when B"111" => aux_rd_fifo       <= '0';
                         aux_ser_state     <= B"111";  -- Wait until the opcode changes
                         ioreset_pin       <= '0';
                         aux_ser_act       <= '0';
          when others => aux_ser_state     <= B"000";  -- generate initial state
                         aux_ser_load      <= '0';
                         aux_rd_fifo       <= '0';
                         ioreset_pin       <= '0';
                         aux_ser_act       <= '0';
        end case;
      else
        aux_ser_state                      <= B"000";
      end if;
    end if;
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
  control_fifo : process(clk0)
  begin
    if rising_edge(clk0) then
      if decoded_fifo_wr then
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
      if not decoded_reset then
        if decoded_dds_profile then
          aux_profile_state <= bus_in(2 downto 0);
          ioup_pin          <= '1';
-- discard another beautiuful state machine due to the need for speed
-- profile_pin<=bus_in(2 downto 0);
-- case aux_profile_state is
-- when '0' => ioup_pin<='1';
-- aux_profile_state<='1';
-- when '1' => ioup_pin<='0';
-- aux_profile_state<='0';
-- when others => aux_profile_state<='0';
-- end case;
        else
          ioup_pin          <= '0';
          aux_profile_state <= aux_profile_state;
        end if;
        profile_pin         <= B"000";  -- <= aux_profile_state
      else
        aux_profile_state   <= B"000";
      end if;

    end if;
  end process;


end behaviour;
