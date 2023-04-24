-----------------------------------------------------
-- FFT processor
-- Lorenzo Lastrucci
-----------------------------------------------------
-- Entity Name       : FFT
-- Architecture Name : TOP 
-----------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;
use IEEE.math_real.all;


entity FFT is 
	port (	data_in	 : in COMPLEX_ARRAY(0 to L-1);
			MODE     : in unsigned(12 downto 0);
			CLK,RES,START : in std_logic;
			DONE,LO  : out std_logic;
			data_out : out COMPLEX_ARRAY(0 to L-1);
			N_out,P_out : out CASCADE(0 to 7);
			SMAX_out : out unsigned(2 downto 0);
			S_out 	 : out unsigned(2 downto 0));
end FFT;

architecture TOP of FFT is
	signal data_in_0,data_I,data_O,data_C,data_B1,data_B4 : COMPLEX_ARRAY(0 to L-1) := (others => (others => (others => '0')));
	signal data_B2 : COMPLEX_ARRAY(0 to 19) := (others => (others => (others => '0')));
	signal data_B3 : COMPLEX_ARRAY(0 to 51) := (others => (others => (others => '0')));
	signal addr_load, addr_read : T_ADDR(0 to L-1);
	signal bank_load, bank_read : T_BANK(0 to L-1);
	signal S : unsigned(2 downto 0);
	signal SEL : std_logic_vector(3 downto 0);
	signal START_L,START_R,EN_BU,EN_C,CTRL,L_DONE,R_DONE,LOAD,READ,DONE_int,WRITE : std_logic;
	signal N0,N,P_cas : CASCADE(0 to 7);
	signal P : unsigned(4 downto 0);
	signal SMAX : unsigned(2 downto 0) := to_unsigned(1,3);
	signal Ki_0,Ki : INDICES_MATRIX(0 to L-1) := (others => (others => (others => '0')));
	signal ADDR_C : unsigned(Abit-1 downto 0);
	signal IT_MAX : integer;
begin
	LO <= LOAD;
	N_out <= N0;
	P_out <= P_cas;
	S_out <= S;
	SMAX_out <= SMAX;
	DONE <= DONE_int;
	-- Memory Input Multiplexer
	--data_I_0 <= data_in when LOAD = '1' else data_B4;
	data_I <= data_in_0 when LOAD = '1' else data_B4;
	data_out <= data_O;

	-- Memory Block
	MEMORY : entity work.MEMORY(RTL)
	port map (
	data_in   => data_I,
	addr_load => addr_load,
	bank_load => bank_load,
	addr_read => addr_read,
	bank_read => bank_read,
	N         => N,
	P		  => P,
	CTRL 	  => CTRL,
	CLK		  => CLK,
	WE	      => WRITE,
	RE	  	  => READ,
	data_out  => data_O);
	
	-- Input Address Generator
	LOAD_AG : entity work.AG(STRUCT)
	port map (
	N     => N,
	N_cas => N0,
	P     => P,
	S     => S,
	MODE  => MODE,
	SMAX  => SMAX,
	IT_MAX=> IT_MAX,
	START => START_L,
	CLK   => CLK,
	RES   => RES,
	DONE  => L_DONE,
	bank  => bank_load,
	address => addr_load,
	W     => WRITE);

	--Output Address Generator
	READ_AG : entity work.AG(STRUCT)
	port map (
	N     => N,
	N_cas => N0,
	P     => P,
	S     => S,
	MODE  => MODE,
	SMAX  => SMAX,
	IT_MAX=> IT_MAX,
	START => START_R,
	CLK   => CLK,
	RES   => RES,
	DONE  => R_DONE,
	Ni_out=> Ki_0,
	bank  => bank_read,
	address => addr_read,
	W     => READ);

	-- Twiddle Factor Multipliers
	TFMUL : entity work.TWIDDLE(STRUCT)
	port map (
	DATA_IN    => data_O,
	N	   => N0,
	S	   => S,
	P	   => P,
	SMAX       => SMAX,
    ADDR 	   => ADDR_C,
	Ki         => Ki,
    DATA_OUT   => data_C,
    CLK	   => CLK,
	RES	   => RES,
	EN 	   => EN_C);

	-- Butterfly input Multiplexer
	data_B1 <= data_C when EN_C = '1' else data_O;
	
	--Processing Element
	IN_MUX : entity work.IN_MUX(RTL)
	port map (
	X => data_B1,
	Y => data_B2,
	SEL => SEL);
	
	BU : entity work.BU(STRUCT)
	port map (
	X => data_B2,
	Y => data_B3,
	SEL => SEL,
	CLK => CLK,
	RES => RES,
	EN  => EN_BU);
	
	OUT_MUX : entity work.OUT_MUX(RTL)
	port map (
	X => data_B3,
	Y => data_B4,
	SEL => SEL);

	-- FFT cascade generator
	FFT_CASCADE: entity WORK.FFT_CAS(RTL)
 	port map (
	P     => P_cas,
	SMAX  => SMAX,
	N     => N0,
	MODE  => MODE); 
 
	-- Control Unit
	CU : entity work.CU(RTL)
	port map(
	START	=> START,
	CLK	=> CLK,
	RES	=> RES,
	L_DONE	=> L_DONE,
	R_DONE 	=> R_DONE,
	N	=> N0,
	P	=> P_cas,
	SMAX    => SMAX,
	MODE    => MODE,
	EN_BU	=> EN_BU,
	EN_C	=> EN_C,
	START_L	=> START_L,
	L	=> LOAD,
	START_R	=> START_R,
	CTRL	=> CTRL,
	DONE 	=> DONE_int,
	SEL     => SEL,
	S_OUT   => S,         
	P_OUT	=> P,
	N_OUT 	=> N,
	ADDR_C  => ADDR_C,
	IT_MAX_OUT=> IT_MAX);

	process(CLK)
	begin
		if CLK'event and CLK = '1' then 
			if RES = '0' then
				Ki <= (others => (others => (others => '0')));
				data_in_0 <= (others => (others => (others => '0')));
			else
				Ki <= Ki_0;
				data_in_0 <= data_in;
			end if;
		end if;
	end process;
end TOP;













