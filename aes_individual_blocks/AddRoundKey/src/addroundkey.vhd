-------------------------------------------------------------------------------
--
-- Title       : AddRoundKey
-- Design      : AddRoundKey
-- Author      :
-- Company     :
--
-------------------------------------------------------------------------------
--
-- File        : AddRoundKey.vhd
-- Generated   : Sun Apr  8 21:48:31 2018
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description :
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
library aes;
use aes.aes_package.all;

entity AddRoundKey is
	port(
		clk      : in  std_logic;
		n_reset  : in  std_logic;
		data_in  : in  state_t;  
		key_in   : in  key_t;
		data_out : out state_t
	);
end AddRoundKey;

architecture behavioral of AddRoundKey is

begin
	
	GEN_XOR: for byte_no in 0 to 15 generate
		
		data_out(byte_no) <= data_in(byte_no) xor key_in(byte_no);
		
	end generate GEN_XOR;

end behavioral;