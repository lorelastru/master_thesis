------------------------------------------------
-- Processing Element B
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : PEB
-- Architecture Name : STRUCT
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;

entity PEB is
 	port    (  X :  in COMPLEX_ARRAY(0 to 12);
		   Y : out COMPLEX_ARRAY(0 to 10);
		   SEL : in std_logic_vector(1 downto 0);
		   CLK,RES,EN :  in std_logic);
end PEB;

architecture STRUCT of PEB is
	signal T : COMPLEX_ARRAY(0 to X'length) := (others =>((others=>'0'),(others=>'0')));
	signal P : COMPLEX_ARRAY(0 to Y'length) := (others =>((others=>'0'),(others=>'0')));
	type TEMP is array(natural range<>) of signed(N downto 0);
	signal R1,R2 : TEMP(0 to 1);
begin
	--Input Registers
	IN_REG:for i in 0 to X'length-1 generate
		process(CLK)
		begin		
		if CLK'event and CLK = '1' then
			if RES = '0' then
				T(I) <= ((others=>'0'),(others=>'0'));
			elsif EN = '1' then
				T(I) <= X(I);
			end if;
		end if;
		end process;
	end generate IN_REG;
	
	--Multipliers
	MUL_GEN :for i in 0 to 8 generate
		MUL : entity WORK.MUL(RTL) 
		generic map(
		K => i)
		port map(
		X => T(i),
		SEL => SEL,
		Y => P(i));
	end generate MUL_GEN;

	--Complex Adders Radix-5
	R1(0) <= resize(T(9)(0),R1(0)'length) + resize(T(10)(0),R1(0)'length);		--
	R1(1) <= resize(T(9)(1),R1(0)'length) + resize(T(10)(1),R1(0)'length);		--T_57_1

	R2(0) <= resize(T(11)(0),R1(0)'length) + resize(T(12)(0),R1(0)'length);		--
	R2(1) <= resize(T(11)(1),R1(0)'length) + resize(T(12)(1),R1(0)'length);		--T_57_2

	P(9)(0) <= R1(0)(N downto 1); --T(9)(0) + T(10)(0); 		--
	P(9)(1) <= R1(1)(N downto 1); --T(9)(1) + T(10)(1);			--T_57_1

	P(10)(0) <= R2(0)(N downto 1); --T(11)(0) + T(12)(0);		--
	P(10)(1) <= R2(1)(N downto 1); --T(11)(1) + T(12)(1);		--T_57_2


	--Output Registers
	OUT_REG:for i in 0 to Y'length-1 generate
		process(CLK)
		begin		
		if CLK'event and CLK = '1' then
			if RES = '0' then
				Y(I) <= ((others=>'0'),(others=>'0'));
			elsif EN = '1' then
				Y(I) <= P(I);
			end if;
		end if;
		end process;
	end generate OUT_REG;
end STRUCT;
