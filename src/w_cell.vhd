------------------------------------------------
-- W cell of the cordic rotator
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

entity W_CELL is
	generic( I : integer := 0);
	port(  W_IN : in signed(Th-1 downto 0);
      	  W_OUT : out signed(Th-1 downto 0);
	      S_OUT : out signed(Th-1 downto 0));  
end W_CELL;

architecture RTL_I of W_CELL is
	signal S_int : signed(Th-1 downto 0);
	signal ADDR : unsigned(C_RADIX/2 downto 0);
	signal W : signed(Th-1 downto 0);
begin
	SEL_FUNC : entity WORK.SEL_FUNC(RTL_I) port map(
	W => W_IN,
	S => S_int);
	
	W_ROM : entity WORK.WROM(RTL) generic map ( K => I) 
	port map(
	ADDR => ADDR,
	DATA =>W);

	ADDR <= to_unsigned(to_integer(S_int + 2), ADDR'length);
	S_OUT <= S_int;
	W_OUT <= shift_left(W_IN - W,2);
	--W_OUT <= shift_left(W_IN - shift_left(S_int,N-1),2);
end RTL_I;

architecture RTL_0 of W_CELL is
	signal S_int : signed(Th-1 downto 0);
	signal ADDR : unsigned(C_RADIX/2 downto 0);
	signal W : signed(Th-1 downto 0);
begin
	SEL_FUNC : entity WORK.SEL_FUNC(RTL_0) port map(
	W => W_IN,
	S => S_int);
	
	W_ROM : entity WORK.WROM(RTL) generic map ( K => I)
	port map(
	ADDR => ADDR,
	DATA =>W);

	ADDR <= to_unsigned(to_integer(S_int + 2), ADDR'length);
	S_OUT <= S_int;
	W_OUT <= shift_left(W_IN - W,2);
	--W_OUT <= shift_left(W_IN - shift_left(S_int,N-1),2);
end RTL_0;
