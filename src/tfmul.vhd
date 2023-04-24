------------------------------------------------
-- Twiddle factor multiplier
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : TFMUL
-- Architecture Name : STRUCT
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.WORKPACK.all;

entity TFMUL is
	port(    DATA_IN : in COMPLEX;
		    	ADDR : in unsigned(Abit-1 downto 0);
		     	  Ki : in INDICES(0 to C-1);
		     	   M : in CASCADE(0 to 7);
		     	   S : in unsigned(2 downto 0);
		    	SMAX : in unsigned(2 downto 0);
      	    DATA_OUT : out COMPLEX;
				  Ko : out unsigned(F-1 downto 0);
		   Wout,Tout : out signed(Th-1 downto 0); 
	      CLK,RES,EN : in  std_logic);  
end TFMUL;

architecture STRUCT of TFMUL is
	signal THETA : signed(Th-1 downto 0) := (others => '0');
	signal K : unsigned(F-1 downto 0) := (others => '0');
	signal R : unsigned(F downto 0) := (others => '0');
begin
	THETA_GEN : entity WORK.THETA_GEN(RTL) port map (
  	K  		=> K,
  	Theta  	=> THETA,
  	ADDR 	=> ADDR); 
	
	CORDIC : entity WORK.CORDIC(RTL) generic map ( L => C_C)
	port map (
    DATA_IN  => DATA_IN,
   	THETA    => THETA,
   	DATA_OUT => DATA_OUT,
	W_OUT => Wout,
	CLK	 => CLK,
	RES	 => RES,
	EN   => EN);

	--THETA(F+Mbit) <= '0';
	--THETA(F+Mbit-1 downto 0) <= signed(THETA_0);
	
	SUM1 : process(EN,Ki)
		variable Rtemp : unsigned(F downto 0) := (others => '0');
		variable Ttemp : unsigned(2*F+1 downto 0) := to_unsigned(1,2*F+2);
	begin
		Ttemp := to_unsigned(1,Ttemp'length);
		Rtemp := (others => '0');
		for I in 1 to C-1 loop
			if I < to_integer(S) then
				for J in 0 to C-2 loop
					if J < I then
						Ttemp := resize(Ttemp*M(J),Ttemp'length);
					end if;
				end loop;
				Rtemp := Rtemp + resize(Ttemp*Ki(I),Rtemp'length);
				Ttemp := to_unsigned(1,Ttemp'length);
			end if;
		end loop;
		R <= resize(Rtemp,R'length);
		Rtemp := (others => '0');
		Ttemp := to_unsigned(1,Ttemp'length);
	end process SUM1;

	Ko <= K;
	Tout <= THETA;
	K <= resize((Ki(0) + R)*Ki(to_integer(S)),K'length);
	--K <= resize((Ki(to_integer(SMAX-S)) + R)*Ki(to_integer(S)),K'length); --to evaluate R, I between 1 and S-1
	--K <= resize((Ki(0) + R),K'length);
end STRUCT;
