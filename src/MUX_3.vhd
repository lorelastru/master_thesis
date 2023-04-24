library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;

entity MUX_3 is
 	port  (       SEL : in std_logic_vector(1 downto 0);
		 X0,X1,X2 : in COMPLEX;
		        Y : out COMPLEX);
end MUX_3;

architecture RTL of MUX_3 is
begin
	Y <= X0 when SEL = "00" else X1 when SEL = "01" else X2;
end RTL;
