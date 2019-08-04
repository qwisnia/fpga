library aes;
use aes.aes_package.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity shiftrows_tb is
end shiftrows_tb;

architecture TB_ARCHITECTURE of shiftrows_tb is
	-- Component declaration of the tested unit
	component shiftrows
	port(
		clk : in STD_LOGIC;
		n_reset : in STD_LOGIC;
		data_in : in state;
		data_out : out state );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC := '0';
	signal n_reset : STD_LOGIC := '0';
	signal data_in : state;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal data_out : state;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : shiftrows
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
		data_in <= (X"d4", X"27", X"11", X"ae",
		            X"e0", X"bf", X"98", X"f1",
					X"b8", X"b4", X"5d", X"e5",
					X"1e", X"41", X"52", X"30");

		-- expected result d4, bf, 5d, 30
		--                 e0, b4, 52, ae
		--                 b8, 41, 11, f1
		--                 1e, 27, 98, e5

		wait; -- end of test
	end process STIMULUS;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_shiftrows of shiftrows_tb is
	for TB_ARCHITECTURE
		for UUT : shiftrows
			use entity work.shiftrows(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_shiftrows;

