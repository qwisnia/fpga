library aes;
use aes.aes_package.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity addroundkey_tb is
end addroundkey_tb;

architecture TB_ARCHITECTURE of addroundkey_tb is
	-- Component declaration of the tested unit
	component addroundkey
	port(
		clk : in STD_LOGIC;
		n_reset : in STD_LOGIC;
		data_in : in state;
		key_in : in key;
		data_out : out state );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC := '0';
	signal n_reset : STD_LOGIC := '0';
	signal data_in : state;
	signal key_in : key;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal data_out : state;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : addroundkey
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
		wait for 50 ns;	 
		data_in <= (X"04", X"66", X"81", X"e5",
		            X"e0", X"cb", X"19", X"9a",
					X"48", X"f8", X"d3", X"7a",
					X"28", X"06", X"26", X"4c"); 
					
	    key_in <=  (X"a0", X"fa", X"fe", X"17",
		            X"88", X"54", X"2c", X"b1",
					X"23", X"a3", X"39", X"39",
					X"2a", X"6c", X"76", X"05");

		-- expected result a4, 9c, 7f, f2
		--                 68, 9f, 35, 2b
		--                 6b, 5b, ea, 43
		--                 02, 6a, 50, 49

		wait; -- end of test
	end process STIMULUS;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_addroundkey of addroundkey_tb is
	for TB_ARCHITECTURE
		for UUT : addroundkey
			use entity work.addroundkey(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_addroundkey;

