library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY wrapper IS

	PORT
	(
		bus_in  : std_logic_vector(31 downto 0);
		clk0	: in std_logic;
		debug_in : in std_logic_vector(3 downto 0);
		cs_pin : out std_logic;
		ioreset_pin : out std_logic;
		ioup_pin : out std_logic;
		sclk_pin : out std_logic;
		sdio_pin : out std_logic;
		sdo : in std_logic;
		dac_clk : out std_logic;
		dac_out: out std_logic_vector(13 downto 0)
	--	sdo_debug : out std_logic
		
	);


END wrapper;


ARCHITECTURE a OF wrapper IS

--component analyzer
--	port (
--		acq_clk : std_logic;
--		acq_data_in : std_logic_vector(30 downto 0);
--		acq_trigger_in: std_logic
--		);
--end component;

BEGIN


--analyzer_inst : analyzer PORT MAP (
--		acq_clk	 => clk0,
--		acq_data_in	 => bus_in(31 downto 1),
--		acq_trigger_in	 => bus_in(0)
--	);

--sdo_debug<=sdo;
ioreset_pin<='0';

--cs_pin <= debug_in(1);
--sclk_pin<=debug_in(2);
--sdio_pin<=debug_in(3);
--ioup_pin<=debug_in(0);


--dac_clk<=clk0;
dac_clk<=bus_in(24);
dac_out(13 downto 6)<=bus_in(23 downto 16);
dac_out(5 downto 0)<=B"111111";

sclk_pin<=bus_in(16);
sdio_pin<=bus_in(17);
cs_pin<=bus_in(18);
ioup_pin<=bus_in(19);

--dac_out<=B"11111111111111";
--dac_out<=B"00000000000000";
END a;
