library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;

entity MUX_5 is
 	port  (             SEL : in std_logic_vector(3 downto 0);
		 X0,X1,X2,X3,X4 : in COMPLEX;
		              Y : out COMPLEX);
end MUX_5;

architecture RTL of MUX_5 is
begin
	Y <= X0 when SEL = "000" else X1 when SEL = "001" else X2 when SEL = "010" else X3 when SEL = "011" else X4 when SEL = "100";
end RTL;
