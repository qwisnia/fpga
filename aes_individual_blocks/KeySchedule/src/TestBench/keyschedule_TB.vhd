library aes;
use aes.aes_package.all;
library SBox;
use SBox.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity keyschedule_tb is
end keyschedule_tb;

architecture TB_ARCHITECTURE of keyschedule_tb is
	-- Component declaration of the tested unit
	component keyschedule
	port(
		clk : in STD_LOGIC;
		n_reset : in STD_LOGIC;
		key_in : in state;
		rcon_in : in STD_LOGIC_VECTOR(7 downto 0);
		key_out : out state );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC := '0';
	signal n_reset : STD_LOGIC := '0';
	signal key_in : state;
	signal rcon_in : STD_LOGIC_VECTOR(7 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal key_out : state;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : keyschedule
		port map (
			clk => clk,
			n_reset => n_reset,
			key_in => key_in,
			rcon_in => rcon_in,
			key_out => key_out
		);

	-- Add your stimulus here ...
	clk <= not clk after 10 ns;	   
	n_reset <= '1' after 35 ns;
	
	STIMULUS: process
	begin
		key_in <= (X"00", X"00", X"00", X"00",
		           X"00", X"00", X"00", X"00",
		 		   X"00", X"00", X"00", X"00",
		 		   X"00", X"00", X"00", X"00");
		rcon_in <= X"00";
		wait for 50 ns;	 
		key_in <= (X"2b", X"7e", X"15", X"16",
		           X"28", X"ae", X"d2", X"a6",
				   X"ab", X"f7", X"15", X"88",
				   X"09", X"cf", X"4f", X"3c");
		rcon_in <= X"01";

		-- expected result a0, fa, fe, 17
		--                 88, 54, 2c, b1
		--                 23, a3, 39, 39
		--                 2a, 6c, 76, 05

		wait; -- end of test
	end process STIMULUS;

end TB_ARCHITECTURE;  

architecture TB_ARCHITECTURE_external_sbox of keyschedule_tb is
	-- Component declaration of the tested unit
	component keyschedule
	port(
		clk : in STD_LOGIC;
		n_reset : in STD_LOGIC;
		key_in : in state;
		rcon_in : in STD_LOGIC_VECTOR(7 downto 0);
		key_out : out state );
	end component;	
	
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
	signal key_in : state;	   
	signal key_shedule_in : state;
	signal rcon_in : STD_LOGIC_VECTOR(7 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal key_out : state;
	signal key_sbox_out : state;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : keyschedule
		port map (
			clk => clk,
			n_reset => n_reset,
			key_in  => key_shedule_in,
			rcon_in => rcon_in,
			key_out => key_out
		); 
		
	U_SBOX: sbox
		port map(
			clk      => clk,
			n_reset  => n_reset,
			data_in  => key_in,
			data_out => key_sbox_out
		);

	-- Add your stimulus here ...
	clk <= not clk after 10 ns;	   
	n_reset <= '1' after 35 ns;
	
	key_shedule_in <= key_in(0 to 11) & key_sbox_out(12 to 15);
	
	STIMULUS: process
	begin
		key_in <= (X"00", X"00", X"00", X"00",
		           X"00", X"00", X"00", X"00",
		 		   X"00", X"00", X"00", X"00",
		 		   X"00", X"00", X"00", X"00");
		rcon_in <= X"00";
		wait for 50 ns;	 
		key_in <= (X"2b", X"7e", X"15", X"16",
		           X"28", X"ae", X"d2", X"a6",
				   X"ab", X"f7", X"15", X"88",
				   X"09", X"cf", X"4f", X"3c");
		rcon_in <= X"01";

		-- expected result a0, fa, fe, 17
		--                 88, 54, 2c, b1
		--                 23, a3, 39, 39
		--                 2a, 6c, 76, 05

		wait; -- end of test
	end process STIMULUS;

end TB_ARCHITECTURE_external_sbox;

configuration TESTBENCH_FOR_keyschedule of keyschedule_tb is
	for TB_ARCHITECTURE
		for UUT : keyschedule
			use entity work.keyschedule(xillinx_2_dual_port_rom);
		end for;
	end for;
end TESTBENCH_FOR_keyschedule;

--configuration TESTBENCH_FOR_keyschedule of keyschedule_tb is
--	for TB_ARCHITECTURE_external_sbox
--		for UUT : keyschedule
--			use entity work.keyschedule(external_sbox);
--		end for; 
--		
--		for U_SBOX : sbox
--			use entity SBox.sbox(xillinx_8_dual_port_rom);
--		end for;
--	end for;
--end TESTBENCH_FOR_keyschedule;

