------------------------------------------------
-- Input switching
-- Used to route elements coming from the memory 
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : IN_MUX
-- Architecture Name : RTL
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;

entity IN_MUX is
 	port    (  X :  in COMPLEX_ARRAY(0 to L-1);
		   Y : out COMPLEX_ARRAY(0 to 19);
		   SEL : in std_logic_vector(3 downto 0));
end IN_MUX;

architecture RTL of IN_MUX is
	constant O : COMPLEX := ((others=>'0'),(others=>'0'));
begin
	process(SEL,X)
	begin
		case SEL is
			when "0000" => 
				Y(0) <= O;
				Y(1) <= X(0);
				Y(2) <= X(1);
				Y(3) <= X(2);
				Y(4) <= X(3);
				Y(5) <= O;
				Y(6) <= X(4);
				Y(7) <= X(5);
				Y(8) <= X(6);
				Y(9) <= X(7);
				Y(10) <= O;
				Y(11) <= X(8);
				Y(12) <= X(9);
				Y(13) <= X(10);
				Y(14) <= X(11);
				Y(15) <= O;
				Y(16) <= X(12);
				Y(17) <= X(13);
				Y(18) <= X(14);
				Y(19) <= X(15);
			when "0001" => 
				Y(0) <= O;
				Y(1) <= X(0);
				Y(2) <= X(2);
				Y(3) <= X(1);
				Y(4) <= X(3);
				Y(5) <= O;
				Y(6) <= X(4);
				Y(7) <= X(6);
				Y(8) <= X(5);
				Y(9) <= X(7);
				Y(10) <= O;
				Y(11) <= X(8);
				Y(12) <= X(10);
				Y(13) <= X(9);
				Y(14) <= X(11);
				Y(15) <= O;
				Y(16) <= X(12);
				Y(17) <= X(14);
				Y(18) <= X(13);
				Y(19) <= X(15);
			when "1001" => 
				Y(0) <= X(0);
				Y(1) <= O;
				Y(2) <= O;
				Y(3) <= X(1);
				Y(4) <= X(2);
				Y(5) <= X(3);
				Y(6) <= O;
				Y(7) <= O;
				Y(8) <= X(4);
				Y(9) <= X(5);
				Y(10) <= X(6);
				Y(11) <= O;
				Y(12) <= O;
				Y(13) <= X(7);
				Y(14) <= X(8);
				Y(15) <= X(9);
				Y(16) <= O;
				Y(17) <= O;
				Y(18) <= X(10);
				Y(19) <= X(11);
			when "1011" => 		--radix-5
				Y(0) <= X(0);		--x50_1
				Y(1) <= O;
				Y(2) <= O;
				Y(3) <= X(4);		--x54_1
				Y(4) <= X(1);		--x51_1
				Y(5) <= X(0);		--x50_1
				Y(6) <= O;
				Y(7) <= O;
				Y(8) <= X(2);		--x52_1
				Y(9) <= X(3);		--x53_1

				Y(10) <= X(5);
				Y(11) <= O;
				Y(12) <= O;
				Y(13) <= X(9);
				Y(14) <= X(6);
				Y(15) <= X(5);
				Y(16) <= O;
				Y(17) <= O;
				Y(18) <= X(7);
				Y(19) <= X(8);
			when "1101" => 
				Y(0) <= O;
				Y(1) <= X(0);
				Y(2) <= X(4);
				Y(3) <= X(2);
				Y(4) <= X(6);
				Y(5) <= O;
				Y(6) <= X(1);
				Y(7) <= X(5);
				Y(8) <= X(3);
				Y(9) <= X(7);
				Y(10) <= O;
				Y(11) <= X(8);
				Y(12) <= X(12);
				Y(13) <= X(10);
				Y(14) <= X(14);
				Y(15) <= O;
				Y(16) <= X(9);
				Y(17) <= X(13);
				Y(18) <= X(11);
				Y(19) <= X(15);
			when "1111" => 
				Y(0) <= O;
				Y(1) <= X(0);
				Y(2) <= X(8);
				Y(3) <= X(4);
				Y(4) <= X(12);
				Y(5) <= O;
				Y(6) <= X(1);
				Y(7) <= X(9);
				Y(8) <= X(5);
				Y(9) <= X(13);
				Y(10) <= O;
				Y(11) <= X(2);
				Y(12) <= X(10);
				Y(13) <= X(6);
				Y(14) <= X(14);
				Y(15) <= O;
				Y(16) <= X(3);
				Y(17) <= X(11);
				Y(18) <= X(7);
				Y(19) <= X(15);

			when others => Y <= (others => O);
		end case;
	end process;
end RTL;
