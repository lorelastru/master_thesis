------------------------------------------------
-- Selection function for the CORDIC rotator
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : SEL_FUNC
-- Architecture Name : RTL
------------------------------------------------
-- WIP
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.workpack.all;

entity SEL_FUNC is
	port (  W : in signed(Th-1 downto 0);
			S : out signed(Th-1 downto 0));
end SEL_FUNC;

architecture RTL_I of SEL_FUNC is
	--signal W_int : signed(Th-1 downto 0);
begin
	--W_int <= shift_right(W,N-2);
	S <= to_signed(-2,S'length) when W < shift_left(to_signed(-3,W'length),N-2) else
		 to_signed(-1,S'length) when W < shift_left(to_signed(-1,W'length),N-2) else
		 to_signed(0,S'length) when W < shift_left(to_signed(1,W'length),N-2) else
		 to_signed(1,S'length) when W < shift_left(to_signed(3,W'length),N-2) else
		 to_signed(2,S'length);
end RTL_I;

architecture RTL_0 of SEL_FUNC is
	--signal W_int : signed(Th-1 downto 0);
begin
	--W_int <= shift_right(W,N-4);
	S <= to_signed(-2,S'length) when W < shift_left(to_signed(-7,W'length),N-4) else
		 to_signed(-1,S'length) when W < shift_left(to_signed(-4,W'length),N-4) else
		 to_signed(0,S'length) when W < shift_left(to_signed(3,W'length),N-4) else
		 to_signed(1,S'length) when W < shift_left(to_signed(5,W'length),N-4) else
		 to_signed(2,S'length);
end RTL_0;
		

