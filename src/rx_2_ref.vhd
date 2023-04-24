------------------------------------------------
-- Reformulated Radix-2 Butterfly
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : RX_2_ref
-- Architecture Name : RTL
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;

entity RX_2_ref is
 	port    (    A,B : in COMPLEX;
		     	 X,Y : out COMPLEX;
		      	   S : in std_logic);
end RX_2_ref;

architecture RTL of RX_2_ref is
	signal T1R,T1I,T2R,T2I : signed(N downto 0);
begin
	T1R <= resize(A(0),T1R'length) + resize(B(0),T1R'length);
	T1I <= resize(A(1),T1R'length) + resize(B(1),T1R'length);
	
	--T2R <= resize(A(0),T1R'length) - resize(B(0),T1R'length) when S = '0' else resize(A(0),T1R'length) - (B(0)(B(0)'length-1) &"0"& B(0)(B(0)'length-2 downto 1));
	--T2I <= resize(A(1),T1R'length) - resize(B(1),T1R'length) when S = '0' else resize(A(1),T1R'length) - (B(1)(B(1)'length-1) &"0"& B(1)(B(1)'length-2 downto 1));

	T2R <= resize(A(0),T1R'length) - resize(B(0),T1R'length) when S = '0' else resize(A(0),T1R'length) - resize(shift_right(B(0),1),T1R'length);
	T2I <= resize(A(1),T1R'length) - resize(B(1),T1R'length) when S = '0' else resize(A(1),T1R'length) - resize(shift_right(B(1),1),T1R'length);

	X(0) <= T1R(N downto 1);
	X(1) <= T1I(N downto 1);
	Y(0) <= T2R(N downto 1);
	Y(1) <= T2I(N downto 1);	
	
	--X(0) <= resize(T1R,X(0)'length);
	--X(1) <= resize(T1I,X(0)'length);
	--Y(0) <= resize(T2R,X(0)'length);
	--Y(1) <= resize(T2I,X(0)'length);
end RTL;
