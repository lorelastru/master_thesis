------------------------------------------------
-- Address Generator
-- Generates 16 addresses and banks number 
-- for the memory
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : AG
-- Architecture Name : STRUCT in uso
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;
use IEEE.math_real.all;

entity AG is
	port (	N,N_cas : in CASCADE(0 to 7);
			P       : in unsigned(4 downto 0);
			SMAX,S  : in unsigned(2 downto 0);
			MODE    : in unsigned(12 downto 0);
			IT_MAX  : in integer;
			START,CLK,RES : in std_logic;
			DONE,W  : out std_logic;
			bank    : out T_BANK(0 to L-1);
			address : out T_ADDR(0 to L-1);
			Ni_out  : out INDICES_MATRIX(0 to L-1));
end AG;

architecture STRUCT of AG is 
	signal NI_int : INDICES_MATRIX(0 to L-1) := (others =>(others => (others => '0')));
	signal Ni : INDICES(2 to C-1) := (others => (others => '0'));
	signal N0,N1 : INDICES(0 to L-1) := (others => (others => '0'));
	signal EN_int : std_logic_vector(1 to C-1) := (others => '0');
	signal RES_int,W_int : std_logic := '0';
	signal IT,IT0 : integer := 0;
	type STATE is (IDLE,GEN);
	signal S_NOW,S_NEXT : STATE := IDLE;
begin
	-- Ordering the indexes based on the stage
	process(S,W_int,N0,N1,Ni)
	begin
		for I in 0 to L-1 loop
			if SMAX > 1 then
				if S < SMAX then
					NI_int(I)(to_integer(S)) <= N0(I);
					NI_int(I)(1 + to_integer(S)) <= N1(I);
					NI_int(I)(2 + to_integer(S) to C-1) <= NI(2 + to_integer(S) to C-1);
					NI_int(I)(0 to to_integer(S) - 1) <= NI(2 to 2 + to_integer(S) - 1);
					--for J in 2 to C-1 loop
						--if J + to_integer(S) < C then
							--NI_int(I)(J + to_integer(S)) <= NI(J + to_integer(S));
						--else
							--NI_int(I)(J + to_integer(S)-C) <= NI(J + to_integer(S)-C+2);
						--end if;
					--end loop;						
				else
					NI_int(I)(to_integer(SMAX)) <= N0(I);
					NI_int(I)(0) <= N1(I);
					NI_int(I)(to_integer(SMAX)+1 to C-1) <= NI(to_integer(SMAX)+1 to C-1);
					NI_int(I)(1 to to_integer(SMAX)-1) <= NI(2 to to_integer(SMAX));
					--for J in 2 to C-1 loop
						--if J + to_integer(S) < C then
							--NI_int(I)(J + to_integer(S)) <= NI(J + to_integer(S));
						--else
							--NI_int(I)(J + to_integer(S)-C) <= NI(J + to_integer(S)-C+2);
						--end if;
					--end loop;
				end if;
			else
				NI_int(I)(to_integer(S)) <= N0(I);
				NI_int(I)(1 - to_integer(S)) <= N1(I);
			end if;
		end loop;
	end process;

	--Bank and Address generation
	gen1 : for I in 0 to L-1 generate
		ADDGEN : entity WORK.ADD_GEN(RTL)
		port map (
		N	=> N,
		Ni	=> NI_int(I),
		SMAX    => SMAX,
		bank    => bank(I),
		address => address(I)); 
	end generate;
	
	--Generation of indices from 2 to 7
	CNT : entity WORK.CNT(RTL)
	port map (
	MAX   => N(2),
	CLK	  => CLK,
	EN	  => EN_int(1),	
	RES   => RES_int,
	COUNT => Ni(2),
	DONE  => EN_int(2)); 

	gen2 : for I in 3 to C-1 generate
		CNT : entity WORK.CNT(RTL)
		port map (
		MAX   => N(I),
		CLK   => EN_int(I-1),
		EN	  => EN_int(1),
		RES   => RES_int,
		COUNT => Ni(I),
		DONE  => EN_int(I));  
	end generate;

 	NI_out <= NI_int;
	
	W <= W_int;

	-- FSM to control the AG operations
	process(START,S_NOW,IT,EN_int(2 to C-1))
		variable Ntemp,Ptemp : integer := 0;
	begin
		S_NEXT <= IDLE;
		EN_int(1) <= '0';
		RES_int <= '0';
		IT0 <= 0;
		DONE <= '0';
		W_int <= '0';
		N1 <= (others => (others => '0'));
		N0 <= (others => (others => '0'));

		case S_NOW is
			when IDLE =>
				if START = '1' then
					S_NEXT <= GEN;
					RES_int <= '0';
				end if;
			when GEN => 
				--Generation of the first 2 indices
				Ntemp := to_integer(N(0));
				Ptemp := to_integer(P);
				for I in 0 to Ptemp-1 loop
					--if I < Ptemp then
						for J in 0 to Ntemp-1 loop
							--if J < Ntemp then
								N0(J+(I*Ntemp)) <= to_unsigned(J,T);
								N1(J+(I*Ntemp)) <= to_unsigned(I+IT*Ptemp,T);
							--end if;
						end loop;
					--end if;
				end loop;
				
				IT0 <= IT+1;
				RES_int <= '1';
				W_int <= '1';
				if to_integer(SMAX) < 2 then
					if IT = IT_MAX then
						N1 <= (others => (others => '0'));
						N0 <= (others => (others => '0'));
						IT0 <= 0;
						DONE <= '1';
						RES_int <= '0';
						W_int <= '0';
						S_NEXT <= IDLE;
					else
						S_NEXT <= GEN;
					end if;
				else
					if EN_int(to_integer(SMAX)) = '1' then
						IT0 <= 0;
						DONE <= '1';
						W_int <= '0';
						--RES_int <= '0';
						S_NEXT <= IDLE;
						N1 <= (others => (others => '0'));
						N0 <= (others => (others => '0'));
					else
						if IT = IT_MAX then
							EN_int(1) <= '1';
							IT0 <= 0;
							S_NEXT <= GEN;
						else
							S_NEXT <= GEN;
						end if;
					end if;
				end if;
		end case;
	end process;
	
	process(CLK)
	begin
		if CLK'event and CLK = '1' then 
			if RES = '0' then
				S_NOW <= IDLE;
				IT <= 0;
			else
				S_NOW <= S_NEXT;
				IT <= IT0;
			end if;
		end if;
	end process;	
end STRUCT;


