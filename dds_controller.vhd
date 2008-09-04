-- -*- mode: Vhdl -*-
-- Time-stamp: "2008-07-12 16:58:55 c704271"
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

    --  in now used for debug_out
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
    sdo_pin       : out std_logic_vector(1 downto 0);
-- sdi_pin : out std_logic;
    sclk_pin      : out std_logic;
    ioreset_pin   : out std_logic;
    dds_reset_pin : out std_logic;

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
  signal aux_ser_state              : std_logic_vector(3 downto 0);
  signal aux_ser_cur_state          : std_logic_vector(3 downto 0);
  signal aux_ser_fifo_active        : std_logic;
  signal aux_ser_data               : std_logic_vector(DATAWIDTH-1 downto 0);
  -- aux_signals for FIFO control
  signal aux_rd_fifo                : std_logic;
  signal aux_wr_fifo                : std_logic;
  signal aux_fifo_empty             : std_logic;
  signal aux_fifo_out               : std_logic_vector(DATAWIDTH-1 downto 0);
  signal aux_fifo_state             : std_logic_vector(3 downto 0);
  signal aux_fifo_cur_state         : std_logic_vector(3 downto 0);
  -- aux signals for the phase registers
--  signal aux_phase_address_in       : std_logic_vector(PHASE_ADDRESS_WIDTH-1 downto 0);
  signal aux_phase_state            : std_logic_vector(3 downto 0) := B"0000";
  signal aux_phase_cur_state        : std_logic_vector(3 downto 0) := B"0000";
  signal aux_phase_phase_in         : std_logic_vector(PHASE_DATA_WIDTH-1 downto 0);
-- signal aux_phase_phase_reg : std_logic_vector(PHASE_DATA_WIDTH-1 downto 0);
  signal aux_phase_addend_in        : std_logic_vector(PHASE_DATA_WIDTH-1 downto 0);
  signal aux_phase_set_current_in   : std_logic;
  signal aux_phase_phase_adjust_out : std_logic_vector(PHASE_ADJUST_WIDTH-1 downto 0);
  signal aux_phase_wren_in          : std_logic;
  signal aux_phase_unused_port      : std_logic                    := '0';
--  signal aux_phase_adjust_out       : std_logic_vector(PHASE_ADJUST_WIDTH-1 downto 0);
  signal aux_phase_phase_reg_lower  : std_logic_vector(DATAWIDTH-1 downto 0);
  signal aux_phase_phase_reg_upper  : std_logic_vector(DATAWIDTH-1 downto 0);
  signal aux_phase_ioup             : std_logic;
  -- aux signals for the dds ioupdate
  signal aux_profile_state          : std_logic_vector(2 downto 0);
  --- The opcode from the bus
  alias opcode_data is bus_in(BUSWIDTH-1 downto BUSWIDTH-OPCODE_WIDTH);
  -- The address from the bus
  alias address_data is bus_in(BUSWIDTH-OPCODE_WIDTH-2 downto BUSWIDTH-OPCODE_WIDTH-ADDRESWIDTH - 1);
  -- The handshake data from the bus
--  alias data_avail is bus_in(BUSWIDTH-OPCODE_WIDTH-ADDRESWIDTH-1);
  alias data_avail is bus_in(BUSWIDTH-OPCODE_WIDTH-1);
  -- The phase register from the bus
  alias bus_phase_address_in is bus_in(DATAWIDTH+PHASE_ADDRESS_WIDTH-1 downto DATAWIDTH);
