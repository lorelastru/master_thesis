------------------------------------------------
-- FFT/DFT Lengths ROM (Manual version)
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : ROM
-- Architecture Name : RTL
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.workpack.all;

entity ROM is
  
  port (
    ADDR : in  unsigned(Abit-1 downto 0);
    DATA_man : out unsigned(Mbit-1 downto 0);
    DATA_exp : out unsigned(Ebit-1 downto 0));

end ROM;

architecture RTL of ROM is
  constant MANROM : T_MANROM := 
  ("110010010000111",
   "110010010000111",
   "110010010000111",
   "101010111001001");
  
  constant EXPROM : T_EXPROM := 
  ("1001",
   "0111",
   "0110",
   "1000");
begin  -- RTL

  DATA_man <= MANROM(to_integer(ADDR));
  DATA_exp <= EXPROM(to_integer(ADDR));
  
end RTL;
