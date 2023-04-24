------------------------------------------------
-- XY cell of the cordic rotator
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

entity XY_CELL is
	generic( I : integer := 0);
	port(  X_IN : in signed(N-1 downto 0);
		   Y_IN : in signed(N-1 downto 0);
		      S : in signed(Th-1 downto 0);
      	  X_OUT : out signed(N-1 downto 0);
	      Y_OUT : out signed(N-1 downto 0));  
end XY_CELL;

architecture RTL of XY_CELL is
	signal Xtemp,Ytemp : signed(N-1 downto 0);
begin
	Xtemp <= shift_right(X_IN,2*I);
	Ytemp <= shift_right(Y_IN,2*I);
	X_OUT <= resize(X_IN + Ytemp*S,X_OUT'length);
	Y_OUT <= resize(Y_IN - Xtemp*S,Y_OUT'length);
end RTL;
