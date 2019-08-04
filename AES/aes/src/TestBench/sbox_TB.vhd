library aes;
use aes.aes_package.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity sbox_tb is
end sbox_tb;

architecture TB_ARCHITECTURE of sbox_tb is
	-- Component declaration of the tested unit
	component sbox
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
	UUT : sbox
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
		data_in <= (X"19", X"3d", X"e3", X"be",
		            X"a0", X"f4", X"e2", X"2b",
					X"9a", X"c6", X"8d", X"2a",
					X"e9", X"f8", X"48", X"08");

		-- expected result d4, 27, 11, ae
		--                 e0, bf, 98, f1
		--                 b8, b4, 5d, e5
		--                 1e, 41, 52, 30

		wait; -- end of test
	end process STIMULUS;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_sbox of sbox_tb is
	for TB_ARCHITECTURE
		for UUT : sbox
			use entity work.sbox(xilinx_8_dual_port_rom);
		end for;
	end for;
end TESTBENCH_FOR_sbox;