--  alias bus_phase_set_current is bus_in(DATAWIDTH+PHASE_ADDRESS_WIDTH);
  alias bus_phase_wren_in is bus_in(DATAWIDTH+PHASE_ADDRESS_WIDTH+1);
  --- The async decoded signals
  signal decoded_reset              : boolean;
  signal decoded_fifo_wr            : boolean;
  signal decoded_dds_addr           : boolean;
  signal decoded_dds_profile        : boolean;
  signal decoded_dac_amplitude      : boolean;
  signal decoded_dds_phase          : boolean;
  signal decoded_dds_update         : boolean;
  signal decoded_load_phase         : boolean;
  signal decoded_pulse_phase        : boolean;
  signal address_bit                : boolean;
  signal avail_bool                 : boolean;
  signal aux_clk_state_cur          : unsigned(1 downto 0);
  signal aux_clk_state              : unsigned(1 downto 0);
  signal aux_clk                    : std_logic;


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
  drover_pin    <= '0';
  drctl_pin     <= '0';
  drhold_pin    <= '0';
  osk_pin       <= '0';
  dds_reset_pin <= '0';

------------------------------------------------------------------------------
-- Asynchronious decoding
-------------------------------------------------------------------------------

--  address_bit           <= true;
  address_bit <= (address_data = address_in); -- when USE_ADDRESSING else true;
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

-------------------------------------------------------------------------------
-- Asynchronious reset
-------------------------------------------------------------------------------
  aux_ser_reset <= '1' when decoded_reset else '0';
  aux_reset     <= '1' when decoded_reset else '0';

-------------------------------------------------------------------------------
-- Asynchronous dds cs and pargain pin
-------------------------------------------------------------------------------
  cs_pin      <= '0'when decoded_dds_update or (aux_ser_cs = '0') else '1';
  pargain_pin <= B"01";                 -- Set the paralle data source to phase

-------------------------------------------------------------------------------
-- Asynchronious control the parallel data out
-------------------------------------------------------------------------------
--  parallel_data <= bus_in(DATAWIDTH-1 downto 0);
  parallel_data <= aux_phase_phase_adjust_out when decoded_pulse_phase or decoded_dds_update
                   else bus_in(DATAWIDTH-1 downto 0);

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
      address_in       => bus_phase_address_in,
      phase_in         => aux_phase_phase_in,
      addend_in        => aux_phase_phase_reg_upper & aux_phase_phase_reg_lower,
      set_current_in   => aux_phase_set_current_in,
      phase_adjust_out => aux_phase_phase_adjust_out,
      wren_in          => aux_phase_wren_in,
      unused_port      => aux_phase_unused_port
      );

-------------------------------------------------------------------------------
-- Serial bus control
-------------------------------------------------------------------------------

