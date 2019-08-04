-------------------------------------------------------------------------------
--
-- Title       : ShiftRows
-- Design      : ShiftRows
-- Author      :
-- Company     :
--
-------------------------------------------------------------------------------
--
-- File        : ShiftRows.vhd
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
use aes.common.all;

entity ShiftRows is
	port(
		clk      : in  std_logic;
		n_reset  : in  std_logic;
		data_in  : in  state_t;
		data_out : out state_t
	);
end ShiftRows;

architecture behavioral of ShiftRows is

begin
	
	-- column 0
	data_out(0)  <= data_in(0);
	data_out(1)  <= data_in(5);
	data_out(2)  <= data_in(10);
	data_out(3)  <= data_in(15);
	-- column 1
	data_out(4)  <= data_in(4);
	data_out(5)  <= data_in(9);
	data_out(6)  <= data_in(14);
	data_out(7)  <= data_in(3);
	-- column 2
	data_out(8)  <= data_in(8);
	data_out(9)  <= data_in(13);
	data_out(10) <= data_in(2);
	data_out(11) <= data_in(7);
	-- column 3
	data_out(12) <= data_in(12);
	data_out(13) <= data_in(1);
	data_out(14) <= data_in(6);
	data_out(15) <= data_in(11);

end behavioral;