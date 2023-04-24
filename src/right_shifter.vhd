------------------------------------------------
-- Right Shifter 
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : RS
-- Architecture Name : RTL
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.workpack.all;

entity RS is
	port (  A : in unsigned(F+Mbit-1 downto 0);    		-- Input value
			B : in unsigned(Ebit-1 downto 0);      		-- Shifting value 
			Theta : out signed(Th-1 downto 0));    
end RS;

architecture RTL of RS is
	signal temp: signed(F+Mbit-1 downto 0) := (others => '0');
begin
	THETA <= resize(temp,Theta'length);
	temp <= signed(shift_right(A,to_integer(B+1)));
end RTL;
