library IEEE;
use IEEE.STD_LOGIC_1164.all; 
library aes;
use aes.aes_package.all;

-- Package Declaration Section
package common is

    type mul_result_t is array (0 to 3) of column_t;
    
    type state_mul_result_t is array (0 to 3) of mul_result_t;
	
  	function mul_2 (
		data : in std_logic_vector(7 downto 0))
    	return std_logic_vector;
		
	function mul_3 (
		data : in std_logic_vector(7 downto 0))
    	return std_logic_vector;
   
end package common;
 
-- Package Body Section
package body common is
 
	function mul_2 (
		data : in std_logic_vector(7 downto 0))
		return std_logic_vector is
	begin
		return (data(6),             -- bit 7
			    data(5),             -- bit 6
			    data(4),             -- bit 5
			    data(7) xor data(3), -- bit 4
			    data(7) xor data(2), -- bit 3
			    data(1),			 -- bit 2
			    data(7) xor data(0), -- bit 1
			    data(7));			 -- bit 0
	end;  
	
	function mul_3 (
		data : in std_logic_vector(7 downto 0))
		return std_logic_vector is
	begin
		return (data(7) xor data(6),             -- bit 7
			    data(6) xor data(5),             -- bit 6
			    data(5) xor data(4),             -- bit 5
			    data(7) xor data(4) xor data(3), -- bit 4
			    data(7) xor data(3) xor data(2), -- bit 3
			    data(2) xor data(1),			 -- bit 2
			    data(7) xor data(1) xor data(0), -- bit 1
			    data(7) xor data(0));			 -- bit 0
	end;
 
end package body common;