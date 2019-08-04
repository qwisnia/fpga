-------------------------------------------------------------------------------
--
-- Title       : KeySchedule
-- Design      : KeySchedule
-- Author      :
-- Company     :
--
-------------------------------------------------------------------------------
--
-- File        : KeySchedule.vhd
-- Generated   : Sun Apr  8 21:48:31 2018
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description :
-- http://www.samiam.org/key-schedule.html
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
library aes;
use aes.common.all;

entity KeySchedule is
	port(
		clk      : in  std_logic;
		n_reset  : in  std_logic;
		key_in   : in  state_t; 
		rcon_in  : in  std_logic_vector(7 downto 0);
		key_out  : out state_t
	);
end KeySchedule;

architecture xillinx_2_dual_port_rom of KeySchedule is

	-- An architecture which has a maximal
	-- throughtput, each state is analysed in one clock cycle.

    component blk_mem_gen_v4_3
    port (
        clka  : in  std_logic;
        addra : in  std_logic_vector(7 downto 0);
        douta : out std_logic_vector(7 downto 0);
        clkb  : in  std_logic;
        addrb : in  std_logic_vector(7 downto 0);
        doutb : out std_logic_vector(7 downto 0));
    end component;
	
	signal rot_word_result : column_t;
	signal sub_byte_result : column_t;
	signal xor_result      : state_t;

begin
	
	rot_word_result <= (key_in(13), key_in(14), key_in(15), key_in(12));
	
	xor_result(0)  <= key_in(0)  xor sub_byte_result(0) xor rcon_in;
	xor_result(1)  <= key_in(1)  xor sub_byte_result(1); -- xor X"00"
	xor_result(2)  <= key_in(2)  xor sub_byte_result(2); -- xor X"00"
	xor_result(3)  <= key_in(3)  xor sub_byte_result(3); -- xor X"00"
	
	xor_result(4)  <= key_in(4)  xor xor_result(0);
	xor_result(5)  <= key_in(5)  xor xor_result(1);
	xor_result(6)  <= key_in(6)  xor xor_result(2);
	xor_result(7)  <= key_in(7)  xor xor_result(3);
	
	xor_result(8)  <= key_in(8)  xor xor_result(4);
	xor_result(9)  <= key_in(9)  xor xor_result(5);
	xor_result(10) <= key_in(10) xor xor_result(6);
	xor_result(11) <= key_in(11) xor xor_result(7);
	
	xor_result(12) <= key_in(12) xor xor_result(8);
	xor_result(13) <= key_in(13) xor xor_result(9);
	xor_result(14) <= key_in(14) xor xor_result(10);
	xor_result(15) <= key_in(15) xor xor_result(11);
	
	GEN_SBOX_ROM: for rom_no in 0 to 1 generate
		
	    ROM_MEMORY: blk_mem_gen_v4_3
		    port map (
		        clka  => clk,
		        addra => rot_word_result(rom_no),
		        douta => sub_byte_result(rom_no),
		        clkb  => clk,
		        addrb => rot_word_result(rom_no + 2),
		        doutb => sub_byte_result(rom_no + 2)
		    );
		
	end generate GEN_SBOX_ROM;
	
	-- set output
	key_out <= xor_result;

end xillinx_2_dual_port_rom; 

architecture external_sbox of KeySchedule is
							
	-- An architecture which has a maximal
	-- throughtput, each state is analysed in one clock cycle.

    component blk_mem_gen_v4_3
    port (
        clka  : in  std_logic;
        addra : in  std_logic_vector(7 downto 0);
        douta : out std_logic_vector(7 downto 0);
        clkb  : in  std_logic;
        addrb : in  std_logic_vector(7 downto 0);
        doutb : out std_logic_vector(7 downto 0));
    end component;
	
	signal rot_word_result : column_t;
	signal sub_byte_result : column_t;
	signal xor_result      : state_t;

begin
	
	rot_word_result <= (key_in(13), key_in(14), key_in(15), key_in(12));
	
	xor_result(0)  <= key_in(0)  xor rot_word_result(0) xor rcon_in;
	xor_result(1)  <= key_in(1)  xor rot_word_result(1); -- xor X"00"
	xor_result(2)  <= key_in(2)  xor rot_word_result(2); -- xor X"00"
	xor_result(3)  <= key_in(3)  xor rot_word_result(3); -- xor X"00"
	
	xor_result(4)  <= key_in(4)  xor xor_result(0);
	xor_result(5)  <= key_in(5)  xor xor_result(1);
	xor_result(6)  <= key_in(6)  xor xor_result(2);
	xor_result(7)  <= key_in(7)  xor xor_result(3);
	
	xor_result(8)  <= key_in(8)  xor xor_result(4);
	xor_result(9)  <= key_in(9)  xor xor_result(5);
	xor_result(10) <= key_in(10) xor xor_result(6);
	xor_result(11) <= key_in(11) xor xor_result(7);
	
	xor_result(12) <= key_in(12) xor xor_result(8);
	xor_result(13) <= key_in(13) xor xor_result(9);
	xor_result(14) <= key_in(14) xor xor_result(10);
	xor_result(15) <= key_in(15) xor xor_result(11);
	
	-- set output
	key_out <= xor_result;

end external_sbox;