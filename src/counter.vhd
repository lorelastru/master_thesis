------------------------------------------------
-- Counter used to generate the indices for the 
-- address generator
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : CNT
-- Architecture Name : RTL
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;
use IEEE.math_real.all;

entity CNT is
	port( 	  MAX : in unsigned(T downto 0);
	      CLK,RES,EN : in std_logic;
		    COUNT : out unsigned(3 downto 0);
		     DONE : out std_logic);
end CNT;

architecture RTL of CNT is
	signal CNT_int,MAX_int : unsigned (4 downto 0) := (others => '0');
begin
	process(CLK,RES)
	begin
		if RES = '0' then
  	  			CNT_int <= "00000";
				DONE <= '0';			
		elsif (CLK'event and CLK = '1') then
			if EN = '1' then			
				if CNT_int = MAX-1 then
					CNT_int <= "00000";
					DONE <= '1';
				else
		    		CNT_int <= CNT_int + 1;
					DONE <= '0';
				end if;	
		 	else
				CNT_int <= CNT_int;
				DONE <= '0';
			end if;
	    end if;
	end process;
	--MAX_int <= resize(MAX-1,MAX_int'length) when not(MAX = "00000") else "00001";
	--DONE <= '1' when MAX - CNT_int -1 = "00000" else '0';
	COUNT <= CNT_int(3 downto 0);
end RTL;
