library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;

entity MUX_4 is
 	port  (          SEL : in std_logic_vector(1 downto 0);
		 X0,X1,X2,X3 : in COMPLEX;
		           Y : out COMPLEX);
end MUX_4;

architecture RTL of MUX_4 is
begin
	Y <= X0 when SEL = "00" else X1 when SEL = "01" else X2 when SEL = "10" else X3 when SEL = "11";
end RTL;