-- Generate a state machine for the serial port.
-- First the adrress byte is taken from the BUS and then the FIFO is emptied.
  state_control : process(clk0)
  begin
    if rising_edge(clk0) and aux_reset = '0' and aux_ser_enable = '1' then
      aux_ser_cur_state <= aux_ser_state;
    end if;
    if aux_ser_enable = '0' then
      aux_ser_cur_state <= B"0000";
    end if;
    if aux_reset = '1' then
      aux_ser_cur_state <= B"0000";
    end if;
  end process;

  debug_out(2) <= '1' when decoded_fifo_wr else '0';
  serial_control : process(aux_ser_cur_state)
  begin

    case aux_ser_cur_state is
      -- send an ioreset before ???
      when B"0000" => aux_rd_fifo <= '0';  -- Load the address byte
                      aux_ser_act   <= '0';
                      aux_ser_load  <= '0';
                      aux_ser_ovr   <= BYTE_OVERRUN;
                      aux_ser_state <= B"0001";
                      aux_ser_data  <= bus_in(DATAWIDTH -1 downto 0);
                      ioreset_pin   <= '1';
                      aux_ser_cs    <= '1';

      when B"0001" => aux_rd_fifo <= '0';  -- Load the address byte
                      aux_ser_act   <= '0';
                      aux_ser_load  <= '1';
                      aux_ser_ovr   <= BYTE_OVERRUN;
                      aux_ser_state <= B"0010";
                      aux_ser_data  <= bus_in(DATAWIDTH -1 downto 0);
                      ioreset_pin   <= '0';
                      aux_ser_cs    <= '0';

      when B"0010" => aux_rd_fifo <= '0';  -- Wait until the address byte is sent
                      aux_ser_act  <= '1';
                      aux_ser_load <= '0';
                      ioreset_pin  <= '0';
                      aux_ser_ovr  <= BYTE_OVERRUN;
                      aux_ser_data <= bus_in(DATAWIDTH -1 downto 0);
                      if aux_ser_done = '1' then
                        aux_ser_state <= B"0011";
                      else
                        aux_ser_state <= B"0010";
                      end if;
                      aux_ser_cs <= '0';

      when B"0011" => aux_rd_fifo <= '0';  -- Load the FIFO word
                      aux_ser_act   <= '0';
                      aux_ser_load  <= '1';
                      aux_ser_ovr   <= FULL_OVERRUN;
                      ioreset_pin   <= '0';
                      aux_ser_state <= B"0100";
                      aux_ser_data  <= aux_fifo_out;
                      aux_ser_cs    <= '0';
                      -- Wait until the FIFO word is sent / loop until FIFO is empty

      when B"0100" => aux_rd_fifo <= '0';
                      aux_ser_act  <= '1';
                      aux_ser_ovr  <= FULL_OVERRUN;
                      aux_ser_data <= aux_fifo_out;
                      aux_ser_load <= '0';
                      ioreset_pin  <= '0';
                      if aux_ser_done = '1' then
                        aux_ser_state <= B"0101";
                      else
                        aux_ser_state <= B"0100";
                      end if;
                      aux_ser_cs <= '0';

      when B"0101" => if aux_fifo_empty = '1' then
                        aux_rd_fifo   <= '0';
                        aux_ser_state <= B"1111";
                      else
                        aux_rd_fifo   <= '1';
                        aux_ser_state <= B"0110";
                      end if;
                      ioreset_pin  <= '0';
                      aux_ser_act  <= '0';
                      aux_ser_load <= '0';
                      aux_ser_ovr  <= FULL_OVERRUN;
                      aux_ser_data <= aux_fifo_out;
                      aux_ser_cs   <= '0';

      when B"0110" => if aux_fifo_empty = '1' then
                        aux_ser_state <= B"1111";
                      else
                        aux_ser_state <= B"0111";
                      end if;  -- Wait until the FIFO has set the data
                      aux_ser_data <= aux_fifo_out;
                      aux_ser_ovr  <= FULL_OVERRUN;
                      aux_ser_load <= '1';
                      ioreset_pin  <= '0';
                      aux_ser_act  <= '0';
                      aux_rd_fifo  <= '1';
                      aux_ser_cs   <= '0';
      when B"0111" => if aux_fifo_empty = '1' then
                        aux_ser_state <= B"1111";
                      else
                        aux_ser_state <= B"1000";
                      end if;  -- Wait until the FIFO has set the data
                      aux_ser_data <= aux_fifo_out;
                      aux_ser_ovr  <= FULL_OVERRUN;
                      aux_ser_load <= '1';
                      ioreset_pin  <= '0';
                      aux_ser_act  <= '0';
                      aux_rd_fifo  <= '1';
                      aux_ser_cs   <= '0';

      when B"1000" => aux_ser_state <= B"1001";

                      aux_ser_data <= aux_fifo_out;
                      aux_ser_ovr  <= FULL_OVERRUN;
                      aux_ser_load <= '1';
                      ioreset_pin  <= '0';
                      aux_ser_act  <= '0';
                      aux_rd_fifo  <= '1';
                      aux_ser_cs   <= '0';

      when B"1001" => if aux_fifo_empty = '1' then
                        aux_ser_state <= B"1111";
                      else
                        aux_ser_state <= B"0011";
                      end if;  -- Wait until the FIFO has set the data
                      aux_ser_data <= aux_fifo_out;
                      aux_ser_ovr  <= FULL_OVERRUN;
                      aux_ser_load <= '1';
                      ioreset_pin  <= '0';
                      aux_ser_act  <= '0';
                      aux_rd_fifo  <= '0';
                      aux_ser_cs   <= '0';


      when B"1111" => aux_rd_fifo <= '0';
                      aux_ser_state <= B"1111";  -- Wait until the opcode changes
                      ioreset_pin   <= '0';
                      aux_ser_act   <= '0';
                      aux_ser_load  <= '0';
                      aux_ser_cs    <= '1';
                      aux_ser_ovr   <= FULL_OVERRUN;
                      aux_ser_data  <= bus_in(DATAWIDTH -1 downto 0);
      when others => aux_ser_state <= B"1111";   -- generate initial state
                     aux_ser_load <= '0';
                     aux_rd_fifo  <= '0';
                     ioreset_pin  <= '0';
                     aux_ser_act  <= '0';
                     aux_ser_cs   <= '1';
                     aux_ser_ovr  <= FULL_OVERRUN;
                     aux_ser_data <= bus_in(DATAWIDTH -1 downto 0);
    end case;
  end process;

