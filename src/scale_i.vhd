------------------------------------------------
-- Scale factors computation
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : SCALE_I
-- Architecture Name : RTL_last -> Computation for i>N/12
-- Architecture Name : RTL_first -> Computation for i<N/12+1
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.WORKPACK.all;

entity SCALE is
	generic ( I : natural := 0;
			  L : natural := 8);
	port(    S : in signed(Th-1 downto 0);
		  CLK,RES,EN : in std_logic;
			 K : out signed(Th-1 downto 0));  
end SCALE;

architecture LAST of SCALE is
  	signal R : W_DLINE(0 to L-I-1) := (others => (others => '0'));
	signal S_2 : signed(2*Th-1 downto 0);
begin
	DEL: for J in 0 to L-I-2 generate
		process(CLK)
		begin 
			if CLK'event and CLK = '1' then 
				if RES = '0' then
					R(J+1) <= (others => '0');
				elsif EN = '1' then
					R(J+1) <= R(J);
				end if;
			end if;
		end process;
	end generate DEL;
	
	S_2 <= S*S;
	R(0) <= resize(to_signed(2**(N-1),Th) - shift_left(S_2,N-(4*I)-2),K'length);
	K <= R(L-I-1);
end LAST;

architecture FIRST of SCALE is
  	signal R : W_DLINE(0 to L-I-1) := (others => (others => '0'));
begin
	DEL: for I in 0 to L-I-2 generate
		process(CLK)
		begin 
			if CLK'event and CLK = '1' then 
				if RES = '0' then
					R(I+1) <= (others => '0');
				elsif EN = '1' then
					R(I+1) <= R(I);
				end if;
			end if;
		end process;
	end generate DEL;

	ROM : entity WORK.SCALE_ROM(RTL) 
	generic map(
	I => I)
	port map(
	S => S,
	K => R(0));

	K <= R(L-I-1);
end FIRST;
