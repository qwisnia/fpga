-------------------------------------------------------------------------------
--
-- Title       : SBox
-- Design      : SBox
-- Author      :
-- Company     :
--
-------------------------------------------------------------------------------
--
-- File        : SBox.vhd
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

entity SBox is
	port(
		clk      : in  std_logic;
		n_reset  : in  std_logic;
		data_in  : in  state_t;
		data_out : out state_t
	);
end SBox;

architecture xilinx_8_dual_port_rom of SBox is

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

begin
	
	GEN_SBOX_ROM: for rom_no in 0 to 7 generate
		
	    ROM_MEMORY: blk_mem_gen_v4_3
		    port map (
		        clka  => clk,
		        addra => data_in(rom_no),
		        douta => data_out(rom_no),
		        clkb  => clk,
		        addrb => data_in(rom_no + 8),
		        doutb => data_out(rom_no + 8)
		    );
		
	end generate GEN_SBOX_ROM;

end xilinx_8_dual_port_rom;

architecture xilinx_4_dual_port_rom of SBox is

    component blk_mem_gen_v4_3
    port (
        clka  : in  std_logic;
        addra : in  std_logic_vector(7 downto 0);
        douta : out std_logic_vector(7 downto 0);
        clkb  : in  std_logic;
        addrb : in  std_logic_vector(7 downto 0);
        doutb : out std_logic_vector(7 downto 0));
    end component;
	
	signal sel   : std_logic; 
	
	type addr_t is array (0 to 7) of std_logic_vector(7 downto 0);
	type dout_t is array (0 to 7) of std_logic_vector(7 downto 0);

	signal addr : addr_t;
	signal dout : dout_t;

begin
	
	P_SEL: process(clk, n_reset) is
	begin
		if n_reset = '0' then	
			sel <= '0';
		elsif rising_edge(clk) then
			sel <= not sel;
		end if;
	end process P_SEL;

	GEN_SBOX_ROM: for rom_no in 0 to 3 generate
		
		addr(rom_no)     <= data_in(rom_no)     when sel = '0' else data_in(rom_no + 8);	
		addr(rom_no + 4) <= data_in(rom_no + 4) when sel = '0' else data_in(rom_no + 12); 
			
		data_out(rom_no)     <= dout(rom_no)     when sel = '1';
		data_out(rom_no + 4) <= dout(rom_no + 4) when sel = '1';
		
		data_out(rom_no + 8)  <= dout(rom_no)     when sel = '0';
		data_out(rom_no + 12) <= dout(rom_no + 4) when sel = '0';
		
	    ROM_MEMORY: blk_mem_gen_v4_3
		    port map (
		        clka  => clk,
		        addra => addr(rom_no),
		        douta => dout(rom_no),
		        clkb  => clk,
		        addrb => addr(rom_no + 4),
		        doutb => dout(rom_no + 4)
		    );
		
	end generate GEN_SBOX_ROM;

end xilinx_4_dual_port_rom;

architecture xilinx_2_dual_port_rom of SBox is

    component blk_mem_gen_v4_3
    port (
        clka  : in  std_logic;
        addra : in  std_logic_vector(7 downto 0);
        douta : out std_logic_vector(7 downto 0);
        clkb  : in  std_logic;
        addrb : in  std_logic_vector(7 downto 0);
        doutb : out std_logic_vector(7 downto 0));
    end component;
	
	signal sel   : std_logic_vector(3 downto 0); 
	
	type addr_t is array (0 to 3) of std_logic_vector(7 downto 0);
	type dout_t is array (0 to 3) of std_logic_vector(7 downto 0);

	signal addr : addr_t;
	signal dout : dout_t;

