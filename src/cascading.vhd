------------------------------------------------
-- Generates the DFT cascade N=N0*N1*..NS
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : FFT_CAS
-- Architecture Name : RTL
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;

entity FFT_CAS is
	port (  MODE : in unsigned(12 downto 0); 
	        SMAX : out unsigned(2 downto 0);
		       N : out CASCADE(0 to 7);
		       P : out CASCADE(0 to 7));
end FFT_CAS;

architecture RTL of FFT_CAS is
	constant CAS : T_CASCADE := F_CASCADE(LENGTHS);
	constant S_MAX : T_SMAX := F_SMAX(LENGTHS);
	signal ADDR : unsigned(Abit-1 downto 0);
begin
	ADDR_GEN : process(MODE)
		variable M : integer;
	begin
		M := to_integer(MODE);
		case M is
			when 4096 =>
				ADDR <= (others => '0');
			when 256 =>
				ADDR <= to_unsigned(1,ADDR'length);
			when 60 =>
				ADDR <= to_unsigned(2,ADDR'length);
			when 12 =>
				ADDR <= to_unsigned(3,ADDR'length);
			when 48 =>
				ADDR <= to_unsigned(4,ADDR'length);
			when 240 =>
				ADDR <= to_unsigned(5,ADDR'length);
			when 1200 =>
				ADDR <= to_unsigned(6,ADDR'length);
			when 20 =>
				ADDR <= to_unsigned(7,ADDR'length);
			when 40 =>
				ADDR <= to_unsigned(8,ADDR'length);
			when 32 =>
				ADDR <= to_unsigned(9,ADDR'length);
			when 64 =>
				ADDR <= to_unsigned(10,ADDR'length);
			when 128 =>
				ADDR <= to_unsigned(11,ADDR'length);
			when 96 =>
				ADDR <= to_unsigned(12,ADDR'length);
			when 512 =>
				ADDR <= to_unsigned(13,ADDR'length);
			when 1536 =>
				ADDR <= to_unsigned(14,ADDR'length);
			when 768 =>
				ADDR <= to_unsigned(15,ADDR'length);
			when 30 =>
				ADDR <= to_unsigned(16,ADDR'length);
			when 15 =>
				ADDR <= to_unsigned(17,ADDR'length);
			when 24 =>
				ADDR <= to_unsigned(18,ADDR'length);
			when 80 =>
				ADDR <= to_unsigned(19,ADDR'length);
			when others => 
				ADDR <= (others => 'X');
		end case;
	end process;
	
	N <= CAS(0)(to_integer(ADDR));
	P <= CAS(1)(to_integer(ADDR));
	SMAX <= S_MAX(to_integer(ADDR));
end RTL;

--FFT_CASCADING : process(MODE)
		--variable M,I : integer;  
	--begin
		--N <= (others =>(others => '0'));
		--P <= (others =>(others => '0'));
		--M := to_integer(MODE);
		--I := 0;
		--while M > 1 loop
			--if M mod 16 = 0 then
				--N(I) <= to_unsigned(16,N(I)'length);
				--M := M/16;
				--P(I) <= to_unsigned(1,P(I)'length);
			--elsif M mod 8 =	0 then 
				--N(I) <= to_unsigned(8,N(I)'length);
				--M := M/8;
				--if to_integer(MODE) mod (8*2) = 0 then
					--P(I) <= to_unsigned(2,P(I)'length);
				--else
					--P(I) <= to_unsigned(1,P(I)'length);
				--end if;
			--elsif M mod 4 =	0 then 
				--N(I) <= to_unsigned(4,N(I)'length);
				--M := M/4;
				--if to_integer(MODE) mod (4*4) =	0 then 
					--P(I) <= to_unsigned(4,P(I)'length);
				--elsif to_integer(MODE) mod (4*3) = 0 then
					--P(I) <= to_unsigned(3,P(I)'length);
				--elsif to_integer(MODE) mod (2*4) = 0 then
					--P(I) <= to_unsigned(2,P(I)'length);
				--else
					--P(I) <= to_unsigned(1,P(I)'length);
				--end if;
			--elsif M mod 3 =	0 then 
				--N(I) <= to_unsigned(3,N(I)'length);
				--M := M/3;
				--if to_integer(MODE) mod (3*4) = 0 then 
					--P(I) <= to_unsigned(1,P(I)'length);
				--elsif to_integer(MODE) mod (3*3) = 0 then
					--P(I) <= to_unsigned(3,P(I)'length);
				--elsif to_integer(MODE) mod (3*2) = 0 then
					--P(I) <= to_unsigned(2,P(I)'length);
				--else
					--P(I) <= to_unsigned(1,P(I)'length);
				--end if;
			--elsif M mod 5 =	0 then 
				--N(I) <= to_unsigned(5,N(I)'length);
				--M := M/5;
				--if to_integer(MODE) mod (2*5) = 0 then
					--P(I) <= to_unsigned(2,P(I)'length);
				--else
					--P(I) <= to_unsigned(1,P(I)'length);
				--end if;			
			--elsif M mod 2 = 0 then 
				--N(I) <= to_unsigned(2,N(I)'length);
				--M := M/2;
				--if to_integer(MODE) mod 8*2 = 0 then 
					--P(I) <= to_unsigned(8,P(I)'length);	
				--elsif to_integer(MODE) mod 6*2 = 0 then 
					--P(I) <= to_unsigned(6,P(I)'length);
				--elsif to_integer(MODE) mod 5*2 = 0 then 
					--P(I) <= to_unsigned(5,P(I)'length);			
				--elsif to_integer(MODE) mod 4*2 = 0 then 
					--P(I) <= to_unsigned(4,P(I)'length);
				--elsif to_integer(MODE) mod 3*2 = 0 then
					--P(I) <= to_unsigned(3,P(I)'length);
				--elsif to_integer(MODE) mod 2*2 = 0 then
					--P(I) <= to_unsigned(2,P(I)'length);
				--else
					--P(I) <= to_unsigned(1,P(I)'length);
				--end if;	
			--end if;
			--I := I+1;
		--end loop;
		--SMAX <= to_unsigned(I-1,SMAX'length);
	--end process FFT_CASCADING;
	
