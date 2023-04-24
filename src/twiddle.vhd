------------------------------------------------
-- Twiddle factor multiplier array
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : TFMUL
-- Architecture Name : STRUCT
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.WORKPACK.all;


entity TWIDDLE is
	port( 	N     : in CASCADE(0 to 7);
		P     : in unsigned(4 downto 0);
		S     : in unsigned(2 downto 0);
		Ki    : in INDICES_MATRIX(0 to L-1);
		SMAX  : in unsigned(2 downto 0);
		ADDR  : in unsigned(Abit-1 downto 0);
		EN,CLK,RES : in std_logic;
		data_in    : in COMPLEX_ARRAY(0 to L-1);
		data_out   : out COMPLEX_ARRAY(0 to L-1));
end TWIDDLE;

architecture STRUCT of TWIDDLE is
	type kout is array (natural range<>) of unsigned(F-1 downto 0); 
	signal Ko : kout(0 to L-1);
	type tout is array (natural range<>) of signed(Th - 1 downto 0); 
	signal THETA,W : tout(0 to L-1);
	signal data : COMPLEX_ARRAY(0 to L-1);
begin
	gen_tfmul : for I in 0 to L-1 generate
		TFMUL : entity work.TFMUL(STRUCT)
		port map (
		DATA_IN    => data(I),
		M	   => N,
		S	   => S,
		SMAX   => SMAX,
	    ADDR   => ADDR,
		Ki	   => Ki(I),
		Ko	   => Ko(I),
		Tout   => THETA(I),
		Wout   => W(I),
    	DATA_OUT   => data_out(I),
	    CLK	   => CLK,
		RES	   => RES,
		EN 	   => EN);
		data(I)(0) <= shift_right(data_in(I)(0),0);
		data(I)(1) <= shift_right(data_in(I)(1),0);	
	end generate;
end STRUCT;
