-------------------------------------------------------------------------------
--
-- Title       : round
-- Design      : round
-- Author      :
-- Company     :
--
-------------------------------------------------------------------------------
--
-- File        : round.vhd
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
library sbox;
use sbox.all;	 
library shiftrows;
use shiftrows.all;	
library mixcolumns;
use mixcolumns.all;	 
library addroundkey;
use addroundkey.all;

entity round is
	port(
		clk      : in  std_logic;
		n_reset  : in  std_logic;
		data_in  : in  state_t;
		key_in   : in  key_t;
		data_out : out state_t
	);
end round;

architecture behavioral of round is

    component SBox
    port (
        clk      : in  std_logic;
		n_reset  : in  std_logic;
		data_in  : in  state_t;
		data_out : out state_t);
    end component;
    
    component ShiftRows
	port(
		clk      : in  std_logic;
		n_reset  : in  std_logic;
		data_in  : in  state_t;
		data_out : out state_t
	);
    end component;	
	
	component MixColumns
	port(
		clk      : in  std_logic;
		n_reset  : in  std_logic;
		data_in  : in  state_t;
		data_out : out state_t
	);
	end component;
	
	component AddRoundKey
	port(
		clk      : in  std_logic;
		n_reset  : in  std_logic;
		data_in  : in  state_t;  
		key_in   : in  key_t;
		data_out : out state_t
	);
	end component;
	
	signal sbox_data_out       : state_t;
	signal shiftrows_data_out  : state_t;
	signal mixcolumns_data_out : state_t;
	
	for U_SBOX : SBox
		use entity sbox.sbox(xilinx_8_dual_port_rom);
			
    for U_SHIFTROWS : ShiftRows
        use entity shiftrows.shiftrows(behavioral);
				
    for U_MIXCOLUMNS : MixColumns
        use entity mixcolumns.mixcolumns(behavioral_concurent);
		
    for U_ADDROUNDKEY : AddRoundKey
        use entity addroundkey.addroundkey(behavioral);

begin	  
	
	U_SBOX : SBox
    port map (
        clk      => clk,
		n_reset  => n_reset,
		data_in  => data_in,
		data_out => sbox_data_out);	
		
	U_SHIFTROWS : ShiftRows
    port map (
        clk      => clk,
		n_reset  => n_reset,
		data_in  => sbox_data_out,
		data_out => shiftrows_data_out);
		
	U_MIXCOLUMNS : MixColumns
    port map (
        clk      => clk,
		n_reset  => n_reset,
		data_in  => shiftrows_data_out,
		data_out => mixcolumns_data_out);
		
	U_ADDROUNDKEY : AddRoundKey
    port map (
        clk      => clk,
		n_reset  => n_reset,
		data_in  => mixcolumns_data_out,
		key_in   => key_in,
		data_out => data_out);

end behavioral;	 