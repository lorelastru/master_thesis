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

entity TFMUL_BHV is
	port(    DATA_IN : in COMPLEX;
		    	ADDR : in unsigned(Abit-1 downto 0);
		     	  Ki : in INDICES(0 to C-1);
		     	   M : in CASCADE(0 to 7);
		     	   S : in unsigned(2 downto 0);
		    	SMAX : in unsigned(2 downto 0);
      	    DATA_OUT : out COMPLEX;
				  Ko : out unsigned(F-1 downto 0);
			    Tout : out signed(Th-1 downto 0); 
	      CLK,RES,EN : in  std_logic);  
end TFMUL_BHV;

architecture STRUCT of TFMUL_BHV is
	signal THETA : signed(Th-1 downto 0) := (others => '0');
	signal K : unsigned(F-1 downto 0) := (others => '0');
	signal R,P : unsigned(F downto 0) := (others => '0');
begin
	THETA_GEN : entity WORK.THETA_GEN(RTL) port map (
  	K  		=> K,
  	Theta  	=> THETA,
  	ADDR 	=> ADDR); 
	
	CORDIC : entity WORK.CORDIC(BHV) generic map ( L => C_C)
	port map (
    DATA_IN  => DATA_IN,
   	THETA    => THETA,
   	DATA_OUT => DATA_OUT,
	CLK	 => CLK,
	RES	 => RES,
	EN   => EN);

	--THETA(F+Mbit) <= '0';
	--THETA(F+Mbit-1 downto 0) <= signed(THETA_0);
	
	SUM : process(EN,Ki)
		variable Rtemp : unsigned(F downto 0) := (others => '0');
		variable Ttemp : unsigned(2*F+1 downto 0) := to_unsigned(1,2*F+2);
	begin
		Ttemp := to_unsigned(1,Ttemp'length);
		Rtemp := (others => '0');
		for I in 1 to to_integer(S)-1 loop
			for J in 0 to I-1 loop
				Ttemp := resize(Ttemp*M(J),Ttemp'length);
			end loop;
			Rtemp := Rtemp + resize(Ttemp*Ki(I),Rtemp'length);
			Ttemp := to_unsigned(1,Ttemp'length);
		end loop;
		R <= resize(Rtemp,R'length);
		Rtemp := (others => '0');
		Ttemp := to_unsigned(1,Ttemp'length);
	end process SUM;
	
	Ko <= K;
	Tout <= THETA;
	K <= resize((Ki(0) + R)*Ki(to_integer(S)),K'length); --to evaluate R, I between 1 and S-1
	--K <= resize((Ki(to_integer(SMAX-S)) + R)*Ki(to_integer(S)),K'length); --to evaluate R, I between 1 and S-1
	--K <= resize((Ki(0) + R),K'length);
end STRUCT;
