------------------------------------------------
-- Butterfly Unit testbench
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : TB_BU
-- Architecture Name : TEST
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.WORKPACK.all;
use IEEE.math_real.all;
use STD.TEXTIO.all;

entity TB_BU is
  
end TB_BU;

architecture TEST of TB_BU is
  constant OUTDEL : time := 1 ns;       -- sampling dalay of outputs
  constant TCK : time := 2 ns;          -- clock period
  constant TMAX : time := 100 ns;     -- max simulation time

  signal X  : COMPLEX_ARRAY(0 to 15) := (others => (others => (others => '0')));
  signal X1 : COMPLEX_ARRAY(0 to 19) := (others => (others => (others => '0')));
  signal Y0 : COMPLEX_ARRAY(0 to 51) := (others => (others => (others => '0')));
  signal Y : COMPLEX_ARRAY(0 to 15) := (others => (others => (others => '0')));
  signal CLK, RES, DONE : std_logic := '0';
  signal SEL : std_logic_vector(3 downto 0) := "1000"; 
begin  -- TEST

  -- change entity, architecture and port names according 
  -- with your model
  DUT: entity WORK.BU(STRUCT)
    port map (
      X  => X1,
      CLK => CLK,
      RES => RES,
      SEL => SEL,
      EN => SEL(3),
      Y => Y0);

  IN_DRA: entity WORK.IN_MUX(RTL)
    port map (
      X => X,
      Y => X1,
      SEL => SEL);

  OUT_DRA: entity WORK.OUT_MUX(RTL)
    port map (
      X => Y0,
      Y => Y,
      SEL => SEL);

  -- CLK e RES generation
  CLK <= not CLK after TCK/2 when now < TMAX;
  RES <= '1' after 12 ns; 
  SEL <= "1101" after 8 ns;	
  -- loading X data from file
  process
    variable VLINE : line;
    variable V : real;
    file INP_FILE : text open read_mode is "./matlab/x_data.txt";
  begin
    while not(endfile(INP_FILE)) loop
      if RES = '1' then
	for i in 0 to 7 loop
        	readline(INP_FILE, VLINE);
        	read(VLINE, V);
        	X(i)(0) <= to_signed(integer(V*2.0**F), N);
	end loop;
      end if;
      wait until CLK'event and CLK = '0';
    end loop;
	DONE <= '1';
	wait for TCK;
	DONE <= '0';
	wait for TCK*10;
	
    wait; 

  end process;

  -- sampling Y and writing values on file
  process
    variable WLINE : line;
    variable W1,W2 : real;
    file OUT_FILE : text open write_mode is "./matlab/yv_data_bu.txt";
  begin
    wait until CLK'event and CLK = '1';
    if RES = '1' then
      wait for OUTDEL;
      if DONE = '1' then
	for i in 0 to 7 loop
               	W1 := real(to_integer(Y(i)(0)))*2.0**(-F); 
      		write(WLINE, W1,left,15);
      		W2 := real(to_integer(Y(i)(1)))*2.0**(-F); 
      		write(WLINE, W2,left,15);
      		writeline(OUT_FILE, WLINE);
	end loop;
      end if; 
    end if;
  end process; 

end TEST;
