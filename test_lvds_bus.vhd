<session jtag_chain="" jtag_device="" sof_file="" top_level_entity="dds_controller">
  <display_tree gui_logging_enabled="0">
    <display_branch instance="auto_signaltap_0" signal_set="USE_GLOBAL_TEMP" trigger="USE_GLOBAL_TEMP"/>
  </display_tree>
  <instance compilation_mode="full" entity_name="sld_signaltap" is_auto_node="yes" is_expanded="true" name="auto_signaltap_0" source_file="sld_signaltap.vhd">
    <node_ip_info instance_id="0" mfg_id="110" node_id="0" version="6"/>
    <signal_set global_temp="1" is_expanded="true" name="signal_set: 2008/05/26 13:30:36  #0">
      <clock name="clk0" polarity="posedge" tap_mode="classic"/>
      <config ram_type="M4K" reserved_data_nodes="0" reserved_trigger_nodes="0" sample_depth="512" trigger_in_enable="no" trigger_in_node="decoded_reset" trigger_in_tap_mode="classic" trigger_out_enable="no"/>
      <top_entity/>
      <signal_vec>
        <trigger_input_vec>
          <wire name="aux_clk" tap_mode="classic" type="register"/>
          <wire name="aux_fifo_cur_state[0]" tap_mode="classic" type="register"/>
          <wire name="aux_fifo_cur_state[1]" tap_mode="classic" type="register"/>
          <wire name="aux_fifo_cur_state[2]" tap_mode="classic" type="register"/>
          <wire name="aux_fifo_cur_state[3]" tap_mode="classic" type="register"/>
          <wire name="aux_ser_cur_state[0]" tap_mode="classic" type="register"/>
          <wire name="aux_ser_cur_state[1]" tap_mode="classic" type="register"/>
          <wire name="aux_ser_cur_state[2]" tap_mode="classic" type="register"/>
          <wire name="aux_ser_cur_state[3]" tap_mode="classic" type="register"/>
          <wire name="bus_in[0]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[10]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[11]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[12]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[13]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[14]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[15]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[16]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[17]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[18]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[19]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[1]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[20]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[21]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[22]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[23]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[24]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[25]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[26]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[27]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[28]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[29]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[2]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[30]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[31]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[3]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[4]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[5]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[6]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[7]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[8]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[9]" tap_mode="classic" type="input pin"/>
          <wire name="cs_pin" tap_mode="classic" type="output pin"/>
          <wire name="dds_serial_bus:dds_serial_out|data[0]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[10]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[11]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[12]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[13]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[14]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[15]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[1]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[2]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[3]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[4]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[5]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[6]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[7]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[8]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[9]" tap_mode="classic" type="combinatorial"/>
          <wire name="decoded_dds_addr" tap_mode="classic" type="combinatorial"/>
          <wire name="decoded_dds_update" tap_mode="classic" type="combinatorial"/>
          <wire name="decoded_fifo_wr" tap_mode="classic" type="combinatorial"/>
          <wire name="decoded_reset" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[0]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[10]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[11]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[12]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[13]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[14]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[15]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[1]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[2]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[3]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[4]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[5]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[6]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[7]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[8]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[9]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|empty" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|rdreq" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|wrreq" tap_mode="classic" type="combinatorial"/>
          <wire name="ioreset_pin" tap_mode="classic" type="output pin"/>
          <wire name="ioup_pin" tap_mode="classic" type="output pin"/>
          <wire name="profile_pin[0]" tap_mode="classic" type="output pin"/>
          <wire name="profile_pin[1]" tap_mode="classic" type="output pin"/>
          <wire name="profile_pin[2]" tap_mode="classic" type="output pin"/>
          <wire name="sclk_pin" tap_mode="classic" type="output pin"/>
          <wire name="sdo_pin[0]" tap_mode="classic" type="output pin"/>
          <wire name="sdo_pin[1]" tap_mode="classic" type="output pin"/>
        </trigger_input_vec>
        <data_input_vec>
          <wire name="aux_clk" tap_mode="classic" type="register"/>
          <wire name="aux_fifo_cur_state[0]" tap_mode="classic" type="register"/>
          <wire name="aux_fifo_cur_state[1]" tap_mode="classic" type="register"/>
          <wire name="aux_fifo_cur_state[2]" tap_mode="classic" type="register"/>
          <wire name="aux_fifo_cur_state[3]" tap_mode="classic" type="register"/>
          <wire name="aux_ser_cur_state[0]" tap_mode="classic" type="register"/>
          <wire name="aux_ser_cur_state[1]" tap_mode="classic" type="register"/>
          <wire name="aux_ser_cur_state[2]" tap_mode="classic" type="register"/>
          <wire name="aux_ser_cur_state[3]" tap_mode="classic" type="register"/>
          <wire name="bus_in[0]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[10]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[11]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[12]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[13]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[14]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[15]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[16]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[17]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[18]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[19]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[1]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[20]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[21]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[22]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[23]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[24]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[25]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[26]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[27]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[28]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[29]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[2]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[30]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[31]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[3]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[4]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[5]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[6]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[7]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[8]" tap_mode="classic" type="input pin"/>
          <wire name="bus_in[9]" tap_mode="classic" type="input pin"/>
          <wire name="cs_pin" tap_mode="classic" type="output pin"/>
          <wire name="dds_serial_bus:dds_serial_out|data[0]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[10]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[11]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[12]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[13]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[14]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[15]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[1]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[2]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[3]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[4]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[5]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[6]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[7]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[8]" tap_mode="classic" type="combinatorial"/>
          <wire name="dds_serial_bus:dds_serial_out|data[9]" tap_mode="classic" type="combinatorial"/>
          <wire name="decoded_dds_addr" tap_mode="classic" type="combinatorial"/>
          <wire name="decoded_dds_update" tap_mode="classic" type="combinatorial"/>
          <wire name="decoded_fifo_wr" tap_mode="classic" type="combinatorial"/>
          <wire name="decoded_reset" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[0]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[10]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[11]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[12]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[13]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[14]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[15]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[1]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[2]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[3]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[4]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[5]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[6]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[7]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[8]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|data[9]" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|empty" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|rdreq" tap_mode="classic" type="combinatorial"/>
          <wire name="fifo_mf:fifo_mf_inst|wrreq" tap_mode="classic" type="combinatorial"/>
          <wire name="ioreset_pin" tap_mode="classic" type="output pin"/>
          <wire name="ioup_pin" tap_mode="classic" type="output pin"/>
          <wire name="profile_pin[0]" tap_mode="classic" type="output pin"/>
          <wire name="profile_pin[1]" tap_mode="classic" type="output pin"/>
          <wire name="profile_pin[2]" tap_mode="classic" type="output pin"/>
          <wire name="sclk_pin" tap_mode="classic" type="output pin"/>
          <wire name="sdo_pin[0]" tap_mode="classic" type="output pin"/>
          <wire name="sdo_pin[1]" tap_mode="classic" type="output pin"/>
        </data_input_vec>
      </signal_vec>
      <presentation>
        <data_view>
          <bus is_signal_inverted="no" link="all" name="bus_in" order="lsb_to_msb" radix="hex" state="collapse" type="input pin">
            <net is_signal_inverted="no" name="bus_in[0]"/>
            <net is_signal_inverted="no" name="bus_in[1]"/>
            <net is_signal_inverted="no" name="bus_in[2]"/>
            <net is_signal_inverted="no" name="bus_in[3]"/>
            <net is_signal_inverted="no" name="bus_in[4]"/>
            <net is_signal_inverted="no" name="bus_in[5]"/>
            <net is_signal_inverted="no" name="bus_in[6]"/>
            <net is_signal_inverted="no" name="bus_in[7]"/>
            <net is_signal_inverted="no" name="bus_in[8]"/>
            <net is_signal_inverted="no" name="bus_in[9]"/>
            <net is_signal_inverted="no" name="bus_in[10]"/>
            <net is_signal_inverted="no" name="bus_in[11]"/>
            <net is_signal_inverted="no" name="bus_in[12]"/>
            <net is_signal_inverted="no" name="bus_in[13]"/>
            <net is_signal_inverted="no" name="bus_in[14]"/>
            <net is_signal_inverted="no" name="bus_in[15]"/>
            <net is_signal_inverted="no" name="bus_in[16]"/>
            <net is_signal_inverted="no" name="bus_in[17]"/>
            <net is_signal_inverted="no" name="bus_in[18]"/>
            <net is_signal_inverted="no" name="bus_in[19]"/>
            <net is_signal_inverted="no" name="bus_in[20]"/>
            <net is_signal_inverted="no" name="bus_in[21]"/>
            <net is_signal_inverted="no" name="bus_in[22]"/>
            <net is_signal_inverted="no" name="bus_in[23]"/>
            <net is_signal_inverted="no" name="bus_in[24]"/>
            <net is_signal_inverted="no" name="bus_in[25]"/>
            <net is_signal_inverted="no" name="bus_in[26]"/>
            <net is_signal_inverted="no" name="bus_in[27]"/>
            <net is_signal_inverted="no" name="bus_in[28]"/>
            <net is_signal_inverted="no" name="bus_in[29]"/>
            <net is_signal_inverted="no" name="bus_in[30]"/>
            <net is_signal_inverted="no" name="bus_in[31]"/>
          </bus>
          <net is_signal_inverted="no" name="decoded_dds_addr"/>
          <net is_signal_inverted="no" name="decoded_fifo_wr"/>
          <net is_signal_inverted="no" name="decoded_reset"/>
          <bus is_signal_inverted="no" link="all" name="sdo_pin" order="msb_to_lsb" radix="hex" state="collapse" type="output pin">
            <net is_signal_inverted="no" name="sdo_pin[0]"/>
            <net is_signal_inverted="no" name="sdo_pin[1]"/>
          </bus>
          <net is_signal_inverted="no" name="sclk_pin"/>
          <net is_signal_inverted="no" name="ioup_pin"/>
          <net is_signal_inverted="no" name="decoded_dds_update"/>
          <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|empty"/>
          <bus is_signal_inverted="no" link="all" name="fifo_mf:fifo_mf_inst|data" order="lsb_to_msb" radix="hex" state="collapse" type="combinatorial">
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[0]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[1]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[2]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[3]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[4]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[5]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[6]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[7]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[8]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[9]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[10]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[11]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[12]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[13]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[14]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[15]"/>
          </bus>
          <bus is_signal_inverted="no" link="all" name="dds_serial_bus:dds_serial_out|data" order="lsb_to_msb" radix="hex" state="collapse" type="combinatorial">
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[0]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[1]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[2]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[3]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[4]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[5]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[6]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[7]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[8]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[9]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[10]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[11]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[12]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[13]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[14]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[15]"/>
          </bus>
          <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|rdreq"/>
          <net is_signal_inverted="no" name="aux_clk"/>
          <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|wrreq"/>
          <bus is_signal_inverted="no" link="all" name="aux_fifo_cur_state" order="lsb_to_msb" radix="hex" state="collapse" type="register">
            <net is_signal_inverted="no" name="aux_fifo_cur_state[0]"/>
            <net is_signal_inverted="no" name="aux_fifo_cur_state[1]"/>
            <net is_signal_inverted="no" name="aux_fifo_cur_state[2]"/>
            <net is_signal_inverted="no" name="aux_fifo_cur_state[3]"/>
          </bus>
          <bus is_signal_inverted="no" link="all" name="aux_ser_cur_state" order="lsb_to_msb" radix="hex" state="collapse" type="register">
            <net is_signal_inverted="no" name="aux_ser_cur_state[0]"/>
            <net is_signal_inverted="no" name="aux_ser_cur_state[1]"/>
            <net is_signal_inverted="no" name="aux_ser_cur_state[2]"/>
            <net is_signal_inverted="no" name="aux_ser_cur_state[3]"/>
          </bus>
          <net is_signal_inverted="no" name="cs_pin"/>
          <net is_signal_inverted="no" name="ioreset_pin"/>
          <bus is_signal_inverted="no" link="all" name="profile_pin" order="lsb_to_msb" radix="hex" state="collapse" type="output pin">
            <net is_signal_inverted="no" name="profile_pin[0]"/>
            <net is_signal_inverted="no" name="profile_pin[1]"/>
            <net is_signal_inverted="no" name="profile_pin[2]"/>
          </bus>
        </data_view>
        <setup_view>
          <bus is_signal_inverted="no" link="all" name="bus_in" order="lsb_to_msb" radix="hex" state="collapse" type="input pin">
            <net is_signal_inverted="no" name="bus_in[0]"/>
            <net is_signal_inverted="no" name="bus_in[1]"/>
            <net is_signal_inverted="no" name="bus_in[2]"/>
            <net is_signal_inverted="no" name="bus_in[3]"/>
            <net is_signal_inverted="no" name="bus_in[4]"/>
            <net is_signal_inverted="no" name="bus_in[5]"/>
            <net is_signal_inverted="no" name="bus_in[6]"/>
            <net is_signal_inverted="no" name="bus_in[7]"/>
            <net is_signal_inverted="no" name="bus_in[8]"/>
            <net is_signal_inverted="no" name="bus_in[9]"/>
            <net is_signal_inverted="no" name="bus_in[10]"/>
            <net is_signal_inverted="no" name="bus_in[11]"/>
            <net is_signal_inverted="no" name="bus_in[12]"/>
            <net is_signal_inverted="no" name="bus_in[13]"/>
            <net is_signal_inverted="no" name="bus_in[14]"/>
            <net is_signal_inverted="no" name="bus_in[15]"/>
            <net is_signal_inverted="no" name="bus_in[16]"/>
            <net is_signal_inverted="no" name="bus_in[17]"/>
            <net is_signal_inverted="no" name="bus_in[18]"/>
            <net is_signal_inverted="no" name="bus_in[19]"/>
            <net is_signal_inverted="no" name="bus_in[20]"/>
            <net is_signal_inverted="no" name="bus_in[21]"/>
            <net is_signal_inverted="no" name="bus_in[22]"/>
            <net is_signal_inverted="no" name="bus_in[23]"/>
            <net is_signal_inverted="no" name="bus_in[24]"/>
            <net is_signal_inverted="no" name="bus_in[25]"/>
            <net is_signal_inverted="no" name="bus_in[26]"/>
            <net is_signal_inverted="no" name="bus_in[27]"/>
            <net is_signal_inverted="no" name="bus_in[28]"/>
            <net is_signal_inverted="no" name="bus_in[29]"/>
            <net is_signal_inverted="no" name="bus_in[30]"/>
            <net is_signal_inverted="no" name="bus_in[31]"/>
          </bus>
          <net is_signal_inverted="no" name="decoded_dds_addr"/>
          <net is_signal_inverted="no" name="decoded_fifo_wr"/>
          <net is_signal_inverted="no" name="decoded_reset"/>
          <bus is_signal_inverted="no" link="all" name="sdo_pin" order="msb_to_lsb" radix="hex" state="collapse" type="output pin">
            <net is_signal_inverted="no" name="sdo_pin[0]"/>
            <net is_signal_inverted="no" name="sdo_pin[1]"/>
          </bus>
          <net is_signal_inverted="no" name="sclk_pin"/>
          <net is_signal_inverted="no" name="ioup_pin"/>
          <net is_signal_inverted="no" name="decoded_dds_update"/>
          <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|empty"/>
          <bus is_signal_inverted="no" link="all" name="fifo_mf:fifo_mf_inst|data" order="lsb_to_msb" radix="hex" state="collapse" type="combinatorial">
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[0]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[1]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[2]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[3]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[4]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[5]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[6]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[7]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[8]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[9]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[10]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[11]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[12]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[13]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[14]"/>
            <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|data[15]"/>
          </bus>
          <bus is_signal_inverted="no" link="all" name="dds_serial_bus:dds_serial_out|data" order="lsb_to_msb" radix="hex" state="collapse" type="combinatorial">
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[0]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[1]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[2]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[3]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[4]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[5]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[6]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[7]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[8]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[9]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[10]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[11]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[12]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[13]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[14]"/>
            <net is_signal_inverted="no" name="dds_serial_bus:dds_serial_out|data[15]"/>
          </bus>
          <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|rdreq"/>
          <net is_signal_inverted="no" name="aux_clk"/>
          <net is_signal_inverted="no" name="fifo_mf:fifo_mf_inst|wrreq"/>
          <bus is_signal_inverted="no" link="all" name="aux_fifo_cur_state" order="lsb_to_msb" radix="hex" state="collapse" type="register">
            <net is_signal_inverted="no" name="aux_fifo_cur_state[0]"/>
            <net is_signal_inverted="no" name="aux_fifo_cur_state[1]"/>
            <net is_signal_inverted="no" name="aux_fifo_cur_state[2]"/>
            <net is_signal_inverted="no" name="aux_fifo_cur_state[3]"/>
          </bus>
          <bus is_signal_inverted="no" link="all" name="aux_ser_cur_state" order="lsb_to_msb" radix="hex" state="collapse" type="register">
            <net is_signal_inverted="no" name="aux_ser_cur_state[0]"/>
            <net is_signal_inverted="no" name="aux_ser_cur_state[1]"/>
            <net is_signal_inverted="no" name="aux_ser_cur_state[2]"/>
            <net is_signal_inverted="no" name="aux_ser_cur_state[3]"/>
          </bus>
          <net is_signal_inverted="no" name="cs_pin"/>
          <net is_signal_inverted="no" name="ioreset_pin"/>
          <bus is_signal_inverted="no" link="all" name="profile_pin" order="lsb_to_msb" radix="hex" state="collapse" type="output pin">
            <net is_signal_inverted="no" name="profile_pin[0]"/>
            <net is_signal_inverted="no" name="profile_pin[1]"/>
            <net is_signal_inverted="no" name="profile_pin[2]"/>
          </bus>
        </setup_view>
      </presentation>
      <trigger global_temp="1" is_expanded="true" name="trigger: 2008/05/26 13:30:36  #1" position="pre" power_up_trigger_mode="false" segment_size="1" trigger_in="rising edge" trigger_out="active high" trigger_type="circular">
        <power_up_trigger position="pre" trigger_in="dont_care" trigger_out="active high"/>
        <events use_custom_flow_control="no">
          <level enabled="yes" name="condition1" type="basic">
            <power_up enabled="yes">
            </power_up>
            <op_node>
              <op_node left="445" top="253" type="Advanced Trigger Level Result"/>
            </op_node>
          </level>
        </events>
      </trigger>
    </signal_set>
    <position_info>
      <single attribute="active tab" value="1"/>
      <single attribute="data horizontal scroll position" value="0"/>
      <single attribute="data vertical scroll position" value="0"/>
      <single attribute="setup horizontal scroll position" value="0"/>
      <single attribute="setup vertical scroll position" value="0"/>
      <single attribute="zoom level denominator" value="1"/>
      <single attribute="zoom level numerator" value="1"/>
      <single attribute="zoom offset denominator" value="1"/>
      <single attribute="zoom offset numerator" value="130560"/>
    </position_info>
  </instance>
  <mnemonics/>
  <static_plugin_mnemonics/>
  <global_info>
    <single attribute="active instance" value="0"/>
    <single attribute="lock mode" value="36110"/>
    <multi attribute="window position" size="9" value="1032,689,398,124,356,50,124,0,50"/>
  </global_info>
</session>
