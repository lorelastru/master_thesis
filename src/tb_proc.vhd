------------------------------------------------
-- Processor testbench
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : TB_FFT
-- Architecture Name : TEST
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.WORKPACK.all;
use IEEE.math_real.all;
use STD.TEXTIO.all;

entity TB_PROC is
  
end TB_PROC;

architecture TEST of TB_PROC is
  constant OUTDEL : time := 1 ns;       -- sampling dalay of outputs
  constant TCK : time := 2 ns;          -- clock period
  constant TMAX : time := 10000 ns;     -- max simulation time

  signal MODE : unsigned(12 downto 0) := to_unsigned(4096,13); -- FFT or DFT length
  signal data_in, data_out : COMPLEX_ARRAY(0 to 15) := (others => (others => (others => '0')));
  signal CLK, RES, DONE, START, LOAD : std_logic := '0';
  signal P_out,N_out : CASCADE(0 to 7);
  signal SMAX,S_out : unsigned(2 downto 0); 
begin  -- TEST

  -- change entity, architecture and port names according 
  -- with your model
  DUT : entity work.FFT(TOP)
  port map (
  data_in => data_in,
  MODE	  => MODE,
  CLK 	  => CLK,
  RES	  => RES,
  START	  => START,
  DONE 	  => DONE,
  LO      => LOAD,
  data_out=> data_out,
  P_out   => P_out,
  N_out   => N_out,
  S_out	  => S_out,
  SMAX_out => SMAX);

  -- CLK e RES generation
  CLK <= not CLK after TCK/2 when now < TMAX;
  RES <= '1' after 12 ns; 
  START <= '1' after 15 ns, '0' after  24 ns;
  -- loading X data from file
  process
    variable VLINE : line;
    variable V : real;
    file INP_FILE : text open read_mode is "./matlab/x_data.txt";
  begin
    while not(endfile(INP_FILE)) loop
     	if LOAD = '1' then
			for i in 0 to to_integer(N_out(0)*P_out(0))-1 loop
					readline(INP_FILE, VLINE);
					read(VLINE, V);
					data_in(i)(0) <= to_signed(integer(V*2.0**(N-1)), N);
			end loop;
      	end if;
      	wait until CLK'event and CLK = '1';
    end loop;
	wait for TCK*50;
    wait; 
  end process;

-- sampling Y and writing values on file
  process
    variable WLINE : line;
    variable W1,W2 : real;
    file OUT_FILE : text open write_mode is "./matlab/yv_data.txt";
  begin
    wait until CLK'event and CLK = '1';
    if DONE = '1' then
      wait for OUTDEL;
		for i in 0 to to_integer(N_out(to_integer(S_out))*P_out(to_integer(S_out)))-1 loop
		       	W1 := real(to_integer(data_out(i)(0)))*2.0**(-N+1+integer(ceil(log2(real(to_integer(MODE)))))); 
		  		write(WLINE, W1,left,15);
		  		W2 := real(to_integer(data_out(i)(1)))*2.0**(-N+1+integer(ceil(log2(real(to_integer(MODE)))))); 
		  		write(WLINE, W2,left,15);
		  		writeline(OUT_FILE, WLINE);
		end loop;
    end if;
  end process; 

end TEST;
