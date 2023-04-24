------------------------------------------------
-- Control Unit 
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : CU
-- Architecture Name : RTL
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;


entity CU is 
	port(   START,CLK,RES,
		L_DONE,R_DONE 	 : in std_logic;
		N,P    		 	 : in CASCADE(0 to 7);
		SMAX             : in unsigned(2 downto 0);
		MODE             : in unsigned(12 downto 0);
		EN_BU,EN_C,START_L,L,
		START_R,DONE,CTRL : out std_logic;
		IT_MAX_OUT	     : out integer;
		SEL              : out std_logic_vector(3 downto 0);
		S_OUT            : out unsigned(2 downto 0);
		N_OUT	 		 : out CASCADE(0 to 7);
		P_OUT	 		 : out unsigned(4 downto 0);
		ADDR_C		 	 : out unsigned(Abit-1 downto 0));
end CU;
	
architecture RTL of CU is
	type STATE is (IDLE,SETUP,LOAD,WORK,READ);
	signal S_NOW,S_NEXT : STATE := IDLE;
	signal S,S0 : integer range 0 to 8:= 0;
	signal IT,IT_0 : integer range 0 to 512:= 0;
	signal N_int : CASCADE(0 to 7) := (others =>( others =>'0'));
	--signal P_int : unsigned(4 downto 0);
	signal L_int,DONE_int,CTRL_int : std_logic := '0';
