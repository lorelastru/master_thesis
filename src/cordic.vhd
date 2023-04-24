------------------------------------------------
-- Cordic Processor
-- Used in the Twiddle factor multiplier
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : CORDIC
-- Architecture Name : BHV  (temporary solution)
------------------------------------------------
-- Entity Name       : CORDIC
-- Architecture Name : RTL 
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.WORKPACK.all;

entity CORDIC is
	generic ( L : natural := 9);	
	port(     DATA_IN : in COMPLEX;
		    	THETA : in  signed(Th-1 downto 0);
      	     DATA_OUT : out COMPLEX;
				W_OUT : out signed(Th-1 downto 0);
	       CLK,RES,EN : in  std_logic);  
end CORDIC;


architecture BHV of CORDIC is
  	signal RR, RI : T_DLINE(0 to L) := (others => (others => '0'));
begin
	DEL: for I in 0 to L-1 generate
		process(CLK)
		begin 
			if CLK'event and CLK = '1' then 
				if RES = '0' then
					RR(I+1) <= (others => '0');
					RI(I+1) <= (others => '0');
				elsif EN = '1' then
					RR(I+1) <= RR(I);
					RI(I+1) <= RI(I);
				end if;
			end if;
		end process;
	end generate DEL;

	RR(0) <= to_signed(integer(real(to_integer(DATA_IN(0)))*cos(real(to_integer(THETA))*2.0**(-N +1)) + real(to_integer(DATA_IN(1)))*sin(real(to_integer(THETA))*2.0**(-N +1))),RR(0)'length);
	RI(0) <= to_signed(integer(real(to_integer(DATA_IN(1)))*cos(real(to_integer(THETA))*2.0**(-N +1)) - real(to_integer(DATA_IN(0)))*sin(real(to_integer(THETA))*2.0**(-N +1))),RR(0)'length);
	--RR(0) <= to_signed(integer(real(to_integer(DATA_IN(0)))*cos(real(to_integer(THETA))*2.0**(-F-Mbit+1)) - real(to_integer(DATA_IN(1)))*sin(real(to_integer(THETA))*2.0**(-F-Mbit+1))),RR(0)'length);
	--RI(0) <= to_signed(integer(real(to_integer(DATA_IN(1)))*cos(real(to_integer(THETA))*2.0**(-F-Mbit+1)) + real(to_integer(DATA_IN(0)))*sin(real(to_integer(THETA))*2.0**(-F-Mbit+1))),RR(0)'length);
	DATA_OUT(0) <= RR(L);
	DATA_OUT(1) <= RI(L);
end BHV;


architecture RTL of CORDIC is
  	signal X, Y : T_DLINE(0 to 2*L) := (others => (others => '0'));
	signal KI : W_DLINE(0 to SF_last) := (others => (others => '0'));
  	signal W : W_DLINE(0 to 2*L) := (others => (others => '0'));
	signal S : W_DLINE(0 to L-1) := (others => (others => '0'));
begin
	PRE : entity WORK.PRE(RTL) port map(
	X_in => DATA_IN(0),
	Y_in => DATA_IN(1),
	W_in => THETA,
	X_out => X(0),
	Y_out => Y(0),
	W_out => W(0));
	
	PIPE0 : entity WORK.PIPE(RTL) port map(
	X_IN  => X(0),
    Y_IN  => Y(0),
	W_IN  => W(0),
    CLK   => CLK,
	RES   => RES,
	EN 	  => EN,
    X_OUT => X(1),
    Y_OUT => Y(1),
	W_OUT => W(1));	
 
	W_CELL0 : entity WORK.W_CELL(RTL_0) port map(
	W_IN => W(1),
	W_OUT => W(2),
	S_OUT => S(0));
	
	XY_CELL0 : entity WORK.XY_CELL(RTL) port map(
	X_IN => X(1),
	Y_IN => Y(1),
	S => S(0),
	X_OUT => X(2),
	Y_OUT => Y(2));

	SCALE0 : entity WORK.SCALE(FIRST) generic map(I => 0, L => L)	
	port map(
	S => S(0),
	CLK   => CLK,
	RES   => RES,
	EN 	  => EN,
	K => KI(0));

	GEN : for I in 1 to L-1 generate
		PIPE : entity WORK.PIPE(RTL) port map(
		X_IN  => X(2*I),
		Y_IN  => Y(2*I),
		W_IN  => W(2*I),
		CLK   => CLK,
		RES   => RES,
		EN 	  => EN,
		X_OUT => X(2*I+1),
		Y_OUT => Y(2*I+1),
		W_OUT => W(2*I+1));	
	 
		W_CELL : entity WORK.W_CELL(RTL_I) generic map(I => I)	
		port map(
		W_IN => W(2*I+1),
		W_OUT => W(2*I+2),
		S_OUT => S(I));
		
		XY_CELL : entity WORK.XY_CELL(RTL) generic map(I => I)
		port map(
		X_IN => X(2*I+1),
		Y_IN => Y(2*I+1),
		S => S(I),
		X_OUT => X(2*I+2),
		Y_OUT => Y(2*I+2));
		
		SCALE_GEN_first : if I < SF_first generate
			SCALE : entity WORK.SCALE(FIRST) generic map(I => I, L => L)	
			port map(
			S => S(I),
			CLK   => CLK,
			RES   => RES,
			EN 	  => EN,
			K => KI(I));
		end generate;
		SCALE_GEN_last : if I < SF_last and I > SF_first - 1 generate 
			SCALE : entity WORK.SCALE(LAST) generic map(I => I, L => L)	
			port map(
			S => S(I),
			CLK   => CLK,
			RES   => RES,
			EN 	  => EN,
			K => KI(I));
		end generate; 
	end generate;
	
	SCALE_FACTOR : entity WORK.SCALING(RTL) port map(
	X_IN => X(2*L),
	Y_IN => Y(2*L),
	KI => KI,
	X_OUT => DATA_OUT(0),
	Y_OUT => DATA_OUT(1));
	
	W_OUT <= W(2*L);
end RTL;
