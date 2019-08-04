-------------------------------------------------------------------------------
--
-- Title       : aes
-- Design      : aes
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : aes_top.vhd
-- Generated   : Sun Jun 24 11:48:10 2018
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {es} architecture {behavioral}}

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

entity aes is
	port(
		clk      : in  std_logic;
		n_reset  : in  std_logic;
		data_in  : in  state_t;
		key_in   : in  key_t;
		data_out : out state_t
	);
end aes;

--}} End of automatically maintained section

architecture behavioral of aes is 

	component KeySchedule
	port(
		clk      : in  std_logic;
		n_reset  : in  std_logic;
		key_in   : in  state_t; 
		rcon_in  : in  std_logic_vector(7 downto 0);
		key_out  : out state_t
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

	signal aes_state : aes_state_t;
	signal round_cnt : integer;	
	
	signal add_round_key_data_in  : state_t;
	signal add_round_key_data_out : state_t;
	
	signal sbox_data_in  : state_t;
	signal sbox_data_out : state_t;
	
	signal shiftrows_data_out : state_t;
	
	signal mixcolumns_data_out : state_t;
	
	for U_ADDROUNDKEY : AddRoundKey
        use entity addroundkey.addroundkey(behavioral);

	for U_SBOX : SBox
		use entity sbox.sbox(xilinx_8_dual_port_rom);
			
	for U_SHIFTROWS : ShiftRows
        use entity shiftrows.shiftrows(behavioral);	
			
	for U_MIXCOLUMNS : MixColumns
        use entity mixcolumns.mixcolumns(behavioral_concurent);
begin

	AES_TOP_STATE_MACHINE_P: process(clk, n_reset) is
	begin  
		if n_reset = '0' then 
			aes_state <= init_round;
		elsif rising_edge(clk) then
			case aes_state is
				when init_round =>
					aes_state <= rounds;
				when rounds =>
					if round_cnt = round_max then
						aes_state <= final_round;
					end if;
				when final_round =>
					aes_state <= init_round;
				when others =>
					aes_state <= init_round;	
			end case;
		end if;
	end process AES_TOP_STATE_MACHINE_P;
	
	AES_ROUND_CNT_P: process(clk, n_reset) is
	begin
		if n_reset = '0' then
			round_cnt <= 0;
		elsif rising_edge(clk) then
			case aes_state is
				when rounds => 
					round_cnt <= round_cnt + 1;
				when others =>
					round_cnt <= 0;
			end case;
		end if;
	end process AES_ROUND_CNT_P;
	
	add_round_key_data_in <= data_in                when aes_state = init_round;
	sbox_data_in          <= add_round_key_data_out when aes_state = rounds;
	
	U_ADDROUNDKEY : AddRoundKey
    port map (
        clk      => clk,
		n_reset  => n_reset,
		data_in  => add_round_key_data_in,
		key_in   => key_in,
		data_out => add_round_key_data_out); 
		
	U_SBOX : SBox
    port map (
        clk      => clk,
		n_reset  => n_reset,
		data_in  => sbox_data_in,
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
	
end behavioral;
