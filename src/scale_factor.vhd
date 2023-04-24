library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.WORKPACK.all;

entity SCALING is
	port(  X_IN : in signed(N-1 downto 0);
		   Y_IN : in signed(N-1 downto 0);
		     KI : in W_DLINE(0 to SF_last);
      	  X_OUT : out signed(N-1 downto 0);
	      Y_OUT : out signed(N-1 downto 0));  
end SCALING;

architecture RTL of SCALING is
	signal K : signed(Th-1 downto 0) := (others => '0');
begin
	process(KI)
		variable Ktemp : signed(Th-1 downto 0) := to_signed(2**(N-1),Th); 
	begin
		Ktemp := to_signed(2**(N-1),Th);
		for I in 0 to SF_last-1 loop
			Ktemp := resize(shift_right(Ktemp*KI(I),N-1),Th);
		end loop;
		K <= Ktemp;
	end process;	

	X_OUT <= resize(shift_right(K*X_IN,N-1),X_OUT'length);
	Y_OUT <= resize(shift_right(K*Y_IN,N-1),Y_OUT'length);
end RTL;