begin	
	--Main FSM process
	process(START,S_NOW,S,L_DONE,R_DONE,IT)
		variable IT_MAX : integer := 0;		
		variable NS : integer := 0;
		variable Ntemp : CASCADE(0 to 7);
	begin
		S_NEXT <= IDLE;
		S0 <= 0;
		IT_0 <= 0;

		L_int <= '0';
		EN_BU <= '0';
		EN_C <= '0';
		START_L <= '0';
		START_R <= '0';
		DONE_int <= '0';
		P_OUT <= P(S);
		N_OUT <= N_int;
		S_OUT <= to_unsigned(S,S_OUT'length);
	
		if to_integer(SMAX) = 0 then
			IT_MAX := 1;
		elsif to_integer(SMAX) > 1 then
			IT_MAX := to_integer(N_int(1)/P(S))-1;
		else
			IT_MAX := to_integer(MODE/(N_int(0)*P(S)));
		end if;

		IT_MAX_OUT <= IT_MAX;

		case S_NOW is
			when IDLE =>
				CTRL_int <= '0';
				if START = '1' then
					CTRL_int <= '0';
					--START_L <= '1';
					L_int <= '1';
					S_NEXT <= SETUP;	
				end if;
			when SETUP =>
				START_L <= '1';
				L_int <= '1';
				S_NEXT <= LOAD;	
			when LOAD =>
				if L_DONE = '1' then
					S_NEXT <= WORK;
					START_R <= '1';
					CTRL_int <= '1';
					EN_BU <= '1';
				else
					L_int <= '1';
					S_NEXT <= LOAD;
				end if;
			when WORK =>
				if S = 0 then
					CTRL_int <= '1';
					S_NEXT <= WORK;
					EN_BU <= '1';
					S0 <= S;
					IT_0 <= IT + 1;
					if IT = C_BU then
						START_L <= '1';	
					elsif L_DONE = '1' then
						EN_C <= '1';
						S0 <= S + 1;
						CTRL_int <= '0';
						IT_0 <= 0;
						START_R <= '1';
						if S = to_integer(SMAX) then
							S_NEXT <= READ;
							P_OUT <= P(0);
							N_OUT <= N;
							S_OUT <= to_unsigned(0,S_OUT'length);
							S0 <= 0;
							DONE_int <= '1';
						end if;
					end if;
				elsif S > 0 and S < to_integer(SMAX) then
					S_NEXT <= WORK;
					EN_C <= '1';
					EN_BU <= '1';
					S0 <= S;
					IT_0 <= IT + 1;
					if to_unsigned(S,1) = 1 then
						CTRL_int <= '0';
					else
						CTRL_int <= '1';
					end if;
					if IT = C_BU + C_C then
						START_L <= '1';	
					elsif L_DONE = '1' then
						S0 <= S + 1;
						if to_unsigned(S+1,1) = 1 then
							CTRL_int <= '0';
						else
							CTRL_int <= '1';
						end if;
						IT_0 <= 0;
						START_R <= '1';
					end if;
				else
					if to_unsigned(S,1) = 1 then
						CTRL_int <= '0';
					else
						CTRL_int <= '1';
					end if;
					S_NEXT <= WORK;
					EN_C <= '1';
					EN_BU <= '1';
					S0 <= S;  
					IT_0 <= IT + 1;
					if IT = C_BU + C_C then
						START_L <= '1';
					elsif L_DONE = '1' then
						IT_0 <= 0;
						S_NEXT <= READ;
						START_R <= '1';
						EN_C <= '0';
						EN_BU <= '0';
						P_OUT <= P(0);
						
						S_OUT <= to_unsigned(0,S_OUT'length);
						--DONE_int <= '1';
						S0 <= 0;
						if SMAX(0) = '1' then
							CTRL_int <= '1';
						else
							CTRL_int <= '0';
						end if;
					end if;
					
				end if;	
			when READ =>
					if SMAX(0) = '1' then
						CTRL_int <= '1';
					else
						CTRL_int <= '0';
					end if;
					N_OUT <= N;
					S0 <= S;
					if R_DONE = '1' then
						S_NEXT <= IDLE;
						DONE_int <= '0';
					else
						S_NEXT <= READ;
						DONE_int <= '1';
					end if;
		end case;
		
		NS := to_integer(N(S));	
		case NS is
			when 16 => 		--radix-16
				SEL <= "1111";
			when 8 => 		--radix-8
				SEL <= "1101";
			when 5 => 		--radix-5
				SEL <= "1011";	
			when 4 => 		--radix-4
				SEL <= "0001";
			when 3 =>		--radix-3
				SEL <= "1001";
			when 2 =>		--radix-2 
				SEL <= "0000";
			when others => SEL <= "XXXX";
		end case;
	end process;
	
	--Registers of the FSM
	process(CLK)
	begin
		if CLK'event and CLK = '1' then 
			if RES = '0' then
				S_NOW <= IDLE;
				S <= 0;
				IT <= 0;
			else
				S_NOW <= S_NEXT;
				S <= S0;
				IT <= IT_0;
			end if;
		end if;
	end process;
	
	--Generates the ADDRESSES for the TFMUL ROM at each stage
	ADDR_C_GEN : process(S0,START)
		variable prod : integer range 0 to 4096 := 0 ;
	begin
		prod := 1;
		for I in 0 to C-1 loop
			if I < S0+1 then
				prod := prod*to_integer(N(I));
			end if;
		end loop;
		case prod is
			when 4096 =>
				ADDR_C <= (others => '0');
			when 256 =>
				ADDR_C <= to_unsigned(1,ADDR_C'length);
			when 60 =>
				ADDR_C <= to_unsigned(2,ADDR_C'length);
			when 12 =>
				ADDR_C <= to_unsigned(3,ADDR_C'length);
			when 48 =>
				ADDR_C <= to_unsigned(4,ADDR_C'length);
			when 240 =>
				ADDR_C <= to_unsigned(5,ADDR_C'length);
			when 1200 =>
				ADDR_C <= to_unsigned(6,ADDR_C'length);
			when 20 =>
				ADDR_C <= to_unsigned(7,ADDR_C'length);
			when 40 =>
				ADDR_C <= to_unsigned(8,ADDR_C'length);
			when 32 =>
				ADDR_C <= to_unsigned(9,ADDR_C'length);
			when 64 =>
				ADDR_C <= to_unsigned(10,ADDR_C'length);
			when 128 =>
				ADDR_C <= to_unsigned(11,ADDR_C'length);
			when 96 =>
				ADDR_C <= to_unsigned(12,ADDR_C'length);
			when 512 =>
				ADDR_C <= to_unsigned(13,ADDR_C'length);
			when 1536 =>
				ADDR_C <= to_unsigned(14,ADDR_C'length);
			when 768 =>
				ADDR_C <= to_unsigned(15,ADDR_C'length);
			when 30 =>
				ADDR_C <= to_unsigned(16,ADDR_C'length);
			when 15 =>
				ADDR_C <= to_unsigned(17,ADDR_C'length);
			when 24 =>
				ADDR_C <= to_unsigned(18,ADDR_C'length);
			when 80 =>
				ADDR_C <= to_unsigned(19,ADDR_C'length);
			when others => 
				ADDR_C <= (others => 'X');
		end case;
	end process;
	
	process(S,START)
	begin
		for I in 0 to C-1 loop
			if I < to_integer(SMAX)+1 then
				if I + S > to_integer(SMAX) then
					N_int(I) <= N(I + S - to_integer(SMAX) - 1);
				else
					N_int(I) <= N(I + S);
				end if;
			end if;
		end loop;
	end process;

	DONE <= DONE_int;
	CTRL <= CTRL_int;
	L <= L_int;
	
end RTL;








