-----------------------------------------------------
-- Memory block
-- Implementation of the memory block
-- Lorenzo Lastrucci
-----------------------------------------------------
-- Entity Name       : MEM
-- Architecture Name : STRUCT
-----------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;
use IEEE.math_real.all;

entity MEM is
	port( data_in	: in COMPLEX_ARRAY(0 to L-1);
		  address   : in T_ADDR(0 to L-1);
		  bank 		: in T_BANK(0 to L-1);
		  N         : in CASCADE(0 to 7);
		  P         : in unsigned(4 downto 0);
		  CLK,WE,RE : in std_logic;
		  data_out  : out COMPLEX_ARRAY(0 to L-1));
end MEM;
	
architecture BHV of MEM is 
	type T_BANK is array(0 to 2**address(0)'length -1) of COMPLEX;
	type T_MEM is array(0 to 2**bank(0)'length -1) of T_BANK;
	signal MEMORY : T_MEM;
	--signal data_in_int,data_out_int : COMPLEX_ARRAY(0 to L-1);
	--signal addr_int : T_ADDR(0 to L-1);
	--signal bank_0 : T_BANK(0 to L-1);
begin
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			if WE = '1' then
				for I in 0 to L-1 loop
					if I < to_integer(N(0)*P) then			
						MEMORY(to_integer(unsigned(bank(I))))(to_integer(unsigned(address(I)))) <= data_in(I);
					end if;
				end loop;
				data_out <= (others=>((others=>'0'),(others=>'0')));
			elsif RE = '1' then
				for I in 0 to L-1 loop
					if I < to_integer(N(0)*P) then		
						data_out(I) <= MEMORY(to_integer(unsigned(bank(I))))(to_integer(unsigned(address(I))));
					end if;
				end loop;		
			else
				data_out <= (others=>((others=>'0'),(others=>'0')));
			end if;
		end if;
	end process;
	--process(address,bank)
	--begin
		--for I in 0 to L-1 loop
			--addr_int(to_integer(unsigned(bank(I)))) <= address(I);
		--end loop;
	--end process;

	--process(data_out_int,bank_0)
	--begin
		--for I in 0 to L-1 loop
			--data_out(I) <= data_out_int(to_integer(unsigned(bank_0(I))));
		--end loop;
	--end process;

	--process(data_in,bank,addr_int)
	--begin
		--for I in 0 to L-1 loop
			--data_in_int(to_integer(unsigned(bank(I)))) <= data_in(I);
		--end loop;
	--end process;

	--process(CLK)
	--begin
		--if CLK'event and CLK = '1' then
			--bank_0 <= bank;
		--end if;
	--end process;

	--gen : for I in 0 to L-1 generate
		--bank : entity work.BANK(RTL) port map(
		--data_in	=> data_in_int(I),
		--address => addr_int(I),
		--CLK		=> CLK,
		--WE		=> WE,
		--RE		=> RE,
		--data_out=> data_out_int(I));
	--end generate;	
end BHV;


