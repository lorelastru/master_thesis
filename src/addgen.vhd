------------------------------------------------
-- Generates address and bank number 
-- for the memory
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : ADD_GEN
-- Architecture Name : RTL
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;
use IEEE.math_real.all;

entity ADD_GEN is 
	port( 	N  : in CASCADE(0 to 7);
			Ni : in INDICES(0 to 7);
			SMAX  : in unsigned(2 downto 0);
			bank : out std_logic_vector(3 downto 0);
			address: out std_logic_vector(7 downto 0));
end ADD_GEN;

architecture RTL of ADD_GEN is
	signal N1_rev, N2_shift, NS_rev : unsigned(T-1 downto 0) := (others => '0');
	signal S  : unsigned(bank'length-1 downto 0) := (others => '0');
	signal R,P  : unsigned(address'length-1 downto 0) := (others => '0');
begin
	--N2_shift generation
	process(Ni,N)
	begin
		if N(1) > 0 then
			if N(0) = 16 then		
				N2_shift <= Ni(1);
			elsif N(0) = 8 then
				N2_shift <= shift_right(Ni(1),1);
			elsif N(0) = 4 then
				N2_shift <= shift_right(Ni(1),2);
			elsif N(0) = 3 then
				N2_shift <= shift_right(Ni(1),2);
			elsif N(0) = 5 then
				N2_shift <= shift_right(Ni(1),1);
			elsif N(0) = 2 then
				N2_shift <= shift_right(Ni(1),3);
			end if;
		end if;
	end process;
		
	
	--NS_rev: bit reverse of n_s
	process(Ni,SMAX)
	begin
		for I in 0 to NS_rev'length - 1 loop
 			NS_rev(I) <= Ni(to_integer(SMAX))(NS_rev'length-1 - I);
		end loop;
	end process;

	--N1_rev: bit reverse of n_1
	gen_N1: for I in 0 to N1_rev'length - 1 generate
 		N1_rev(I) <= Ni(0)(N1_rev'length-1 - I);
	end generate;

	--sum evaluation for the computation of bank
	SUM : process(Ni,N,NS_rev)
		variable Stemp : unsigned(bank'length-1 downto 0) := (others => '0');
	begin
		Stemp := (others => '0');
		for I in 1 to to_integer(SMAX) loop
			--if I < to_integer(SMAX) +1 then
				if I = SMAX and SMAX > 1 then
					Stemp := Stemp + NS_rev;
				else
					Stemp := Stemp + Ni(I);
				end if;
			--end if;
		end loop;
		S <= resize(Stemp,S'length);
	end process SUM;

	--prod and sum evaluation for the computation of address
	PROD : process(N2_shift,N)
		variable Ptemp : unsigned(address'length-1 downto 0) := to_unsigned(1,address'length);
	begin
		Ptemp := to_unsigned(1,Ptemp'length);
		if to_integer(SMAX) > 1 then
			for I in 2 to to_integer(SMAX) loop
				--if I < to_integer(SMAX) + 1 then
					Ptemp := resize(Ptemp*N(I),Ptemp'length);
				--end if;
			end loop;
		else
			Ptemp := (others => '0');
		end if;
		P <= resize(Ptemp*N2_shift,P'length);
	end process PROD;

	SUM2 : process(Ni,N)
		variable Rtemp : unsigned(address'length-1 downto 0) := (others => '0');
		variable Ttemp : unsigned(address'length-1 downto 0) := to_unsigned(1,address'length);
	begin
		Ttemp := to_unsigned(1,Ttemp'length);
		Rtemp := (others => '0');
		for I in 2 to to_integer(SMAX)-1 loop
			--if I < to_integer(SMAX) then
				for J in I+1 to to_integer(SMAX) loop
					--if J > I and J < to_integer(SMAX)+1 then
						Ttemp := resize(Ttemp*N(J),Ttemp'length);
					--end if;
				end loop;
				Rtemp := Rtemp + resize(Ttemp*Ni(I),Rtemp'length);
				Ttemp := to_unsigned(1,Ttemp'length);
			--end if;
		end loop;
		R <= resize(Rtemp,R'length);
	end process SUM2;

	bank <= std_logic_vector(to_unsigned((to_integer(N1_rev + S) mod L),bank'length));
	address <=  std_logic_vector(resize(P + R + Ni(to_integer(SMAX)),address'length)); 
end RTL;






