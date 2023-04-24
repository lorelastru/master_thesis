------------------------------------------------
-- Preprocessing for the cordic multiplier
-- Used to have input angles in [-PI/2,PI/2] 
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : PRE
-- Architecture Name : RTL 
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.WORKPACK.all;

entity PRE is
	port(    X_IN : in signed(N-1 downto 0);
		     Y_IN : in signed(N-1 downto 0);
		  	 W_IN : in signed(Th-1 downto 0);
      	    X_OUT : out signed(N-1 downto 0);
	        Y_OUT : out signed(N-1 downto 0);
			W_OUT : out signed(Th-1 downto 0));  
end PRE;

architecture RTL of PRE is
begin
	X_OUT <= X_IN when W_IN > 3*PI_2 else -Y_IN when W_IN > 2*PI_2 else Y_IN when W_IN > PI_2 else X_IN;
	Y_OUT <= Y_IN when W_IN > 3*PI_2 else X_IN when W_IN > 2*PI_2 else -X_IN when W_IN > PI_2 else Y_IN;
	W_OUT <= resize(W_IN-4*PI_2,W_IN'length) when W_IN > 3*PI_2 else resize(W_IN-3*PI_2,W_IN'length) when W_IN > 2*PI_2 else W_IN-PI_2 when W_IN > PI_2 else W_IN;
end RTL;