-------------------------------------------------------------------------------
-- Generate the WR signal for the DAC
-------------------------------------------------------------------------------
  set_dac : process(clk0)
  begin
    if rising_edge(clk0) then
      if decoded_dac_amplitude then
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
  -- rewrite again - this is really crap !!!!
  state_fifo : process(clk0)
  begin
    if rising_edge(clk0) then
      if decoded_fifo_wr then
        aux_fifo_cur_state <= aux_fifo_state;
      else
        aux_fifo_cur_state <= B"0000";
      end if;
    end if;
  end process;

  control_fifo : process(clk0)
  begin
    case aux_fifo_cur_state is
      when B"0000" => aux_wr_fifo <= '0';
                      if aux_clk = '0' then
                        aux_fifo_state <= B"0000";
                      else
                        aux_fifo_state <= B"0001";
                      end if;

      when B"0001" => aux_wr_fifo <= '0';
                      if aux_clk = '0' then
                        aux_fifo_state <= B"0010";
                      else
                        aux_fifo_state <= B"0001";
                      end if;

      when B"0010" => aux_wr_fifo <= '1';
                      aux_fifo_state <= B"0011";

      when B"0011" => aux_wr_fifo <= '1';
                      aux_fifo_state <= B"0100";

      when B"0100" => aux_wr_fifo <= '0';
                      aux_fifo_state <= B"0100";

      when others => aux_wr_fifo <= '0';
                     aux_fifo_state <= B"0000";
    end case;

  end process;

-------------------------------------------------------------------------------
-- Change profile pins and send ioupdate
-------------------------------------------------------------------------------
  control_profile : process(clk0)
  begin
    if rising_edge(clk0) then
      if decoded_dds_profile then
        profile_pin <= bus_in(2 downto 0);
--      else
--        profile_pin <= profile_pin;
      end if;
    end if;
  end process;

--  profile_pin <= B"000";
  -- purpose: Set ioupdate sequentially for lower jitter
  -- type   : sequential
  -- inputs : clk0, decoded_dds_update, aux_phase_ioup
  -- outputs: ioup_pin
  control_ioup : process (clk0)
  begin  -- process control_ioup
    if rising_edge(clk0) then
      if decoded_dds_update or aux_phase_ioup = '1' then
        ioup_pin <= '1';
      else
        ioup_pin <= '0';
      end if;
    end if;
  end process control_ioup;

-------------------------------------------------------------------------------
-- Clock divider for the FIFO
-------------------------------------------------------------------------------
  clk_divider : process(clk0)
  begin
    if aux_reset = '1' then
      aux_clk_state_cur <= B"00";
    elsif rising_edge(clk0) then
      aux_clk_state_cur <= aux_clk_state;
      case aux_clk_state_cur is
        when B"00" => aux_clk <= '0';
                      aux_clk_state <= B"01";
        when B"01" => aux_clk <= '1';
                      aux_clk_state <= B"00";
        when others => aux_clk_state <= B"00";
                       aux_clk <= '0';
      end case;
    end if;
  end process;

