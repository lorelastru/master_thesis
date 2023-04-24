------------------------------------------------
-- Butterfly Unit
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : BU
-- Architecture Name : STRUCT
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;

entity BU is
 	port    (  X :  in COMPLEX_ARRAY(0 to 19);
		   Y : out COMPLEX_ARRAY(0 to 51);
		   SEL :  in std_logic_vector(3 downto 0);
		   CLK, RES, EN : in std_logic);
end BU;

architecture STRUCT of BU is
	signal T1 : COMPLEX_ARRAY(0 to 31) := (others =>((others=>'0'),(others=>'0')));
	signal T2 : COMPLEX_ARRAY(0 to 28) := (others =>((others=>'0'),(others=>'0')));
	signal T3 : COMPLEX_ARRAY(0 to 26) := (others =>((others=>'0'),(others=>'0')));
	signal T4 : COMPLEX_ARRAY(0 to 19) := (others =>((others=>'0'),(others=>'0')));
	signal T5 : COMPLEX_ARRAY(0 to 35) := (others =>((others=>'0'),(others=>'0')));
begin
	--PEA 	
	PEA_1 : entity WORK.PEA(STRUCT) port map (	  
        X => X(0 to 9),	
        Y => T1(0 to 15),
        SEL => SEL);
	
	PEA_2 : entity WORK.PEA(STRUCT) port map (	  
        X => X(10 to 19),	
        Y => T1(16 to 31),
        SEL => SEL);

	--AB_MUX
	AB_MUX : entity WORK.AB_MUX(STRUCT) port map (
	X   => T1,
	Y   => T2,
	SEL => SEL);
	
	--PEB
	PEB : entity WORK.PEB(STRUCT) port map (
	X   => T2(16 to 28),
	Y   => T3(16 to 26),
	CLK => CLK,
	RES => RES,
	SEL => SEL(2 downto 1),
	EN  => EN);
	
	--DELAY
	DELAY : entity WORK.DELAY(RTL) port map (
	X   => T2(0 to 15),
	Y   => T3(0 to 15),
	CLK => CLK,
	RES => RES,
	EN  => EN);
	
	--BC_MUX
	BC_MUX : entity WORK.BC_MUX(STRUCT) port map (
	X   => T3,
	Y   => T4,
	SEL => SEL);
	
	--PEC
	PEC_1 : entity WORK.PEC(STRUCT) port map (	  
        X => T4(0 to 9),	
        Y => T5(0 to 17),
        SEL => SEL(2 downto 1));
	
	PEC_2 : entity WORK.PEC(STRUCT) port map (	  
        X => T4(10 to 19),	
        Y => T5(18 to 35),
        SEL => SEL(2 downto 1));

	Y(0 to 15) <= T3(0 to 15);
	
	Y(16 to 51) <= T5(0 to 35);
	
end STRUCT;
