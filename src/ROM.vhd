------------------------------------------------
-- FFT/DFT Lengths ROM (Automated version)
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
  constant MANROM : T_MANROM := F_MANROM(LENGTHS);   -- Mantissa
  constant EXPROM : T_EXPROM := F_EXPROM(LENGTHS);   -- Exponent
begin  

  DATA_man <= MANROM(to_integer(ADDR));
  DATA_exp <= EXPROM(to_integer(ADDR));
  
end RTL;
