-----------------------------------------------------
-- Memory block
-- 
-- Lorenzo Lastrucci
-----------------------------------------------------
-- Entity Name       : MEMORY
-- Architecture Name : RTL
-----------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;
use IEEE.math_real.all;


entity MEMORY is
	port(   data_in   : in COMPLEX_ARRAY(0 to L-1);
			addr_load : in T_ADDR(0 to L-1);
			bank_load : in T_BANK(0 to L-1);
			addr_read : in T_ADDR(0 to L-1);
			bank_read : in T_BANK(0 to L-1);
			N         : in CASCADE(0 to 7);
			P         : in unsigned(4 downto 0);
			CTRL 	  : in std_logic;
			CLK,WE,RE : in std_logic;
			data_out  : out COMPLEX_ARRAY(0 to L-1));
end MEMORY;

architecture RTL of MEMORY is
	signal addr_0, addr_1 : T_ADDR(0 to L-1);
	signal bank_0, bank_1 : T_BANK(0 to L-1);
	signal data_out_0, data_out_1 : COMPLEX_ARRAY(0 to L-1);
	signal WE_0, WE_1, RE_0, RE_1 : std_logic;
begin
	MEM0 : entity work.MEM(BHV) 
	port map (
	data_in  => data_in,
	address  => addr_0,
	bank	 => bank_0,
	N        => N,
	P		 => P,
	CLK      => CLK,
	WE  	 => WE_0,
	RE		 => RE_0,
	data_out => data_out_0);
	
	MEM1 : entity work.MEM(BHV) 
	port map (
	data_in  => data_in,
	address  => addr_1,
	bank	 => bank_1,
	N        => N,
	P		 => P,
	CLK      => CLK,
	WE  	 => WE_1,
	RE		 => RE_1,
	data_out => data_out_1);
	
	data_out <= data_out_0 when CTRL = '1' else data_out_1;
	
	addr_0 <= addr_read when CTRL = '1' else addr_load;
	bank_0 <= bank_read when CTRL = '1' else bank_load;

	addr_1 <= addr_read when CTRL = '0' else addr_load;
	bank_1 <= bank_read when CTRL = '0' else bank_load;
	
	-- Write enable logic
	WE_0 <= '1' when (CTRL = '0' and WE = '1') else '0';
	WE_1 <= '1' when (CTRL = '1' and WE = '1') else '0';
	RE_0 <= '1' when (CTRL = '1' and RE = '1') else '0';
	RE_1 <= '1' when (CTRL = '0' and RE = '1') else '0';
end RTL;









