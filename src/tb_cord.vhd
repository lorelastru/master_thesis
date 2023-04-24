------------------------------------------------
--    DIGITAL CIRCUITS FOR NEURAL NETWORKS    --
--               Daniele Vogrig               --
------------------------------------------------
-- CORDIC processor - Testbench
-- Lab06 Material
------------------------------------------------
-- Entity Name       : TB_CORDPROC
-- Architecture Name : TEST
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.WORKPACK.all;

entity TB_CORD is
  
end TB_CORD;

architecture TEST of TB_CORD is
  signal CK, R, START : std_logic := '0';
  signal XA, YA, XR, YR : signed(N-1 downto 0);
  signal ZA,ZR : signed(Th-1 downto 0);	

  type TEST_VECTOR is array (natural range <>) of real;
  constant TEST_ANGLES : TEST_VECTOR := (60.0*MATH_pi/180.0, 30.0*MATH_pi/180.0, 45.0*MATH_pi/180.0, 90.0*MATH_pi/180.0);
  constant K : real := 1.64676; 
  constant TCK : time := 2 ns;          -- clock period
  constant TMAX : time := 100 ns;     -- max simulation time
begin  -- TEST
  
  -- RESET generation, CLOCK generation, START generation
  CK <= not CK after TCK/2 when now < TMAX;
  R <= '1' after 12 ns; 
  START <= '1' after 15 ns, '0' after 39 ns;

  --input update
  process
	variable I : integer := 0;
  begin
    XA <= (others => '0');
    YA <= (others => '0');
    ZA <= (others => '0');

    -- main loop
	while I < TEST_ANGLES'length loop
		if START = '1' then
		    -- new set of inputs
		    XA <= shift_left(to_signed(1, N),N-2);
		    YA <= (others => '0');
		    ZA <= to_signed(integer(TEST_ANGLES(I)*2.0**F), Th);
			I := I+1;
		end if;
	    wait until CK'event and CK = '1';
    -- end of simulation
	end loop;
	wait for TCK*50;
    wait; 
  end process;

  DUT : entity WORK.CORDIC(RTL) port map (
    DATA_IN(0) => XA,
    DATA_IN(1) => YA,
    THETA      => ZA,
    DATA_OUT(0)=> XR,
    DATA_OUT(1)=> YR,
	W_OUT	   => ZR,
    CLK        => CK,
    RES        => R,
    EN      => START); 
end TEST;
