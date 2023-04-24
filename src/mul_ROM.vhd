------------------------------------------------
-- PEB multipliers ROM
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

entity MULROM is
  generic ( K : integer := 0);
  port (
    ADDR : in  unsigned(MRbit-1 downto 0);
    DATA : out TF_ROM);
end MULROM;

architecture RTL of MULROM is
	--constant MULROM : T_MULROM := TFMULROM(K)(0 to MR-1);
  	constant MULROM : T_MULROM := F_MULROM(K);   
begin  
  	DATA <= MULROM(to_integer(ADDR));  
end RTL;
