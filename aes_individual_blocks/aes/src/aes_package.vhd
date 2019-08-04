library IEEE;
use IEEE.STD_LOGIC_1164.all; 

-- Package Declaration Section
package aes_package is
	
	constant state_length: integer := 16;
	constant key_length: integer := 16;	
	constant round_max: integer	:= 9;
	
	type column_t is array (0 to 3)                of std_logic_vector(7 downto 0);
	type state_t  is array (0 to state_length - 1) of std_logic_vector(7 downto 0);
	type key_t    is array (0 to key_length - 1)   of std_logic_vector(7 downto 0);  
	
	type aes_state_t is (init_round, rounds, final_round);

	-- xilinx sbox rom
	component blk_mem_gen_v4_3
    port (
        clka  : in  std_logic;
        addra : in  std_logic_vector(7 downto 0);
        douta : out std_logic_vector(7 downto 0);
        clkb  : in  std_logic;
        addrb : in  std_logic_vector(7 downto 0);
        doutb : out std_logic_vector(7 downto 0));
    end component blk_mem_gen_v4_3;
 
end package aes_package;
 
-- Package Body Section
package body aes_package is

	-- N/A
 
end package body aes_package;