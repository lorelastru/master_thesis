------------------------------------------------
-- Memory Control Unit  -- Testbench
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : TB_MEM_CU
-- Architecture Name : TEST
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.WORKPACK.all;
use IEEE.math_real.all;
use STD.TEXTIO.all;

entity TB_MEM_CU is
  
end TB_MEM_CU;

architecture TEST of TB_MEM_CU is
  constant OUTDEL : time := 2 ns;       -- sampling dalay of outputs
  constant TCK : time := 10 ns;         -- clock period
  constant TMAX : time := 10000 ns;      -- max simulation time 
  signal S : unsigned(2 downto 0) := (others => '0'); 
  signal SMAX : unsigned(2 downto 0) := to_unsigned(2,3); 
  signal N : CASCADE(0 to 7) := (,,,0,0,0,0,0);  -- Input of the memory controller
  signal Ni : INDICES(0 to 7);	
  signal CLK, RES, START, DR : std_logic := '0';
begin  -- TEST

  -- change entity, architecture and port names according 
  -- with your model
  DUT: entity WORK.MEM_CU(RTL)
  port map (
	N     => N,
      	Ni    => Ni,
      	S     => S,
	SMAX  => SMAX,
	RES   => RES,
	START => START,
      	CLK   => CLK,
	DR    => DR);  

  -- CLK e RES generation
  CLK <= not CLK after TCK/2 when now < TMAX;
  RES <= '1' after 2 ns;
  START <= '1' after 5 ns;

  -- Input generation
  process
  begin
    while not(S = SMAX) loop
	if DR = '1' then
		S <= S + to_unsigned(1,S'length);
	end if;
        wait until CLK'event and CLK = '1';
    end loop;
  end process;
end TEST;

