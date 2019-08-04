-------------------------------------------------------------------------------
--
-- Title       : MixColumns
-- Design      : MixColumns
-- Author      :
-- Company     :
--
-------------------------------------------------------------------------------
--
-- File        : MixColumn.vhd
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

entity MixColumns is
	port(
		clk      : in  std_logic;
		n_reset  : in  std_logic;
		data_in  : in  state_t;
		data_out : out state_t
	);
end MixColumns;

architecture behavioral_concurent of MixColumns is

    signal mul_result : state_mul_result_t;

begin

    GEN_COLUMN : for column_no in 0 to 3 generate

        MUL: process (clk, n_reset) is
        begin
            if n_reset = '0' then
                mul_result(column_no) <= (others => (others => X"00"));
            elsif rising_edge(clk) then

                -- multiply
                mul_result(column_no)(0)(0) <= mul_2(data_in(0 + 4 * column_no));
                mul_result(column_no)(0)(1) <= mul_3(data_in(1 + 4 * column_no));
                mul_result(column_no)(0)(2) <= data_in(2 + 4 * column_no);
                mul_result(column_no)(0)(3) <= data_in(3 + 4 * column_no);

                mul_result(column_no)(1)(0) <= mul_2(data_in(1 + 4 * column_no));
                mul_result(column_no)(1)(1) <= mul_3(data_in(2 + 4 * column_no));
                mul_result(column_no)(1)(2) <= data_in(3 + 4 * column_no);
                mul_result(column_no)(1)(3) <= data_in(0 + 4 * column_no);

                mul_result(column_no)(2)(0) <= mul_2(data_in(2 + 4 * column_no));
                mul_result(column_no)(2)(1) <= mul_3(data_in(3 + 4 * column_no));
                mul_result(column_no)(2)(2) <= data_in(0 + 4 * column_no);
                mul_result(column_no)(2)(3) <= data_in(1 + 4 * column_no);

                mul_result(column_no)(3)(0) <= mul_2(data_in(3 + 4 * column_no));
                mul_result(column_no)(3)(1) <= mul_3(data_in(0 + 4 * column_no));
                mul_result(column_no)(3)(2) <= data_in(1 + 4 * column_no);
                mul_result(column_no)(3)(3) <= data_in(2 + 4 * column_no);

            end if;
        end process MUL;

        data_out(0 + 4 * column_no) <= mul_result(column_no)(0)(0) xor
                                       mul_result(column_no)(0)(1) xor
                                       mul_result(column_no)(0)(2) xor
                                       mul_result(column_no)(0)(3);
        data_out(1 + 4 * column_no) <= mul_result(column_no)(1)(0) xor
                                       mul_result(column_no)(1)(1) xor
                                       mul_result(column_no)(1)(2) xor
                                       mul_result(column_no)(1)(3);
        data_out(2 + 4 * column_no) <= mul_result(column_no)(2)(0) xor
                                       mul_result(column_no)(2)(1) xor
                                       mul_result(column_no)(2)(2) xor
                                       mul_result(column_no)(2)(3);
        data_out(3 + 4 * column_no) <= mul_result(column_no)(3)(0) xor
                                       mul_result(column_no)(3)(1) xor
                                       mul_result(column_no)(3)(2) xor
                                       mul_result(column_no)(3)(3);
        
    end generate GEN_COLUMN;

end behavioral_concurent;
