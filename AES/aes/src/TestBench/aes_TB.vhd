library aes;
use aes.common.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity aes_tb is
end aes_tb;

architecture TB_ARCHITECTURE of aes_tb is
	-- Component declaration of the tested unit
	component aes
	port(
		clk : in STD_LOGIC;
		n_reset : in STD_LOGIC;
		data_in : in state_t;
		key_in : in key_t;
		data_out : out state_t );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC := '0';
	signal n_reset : STD_LOGIC := '0';
	signal data_in : state_t;
	signal key_in : key_t;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal data_out : state_t;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : aes
		port map (
			clk => clk,
			n_reset => n_reset,
			data_in => data_in,
			key_in => key_in,
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
					
		key_in <=  (X"00", X"00", X"00", X"00",
		            X"00", X"00", X"00", X"00",
					X"00", X"00", X"00", X"00",
					X"00", X"00", X"00", X"00");
		wait for 35 ns;	 
--		data_in <= (X"19", X"3d", X"e3", X"be",
--		            X"a0", X"f4", X"e2", X"2b",
--					X"9a", X"c6", X"8d", X"2a",
--					X"e9", X"f8", X"48", X"08");
--					
--	    key_in <=  (X"a0", X"fa", X"fe", X"17",
--		            X"88", X"54", X"2c", X"b1",
--					X"23", X"a3", X"39", X"39",
--					X"2a", X"6c", X"76", X"05");
					
		data_in <= (X"32", X"43", X"f6", X"a8",
		            X"88", X"5a", X"30", X"8d",
					X"31", X"31", X"98", X"a2",
					X"e0", X"37", X"07", X"34");
					
	    key_in <=  (X"2b", X"7e", X"15", X"16",
		            X"28", X"ae", X"d2", X"a6",
					X"ab", X"f7", X"15", X"88",
					X"09", X"cf", X"4f", X"3c");

		-- expected result a4, 9c, 7f, f2
		--                 68, 9f, 35, 2b
		--                 6b, 5b, ea, 43
		--                 02, 6a, 50, 49

		wait; -- end of test
	end process STIMULUS;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_aes of aes_tb is
	for TB_ARCHITECTURE
		for UUT : aes
			use entity work.aes(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_aes;