-------------------------------------------------------------------------------
-- Phase register control
-------------------------------------------------------------------------------
  aux_phase_phase_in(PHASE_DATA_WIDTH-1 downto PHASE_DATA_WIDTH-DATAWIDTH) <= bus_in(DATAWIDTH -1 downto 0);
  aux_phase_phase_in(PHASE_DATA_WIDTH-DATAWIDTH-1 downto 0)                <= X"0000";

  state_phase : process(clk0)
  begin
    if rising_edge(clk0) then
      if decoded_pulse_phase then
        aux_phase_cur_state <= aux_phase_state;
      else
        aux_phase_cur_state <= B"0000";
      end if;
    end if;
  end process;

  -- The transfer to the bus_data is quite slow needs 3 clock cycles at 100MHz!
  pulse_phase : process (clk0)
  begin
    case aux_phase_cur_state is
      -- Load the phase register
      when B"0000" => aux_phase_state <= B"0001";
                      aux_phase_set_current_in <= '0';
                      txen_pin                 <= '0';
                      aux_phase_ioup           <= '0';
      when B"0001" => aux_phase_state <= B"0010";
                      aux_phase_set_current_in <= '1';
                      txen_pin                 <= '0';
                      aux_phase_ioup           <= '0';
                      -- wait for the data to be transferred to the bus
      when B"0010" => aux_phase_state <= B"0011";
                      aux_phase_set_current_in <= '0';
                      txen_pin                 <= '0';
                      aux_phase_ioup           <= '0';
      when B"0011" => aux_phase_state <= B"0100";
                      aux_phase_set_current_in <= '0';
                      txen_pin                 <= '0';
                      aux_phase_ioup           <= '0';
      when B"0100" => aux_phase_state <= B"0101";
                      aux_phase_set_current_in <= '0';
                      txen_pin                 <= '0';
                      aux_phase_ioup           <= '0';
      when B"0101" => aux_phase_state <= B"0110";
                      aux_phase_set_current_in <= '0';
                      txen_pin                 <= '0';
                      aux_phase_ioup           <= '0';
                      -- Set the phase of the DDS
      when B"0110" => aux_phase_state <= B"0111";
                      aux_phase_set_current_in <= '0';
                      txen_pin                 <= '1';
                      aux_phase_ioup           <= '0';
      when B"0111" => aux_phase_state <= B"1000";
                      aux_phase_set_current_in <= '0';
                      txen_pin                 <= '1';
                      aux_phase_ioup           <= '0';
      when B"1000" => aux_phase_state <= B"1111";
                      aux_phase_set_current_in <= '0';
                      txen_pin                 <= '0';
                      aux_phase_ioup           <= '1';
      when B"1111" => aux_phase_state <= B"1111";
                      aux_phase_set_current_in <= '0';
                      txen_pin                 <= '0';
                      aux_phase_ioup           <= '0';
      when others => aux_phase_state <= B"1111";
                     aux_phase_set_current_in <= '0';
                     txen_pin                 <= '0';
                     aux_phase_ioup           <= '0';
    end case;
  end process;

  load_phase : process (clk0)
  begin  -- process load_phase
    if rising_edge(clk0) then
      if decoded_load_phase and bus_in(21) = '1' then
        aux_phase_wren_in <= '1';
      else
        aux_phase_wren_in <= '0';
      end if;

      if decoded_load_phase then
        if bus_in(20) = '0' then
          aux_phase_phase_reg_upper <= bus_in(DATAWIDTH - 1 downto 0);
        else
          aux_phase_phase_reg_lower <= bus_in(DATAWIDTH - 1 downto 0);
        end if;
      end if;
    end if;
  end process load_phase;



end behaviour;
