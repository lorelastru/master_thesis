------------------------------------------------
-- Scale factors ROM
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : SCALE_ROM
-- Architecture Name : RTL
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.workpack.all;

entity SCALE_ROM is
  generic ( I : integer := 0);
  port ( S : in  signed(Th-1 downto 0);
    	 K : out signed(Th-1 downto 0));
end SCALE_ROM;

architecture RTL of SCALE_ROM is
  constant SCALEROM : T_SCALEROM := F_SCALEROM(I);   
begin  
  K <= SCALEROM(to_integer(abs(S)));  
end RTL;
