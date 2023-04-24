library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use WORK.WORKPACK.all;

entity PIPE is
	port(    X_IN : in signed(N-1 downto 0);
		     Y_IN : in signed(N-1 downto 0);
			 W_IN : in signed(Th-1 downto 0);
		  CLK,RES,EN : in std_logic;
      	    X_OUT : out signed(N-1 downto 0);
	        Y_OUT : out signed(N-1 downto 0);
			W_OUT : out signed(Th-1 downto 0));  
end PIPE;

architecture RTL of PIPE is
begin
	process(CLK)
	begin
		if CLK'event and CLK = '1' then 
			if RES = '0' then
				X_OUT <= (others => '0');
				Y_OUT <= (others => '0');
				W_OUT <= (others => '0');
			elsif EN = '1' then
				X_OUT <= X_IN;
				Y_OUT <= Y_IN;
				W_OUT <= W_IN;
			end if;
		end if;
	end process;
end RTL;

