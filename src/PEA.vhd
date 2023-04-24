------------------------------------------------
-- Processing Element A
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : PEA
-- Architecture Name : STRUCT
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;

entity PEA is
 	port    (  X :  in COMPLEX_ARRAY(0 to 9);
		   Y : out COMPLEX_ARRAY(0 to 15);
		   SEL :  in std_logic_vector(3 downto 0));
end PEA;

architecture STRUCT of PEA is
	signal T : COMPLEX_ARRAY(0 to 13) := (others =>((others=>'0'),(others=>'0')));
	signal M : COMPLEX_ARRAY(0 to 1) := (others =>((others=>'0'),(others=>'0')));
	signal X_0,X_5 : COMPLEX := ((others=>'0'),(others=>'0'));
	signal SEL1 : std_logic;
begin
	--Input radix-2 butterfly units	
	R2_1 : entity WORK.RX_2(RTL) port map (	  
        A => X(1),	--x20_1, x40_1
        B => X(2),	--x21_1, x42_1
        X => T(0),	--T40_1, X20_1
        Y => T(1));	--T41_1, X21_1
	
	R2_2 : entity WORK.RX_2(RTL) port map (
        A => X(3),	--x20_2, x31_1, x41_1, x54
        B => X(4),	--x21_2, x32_1, x43_1, x51
        X => T(2),	--T42_1, T30_1, T50, X20_2
        Y => T(3));	--T43_1, T31_1, T51, X21_2
	
	R2_3 : entity WORK.RX_2(RTL) port map (
        A => X(6),	--x20_3, x40_2
        B => X(7),	--x21_3, x42_2
        X => T(4),	--T40_2, X20_3
        Y => T(5));	--T41_2, X21_3

	R2_4 : entity WORK.RX_2(RTL) port map (
        A => X(8),	--x20_4, x31_2, x41_2, x52
        B => X(9),	--x21_4, x32_2, x43_2, x53
        X => T(6),	--T42_2, T30_2, T52, X20_4
        Y => T(7));	--T43_2, T31_2, T53, X21_4

	--Internal MUXs
	SEL1 <= '0' when (SEL = "0001" or SEL = "1101" or SEL = "1111" or SEL = "0000") else '1';	
	
	X_0(0) <= shift_right(X(0)(0),1) when SEL = "1011" else X(0)(0); --
	X_0(1) <= shift_right(X(0)(1),1) when SEL = "1011" else X(0)(1);	--used to scale the representation correctly when radix-5
	
	X_5(0) <= shift_right(X(5)(0),1) when SEL = "1011" else X(5)(0); --
	X_5(1) <= shift_right(X(5)(1),1) when SEL = "1011" else X(5)(1);	--used to scale the representation correctly when radix-5
	
	MUX_1 : entity WORK.MUX(RTL) port map (
        X0 => T(0),	--T40_1 
		X1 => X_0,	--x30_1, x50
        Y => T(8),
	SEL => SEL1);

	MUX_2 : entity WORK.MUX(RTL) port map (
        X0 => T(1),	--T41_1
        X1 => T(2),	--T50
        Y => T(9),
	SEL => SEL1);
	
	MUX_3 : entity WORK.MUX(RTL) port map (
        X0 => M(0),	--T43_1
        X1 => T(6),	--T52
        Y => T(10),
	SEL => SEL1);

	MUX_4 : entity WORK.MUX(RTL) port map (
        X0 => T(4),	--T40_2
		X1 => X_5,	--x30_2, x50
        Y => T(11),
	SEL => SEL1);

	MUX_5 : entity WORK.MUX(RTL) port map (
        X0 => T(5),	--T41_2
        X1 => T(3),	--T51
        Y => T(12),
	SEL => SEL1);

	MUX_6 : entity WORK.MUX(RTL) port map (
        X0 => M(1),	--T43_2
	X1 => T(7),	--T53
        Y => T(13),
	SEL => SEL1);

	--Trivial Multipliers
	M(0)(0) <= T(3)(1);
	M(0)(1) <= -T(3)(0);	--T43_1

	M(1)(0) <= T(7)(1);	
	M(1)(1) <= -T(7)(0);	--T43_2
	
	--Output radix-2 butterfly units
	Y(0) <= T(0);	--X20_1
	Y(2) <= T(1);	--X21_1
	Y(4) <= T(2);	--X20_2
	Y(6)(0) <= T(3)(0) when SEL1 = '0' else shift_right(T(3)(0),1); 	--
	Y(6)(1) <= T(3)(1) when SEL1 = '0' else shift_right(T(3)(1),1); 	--T31_1, T51, X21_2	
	Y(8) <= T(4);	--X20_3
	Y(10) <= T(5);	--X21_3
	Y(12)(0) <= T(6)(0) when SEL1 = '0' else shift_right(T(6)(0),1);	--
	Y(12)(1) <= T(6)(1) when SEL1 = '0' else shift_right(T(6)(1),1);	--X20_4, T52
	Y(14)(0) <= T(7)(0) when SEL1 = '0' else shift_right(T(7)(0),1);	--
	Y(14)(1) <= T(7)(1) when SEL1 = '0' else shift_right(T(7)(1),1);	--T31_2, T53, X21_4
		
	
	R2_5 : entity WORK.RX_2_ref(RTL) port map (	  
        A => T(8),	
        B => T(2),	--T30_1, T50, T42_1
        X => Y(1),	--T32_1, X40_1, T54
        Y => Y(3),	--X42_1,T33_1, T55
	S => SEL1);	
	
	R2_6 : entity WORK.RX_2(RTL) port map (
        A => T(9),	
        B => T(10),	
        X => Y(5),	--X41_1
        Y => Y(7));	--X43_1 T58
	
	R2_7 : entity WORK.RX_2_ref(RTL) port map (	  
        A => T(11),	
        B => T(6),	
        X => Y(9),	--T32_2, X40_2
        Y => Y(11),	--X42_2,T33_2, T56
	S => SEL1);	

	R2_8 : entity WORK.RX_2(RTL) port map (
        A => T(12),	
        B => T(13),	
        X => Y(13),	--X41_2, T59
        Y => Y(15));	--X43_2
end STRUCT;




















