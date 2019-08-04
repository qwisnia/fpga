library aes;
use aes.aes_package.all;
library work;
use work.common.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity mixcolumns_tb is
end mixcolumns_tb;

architecture TB_ARCHITECTURE of mixcolumns_tb is
	-- Component declaration of the tested unit
	component mixcolumns
	port(
		clk : in STD_LOGIC;
		n_reset : in STD_LOGIC;
		data_in : in state_t;
		data_out : out state_t );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC := '0';
	signal n_reset : STD_LOGIC := '0';
	signal data_in : state_t;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal data_out : state_t;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : MixColumns
		port map (
			clk => clk,
			n_reset => n_reset,
			data_in => data_in,
			data_out => data_out
		);

	-- Add your stimulus here ...
	clk <= not clk after 10 ns;
	n_reset <= '1' after 35 ns;

	STIMULUS: process
	begin
		data_in <= (X"00", X"00", X"00", X"00",
                    X"00", X"00", X"00", X"00",
                    X"00", X"00", X"00", X"00",
                    X"00", X"00", X"00", X"00");
		wait for 50 ns;
		data_in <= (X"D4", X"BF", X"5D", X"30",
                    X"E0", X"B4", X"52", X"AE",
                    X"B8", X"41", X"11", X"F1",
                    X"1E", X"27", X"98", X"E5");
		-- expected result 04, 66, 81, E5
        --                 E0, CB, 19, 9A
        --                 48, f8, D3, 7A
        --                 28, 06, 26, 4C
		wait; -- end of test
	end process STIMULUS;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_mixcolumns of mixcolumns_tb is
	for TB_ARCHITECTURE
		for UUT : mixcolumns
			use entity work.mixcolumns(behavioral_concurent);
		end for;
	end for;
end TESTBENCH_FOR_mixcolumns;

