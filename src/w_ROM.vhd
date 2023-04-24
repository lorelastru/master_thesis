------------------------------------------------
-- W_cells ROM
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : mul_ROM
-- Architecture Name : RTL
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.workpack.all;

entity WROM is
  generic ( K : integer := 0);
  port ( ADDR : in  unsigned(C_RADIX/2 downto 0);
    	 DATA : out signed(Th-1 downto 0));
end WROM;

architecture RTL of WROM is
  constant WROM : T_WROM := F_WROM(K);   
begin  
  DATA <= WROM(to_integer(ADDR));  
end RTL;
