------------------------------------------------
-- Indices Generator
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : IND_GEN
-- Architecture Name : RTL
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;


entity IND_GEN is
	generic ( ID : integer); 
	port(   N     : in CASCADE(0 to 1);
		CLK,RES,EN : in std_logic;
		P     : in unsigned(4 downto 0);
		MODE  : in unsigned(12 downto 0);
		Ni    : out INDICES(0 to 1);
		DONE  : out std_logic);
end IND_GEN;

architecture RTL of IND_GEN is
	signal IT : integer := 0;
	signal Ni_int : INDICES(0 to 1) := (others => (others => '0'));
begin
	
	Ni_int(0) <= to_unsigned(ID mod to_integer(N(0)), Ni_int(0)'length) when RES = '1';
	Ni <= Ni_int;
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			if RES = '0' then
				Ni_int <= (others => (others =>'0'));
				IT <= 0;
				DONE <= '0';
			elsif EN = '1' then
				if IT < to_integer(MODE)/to_integer(N(0)*P) then
					IT <= IT + 1;
					DONE <= '0';
					Ni_int(1) <= to_unsigned((((ID - to_integer(Ni_int(0)))*IT/to_integer(Ni_int(0)+1)) mod to_integer(N(1))),Ni_int(1)'length);
				else
					IT <= 0;
					DONE <= '1';
				end if;
			end if;
		end if;
	end process;
end RTL;
