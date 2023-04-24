------------------------------------------------
-- Theta angles Generator 
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : THETA_GEN
-- Architecture Name : RTL
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.workpack.all;

entity THETA_GEN is
	port (  ADDR : in unsigned(Abit-1 downto 0);
		K : in unsigned(F-1 downto 0);
		Theta : out signed(Th-1 downto 0));  
end THETA_GEN;

architecture RTL of THETA_GEN is
	signal man : unsigned(Mbit-1 downto 0) := (others => '0');      -- Mantissa of the length
	signal exp : unsigned(Ebit-1 downto 0) := (others => '0');      -- Exponent of the length
	signal prod: unsigned(F+Mbit-1 downto 0) := (others => '0');    -- Product
begin
	ROM : entity WORK.ROM(RTL) port map(         -- Lengths ROM
	ADDR => ADDR,
	DATA_man => man,
	DATA_exp => exp);
 
	SHIFT : entity WORK.RS(RTL) port map(	     -- Right shifter to apply the exponent
	A => prod,
	B => exp,
	Theta => Theta);  
	
	prod <= K * man;			     -- Multiplier between K and the Mantissa
	
end RTL;
