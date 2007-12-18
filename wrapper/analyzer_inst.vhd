analyzer_inst : analyzer PORT MAP (
		acq_clk	 => clk0,
		acq_data_in	 => bus_in(31 downto 1),
		acq_trigger_in	 => bus_in(0)
	);