begin
	
	P_SEL: process(clk, n_reset) is
	begin
		if n_reset = '0' then	
			sel <= (0 => '1',
			        others => '0');
		elsif rising_edge(clk) then	
			-- shift register
			sel <= sel(2 downto 0) & sel(3);
		end if;
	end process P_SEL;

	GEN_SBOX_ROM: for rom_no in 0 to 1 generate	
		
		addr(rom_no)     <= data_in(rom_no)      when sel(0) = '1' else
				            data_in(rom_no + 4)  when sel(1) = '1' else
                            data_in(rom_no + 8)  when sel(2) = '1' else
                            data_in(rom_no + 12); -- when sel(3) = '1'
        addr(rom_no + 2) <= data_in(rom_no + 2)  when sel(0) = '1' else
				            data_in(rom_no + 6)  when sel(1) = '1' else
                            data_in(rom_no + 10) when sel(2) = '1' else
                            data_in(rom_no + 14); -- when sel(3) = '1'
			
		data_out(rom_no)      <= dout(rom_no)     when sel(1) = '1';
		data_out(rom_no + 2)  <= dout(rom_no + 2) when sel(1) = '1';
		
		data_out(rom_no + 4)  <= dout(rom_no)     when sel(2) = '1';
		data_out(rom_no + 6)  <= dout(rom_no + 2) when sel(2) = '1';
        
        data_out(rom_no + 8)  <= dout(rom_no)     when sel(3) = '1';
		data_out(rom_no + 10) <= dout(rom_no + 2) when sel(3) = '1';
        
        data_out(rom_no + 12) <= dout(rom_no)     when sel(0) = '1';
		data_out(rom_no + 14) <= dout(rom_no + 2) when sel(0) = '1';
		
	    ROM_MEMORY: blk_mem_gen_v4_3
		    port map (
		        clka  => clk,
		        addra => addr(rom_no),
		        douta => dout(rom_no),
		        clkb  => clk,
		        addrb => addr(rom_no + 2),
		        doutb => dout(rom_no + 2)
		    );
		
	end generate GEN_SBOX_ROM;

end xilinx_2_dual_port_rom;

architecture xilinx_1_dual_port_rom of SBox is

    component blk_mem_gen_v4_3
    port (
        clka  : in  std_logic;
        addra : in  std_logic_vector(7 downto 0);
        douta : out std_logic_vector(7 downto 0);
        clkb  : in  std_logic;
        addrb : in  std_logic_vector(7 downto 0);
        doutb : out std_logic_vector(7 downto 0));
    end component;
	
	signal sel   : std_logic_vector(7 downto 0); 
	
	type addr_t is array (0 to 1) of std_logic_vector(7 downto 0);
	type dout_t is array (0 to 1) of std_logic_vector(7 downto 0);

	signal addr : addr_t;
	signal dout : dout_t;

begin
	
	P_SEL: process(clk, n_reset) is
	begin
		if n_reset = '0' then	
			sel <= (0 => '1',
			        others => '0');
		elsif rising_edge(clk) then	
			-- shift register
			sel <= sel(6 downto 0) & sel(7);
		end if;
	end process P_SEL;

    addr(0) <= data_in(0)  when sel(0) = '1' else
               data_in(1)  when sel(1) = '1' else
               data_in(4)  when sel(2) = '1' else
               data_in(5)  when sel(3) = '1' else
               data_in(8)  when sel(4) = '1' else
               data_in(9)  when sel(5) = '1' else
               data_in(12) when sel(6) = '1' else
               data_in(13); -- when sel(7) = '1'
                   
    addr(1) <= data_in(2)  when sel(0) = '1' else
               data_in(3)  when sel(1) = '1' else
               data_in(6)  when sel(2) = '1' else
               data_in(7)  when sel(3) = '1' else
               data_in(10) when sel(4) = '1' else
               data_in(11) when sel(5) = '1' else
               data_in(14) when sel(6) = '1' else
               data_in(15); -- when sel(7) = '1'
        
    data_out(0) <= dout(0) when sel(1) = '1';
    data_out(2) <= dout(1) when sel(1) = '1';
    
    data_out(1) <= dout(0) when sel(2) = '1';
    data_out(3) <= dout(1) when sel(2) = '1';
    
    data_out(4) <= dout(0) when sel(3) = '1';
    data_out(6) <= dout(1) when sel(3) = '1';
    
    data_out(5) <= dout(0) when sel(4) = '1';
    data_out(7) <= dout(1) when sel(4) = '1';
    
    data_out(8)  <= dout(0) when sel(5) = '1';
    data_out(10) <= dout(1) when sel(5) = '1';
    
    data_out(9)  <= dout(0) when sel(6) = '1';
    data_out(11) <= dout(1) when sel(6) = '1';
    
    data_out(12) <= dout(0) when sel(7) = '1';
    data_out(14) <= dout(1) when sel(7) = '1';
    
    data_out(13) <= dout(0) when sel(0) = '1';
    data_out(15) <= dout(1) when sel(0) = '1';
    
    ROM_MEMORY: blk_mem_gen_v4_3
        port map (
            clka  => clk,
            addra => addr(0),
            douta => dout(0),
            clkb  => clk,
            addrb => addr(1),
            doutb => dout(1)
        );
		
end xilinx_1_dual_port_rom;
