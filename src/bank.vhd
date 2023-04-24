-----------------------------------------------------
-- Memory bank
-- Implementation of the memory bank 
-- Lorenzo Lastrucci
-----------------------------------------------------
-- Entity Name       : MEM
-- Architecture Name : BHV
-----------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;
use IEEE.math_real.all;

entity BANK is
	port( data_in	: in COMPLEX;
		  address   : in std_logic_vector(7 downto 0);
		  CLK,WE,RE : in std_logic;
		  data_out  : out COMPLEX);
end BANK;

architecture RTL of BANK is 
	type T_BANK is array(0 to 2**address'length -1) of COMPLEX;
	signal BANK_array: T_BANK;
begin
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			if WE = '1' then			
				BANK_array(to_integer(unsigned(address))) <= data_in;
				data_out <= ((others=>'0'),(others=>'0'));
			elsif RE = '1' then
				data_out <= BANK_array(to_integer(unsigned(address)));
			else
				data_out <= ((others=>'0'),(others=>'0'));
			end if;
		end if;
	end process;

end RTL;
