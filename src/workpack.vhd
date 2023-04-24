------------------------------------------------
-- Package containing constants, data types and 
-- functions to be used in Processing Elements 
-- Twiddle factor multiplier and Memory control 
------------------------------------------------
-- Package Name : WORKPACK
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use STD.TEXTIO.all;

package WORKPACK is
	-- data fixed point format
	constant S : integer := 1;       -- 1: signed;  0: unsigned
	constant B : integer := 0;       -- number of bits for integer part
	constant F : integer := 15;      -- number of bits of fractional part and unsigned elements
	constant N : integer := S+B+F;   -- total number of bits
	constant Th : integer := N+4;   	 -- number of bits for theta angle 

	--useful constants
	constant C_BU : integer := 2;  --cycle cost of a butterfly op
	constant C_C  : integer := integer(ceil(real(N/2+1)));  --cycle cost of a cordic op
	constant PI_2 : signed(Th-1 downto 0) := to_signed(integer(MATH_pi*2.0**(N-2)),Th);
	
	--Useful types definition
	type COMPLEX is array (0 to 1) of signed(N-1 downto 0);
	type COMPLEX_ARRAY is array(natural range <>) of COMPLEX;
	type T_DLINE is array (natural range <>) of signed(N-1 downto 0);
	type W_DLINE is array (natural range <>) of signed(Th-1 downto 0);

	-- fft length cascading
	constant L : integer := 16;      			-- Parallelism of the butterfly unit
	constant T : integer := integer(ceil(log2(Real(L))));   -- Bit dimension of the indices
	constant C : integer := 8;				-- Max length of the DFT cascade
	type INDICES is array (natural range<>) of unsigned(T-1 downto 0);
	type INDICES_MATRIX is array (natural range<>) of INDICES(0 to C-1);
	type CASCADE is array (natural range<>) of unsigned(T downto 0);

	-- memory address generation

	type T_BANK is array(natural range<>) of std_logic_vector(3 downto 0);
	type T_ADDR is array(natural range<>) of std_logic_vector(7 downto 0);

	--construction of the ROM for the Rotation angle generator
	constant D : integer := 20;      -- ROM dimension
	constant Mbit : integer := N+1;  -- number of bits for the mantissa
	constant Ebit : integer := 4;   -- number of bits for the exponent
	constant Abit : integer := integer(ceil(log2(Real(D)))); -- number of bits for address
	type T_LENGTH is array (0 to D-1) of integer;
	constant LENGTHS : T_LENGTH :=  -- FFT/DFT Lengths to be stored in the ROM 
	(4096,256,60,12,48,240,1200,20,40,32,64,128,96,512,1536,768,30,15,24,80);

	type T_MANROM is array (0 to D-1) of unsigned(Mbit-1 downto 0);
	function F_MANROM (
	L : T_LENGTH)	-- Lengths to convert
	return T_MANROM;
	type T_EXPROM is array (0 to D-1) of unsigned(Ebit-1 downto 0);
	function F_EXPROM (
	L : T_LENGTH)	
	return T_EXPROM;

	--construction of the ROM for the CORDIC scale factors
	constant SF_first : integer := integer(floor(real(N)/12.0))+1; 
	constant SF_last : integer := integer(ceil(real(N)/4.0)); 
	type T_SCALEROM is array (0 to 2) of signed(Th-1 downto 0);
	function F_SCALEROM (
	K : integer)	
	return T_SCALEROM;

	--construction of the ROM for the CORDIC W cells
	constant C_RADIX : integer := 4;
	type T_WROM is array (0 to C_RADIX) of signed(Th-1 downto 0);
	function F_WROM (
	K : integer)	
	return T_WROM;

	--construction of the ROM for the PEB multiplier
	constant MR : integer := 4;
	constant MRbit : integer := integer(ceil(log2(Real(MR))));
	type TF_ROM is array (0 to 1) of signed(N downto 0);
	type T_MULROM is array (0 to MR-1) of TF_ROM;
	type A_TFMULROM is array (0 to 8) of T_MULROM;
	--constant TFMULROM : A_TFMULROM := ((((others => '0'),to_signed(integer(-sin(2.0*math_pi/3.0) *2.0**(N-1)), N+1)),((others => '0'),to_signed(integer((sin(4.0*math_pi/5.0)+sin(2.0*math_pi/5.0)) *2.0**(N-1)), N+1)),(to_signed(1,N+1),to_signed(1,N+1)),(to_signed(integer(cos(2.0*math_pi/16.0) *2.0**(N-1)), N+1),to_signed(integer(-sin(2.0*math_pi/16.0) *2.0**(N-1)), N+1))) , ((to_signed(1, N+1),(others => '0')),(to_signed(integer(cos(4.0*math_pi/5.0) *2.0**(N-1)), N+1),(others => '0')),(to_signed(1,N+1),to_signed(1,N+1)),(to_signed(integer(cos(2.0*math_pi/8.0) *2.0**(N-1)), N+1),to_signed(integer(-sin(2.0*math_pi/8.0) *2.0**(N-1)), N+1))) , (((others => '0'),to_signed(integer(-sin(2.0*math_pi/3.0) *2.0**(N-1)), N+1)),((others => '0'),to_signed(integer((sin(4.0*math_pi/5.0)+sin(2.0*math_pi/5.0)) *2.0**(N-1)), N+1)),(to_signed(1,N+1),to_signed(1,N+1)),(to_signed(integer(cos(6.0*math_pi/16.0) *2.0**(N-1)), N+1),to_signed(integer(-sin(6.0*math_pi/16.0) *2.0**(N-1)), N+1))) , ((to_signed(1, N+1),(others => '0')),((others => '0'),to_signed(integer(-sin(4.0*math_pi/5.0) *2.0**(N-1)), N+1)),(to_signed(integer(cos(2.0*math_pi/8.0) *2.0**(N-1)), N+1),to_signed(integer(-sin(2.0*math_pi/8.0) *2.0**(N-1)), N+1)),(to_signed(integer(cos(2.0*math_pi/8.0) *2.0**(N-1)), N+1),to_signed(integer(-sin(2.0*math_pi/8.0) *2.0**(N-1)), N+1))) , ((to_signed(1, N+1),(others => '0')),(to_signed(1, N+1),(others => '0')),((others => '0'),to_signed(-1, N+1)),((others => '0'),to_signed(-1, N+1))) , (((others => '0'),to_signed(integer(-sin(2.0*math_pi/3.0) *2.0**(N-1)), N+1)),((others => '0'),to_signed(integer((sin(4.0*math_pi/5.0)-sin(2.0*math_pi/5.0)) *2.0**(N-1)), N+1)),(to_signed(integer(cos(6.0*math_pi/8.0) *2.0**(N-1)), N+1),to_signed(integer(-sin(6.0*math_pi/8.0) *2.0**(N-1)), N+1)),(to_signed(integer(cos(12.0*math_pi/16.0) *2.0**(N-1)), N+1),to_signed(integer(-sin(12.0*math_pi/16.0) *2.0**(N-1)), N+1))) , ((to_signed(1, N+1),(others => '0')),((others => '0'),to_signed(integer(-sin(4.0*math_pi/5.0) *2.0**(N-1)), N+1)),(to_signed(integer(cos(2.0*math_pi/8.0) *2.0**(N-1)), N+1),to_signed(integer(-sin(2.0*math_pi/8.0) *2.0**(N-1)), N+1)),(to_signed(integer(cos(6.0*math_pi/16.0) *2.0**(N-1)), N+1),to_signed(integer(-sin(6.0*math_pi/16.0) *2.0**(N-1)), N+1))) , ((to_signed(1, N+1),(others => '0')),(to_signed(integer(cos(4.0*math_pi/5.0) *2.0**(N-1)), N+1),(others => '0')),((others => '0'),to_signed(-1, N+1)),(to_signed(integer(cos(12.0*math_pi/16.0) *2.0**(N-1)), N+1),to_signed(integer(-sin(12.0*math_pi/16.0) *2.0**(N-1)), N+1))), (((others => '0'),to_signed(integer(-sin(2.0*math_pi/3.0) *2.0**(N-1)), N+1)),((others => '0'),to_signed(integer((sin(4.0*math_pi/5.0)-sin(2.0*math_pi/5.0)) *2.0**(N-1)), N+1)),(to_signed(integer(cos(6.0*math_pi/8.0) *2.0**(N-1)), N+1),to_signed(integer(-sin(6.0*math_pi/8.0) *2.0**(N-1)), N+1)),(to_signed(integer(cos(18.0*math_pi/16.0) *2.0**(N-1)), N+1),to_signed(integer(-sin(18.0*math_pi/16.0) *2.0**(N-1)), N+1))));
	
	function F_MULROM(
		K : integer) 
	return T_MULROM;

	--construction of the cascade ROM
	type T_CAS is array (0 to D-1) of CASCADE(0 to C-1);
	type T_CASCADE is array(0 to 1) of T_CAS;
	function F_CASCADE(
	LENGTHS : T_LENGTH)
	return T_CASCADE;
	type T_SMAX is array (0 to D-1) of unsigned(2 downto 0); 
	function F_SMAX(
	LENGTHS : T_LENGTH)
	return T_SMAX;

	-- number of steps of the pipelined radix-2 CORDIC rotator
	constant NIT  : integer := 15;
	constant NBIT : integer := integer(ceil(log2(real(NIT))));
	--  constant NBIT : integer :=  4;
  
end WORKPACK;

package body WORKPACK is

	-- purpose: compute mantissa and exponent for FFT/DFT lengths ROM
	function F_MANROM (L : T_LENGTH) return T_MANROM is
		variable NUM, EXP, MAN : real;
		variable MANROM : T_MANROM;
	begin  -- F_MANROM
		for K in 0 to D-1 loop
			NUM := 2.0*MATH_pi/real(L(K));
			EXP := ceil(LOG(NUM,2.0));
			MAN := NUM/(2**(EXP-real(Mbit-1)));
			MANROM(K) := to_unsigned(integer(MAN),Mbit);  	-- mantissa
		end loop;  -- K
		return MANROM;
	end F_MANROM;

	function F_EXPROM (L : T_LENGTH) return T_EXPROM is
		variable NUM, EXP : real;
		variable EXPROM : T_EXPROM;
	begin  -- F_EXPROM
		for K in 0 to D-1 loop
			NUM := 2.0*MATH_pi/real(L(K));
			EXP := ceil(LOG(NUM,2.0));
			EXPROM(K) := to_unsigned(integer(-EXP),Ebit);        -- exponent  
		end loop;  -- K
		return EXPROM;
	end F_EXPROM;

	-- purpose: compute twiddle factors for the Processing Element B
	function F_MULROM (K : integer) return T_MULROM is
		variable MULROM : T_MULROM;
		variable VLINE1 : line;
		variable VLINE2 : line;
		variable V1 : real;
		variable V2 : real;
		file INP_FILE1 : text open read_mode is "./matlab/xr_rom.txt";
		file INP_FILE2 : text open read_mode is "./matlab/xi_rom.txt";
	begin
		for I in 0 to 35 loop
			readline(INP_FILE1, VLINE1);
			readline(INP_FILE2, VLINE2);
			read(VLINE1, V1);
			read(VLINE2, V2);
			if ((I-K) mod 9) = 0 then
		    	MULROM((I-K)/9)(0) := to_signed(integer(V1*2.0**(N-1)), N+1);		    	
				MULROM((I-K)/9)(1) := to_signed(integer(V2*2.0**(N-1)), N+1);
			end if;
		end loop;
		return MULROM;
	end F_MULROM;
	
	-- purpose: compute mantissa and exponent for FFT/DFT lengths ROM
	function F_SCALEROM (K : integer) return T_SCALEROM is
		variable SCALE : real;
		variable SCALEROM : T_SCALEROM;
	begin  -- F_MANROM
		for I in 0 to 2 loop
			SCALE := (1.0 + (4.0**(-2*K))*(real(I)**2))**(-0.5);
			SCALEROM(I) := to_signed(integer(SCALE*2.0**(N-1)),Th);  	-- scale factor I
		end loop;  -- K
		return SCALEROM;
	end F_SCALEROM;

	-- purpose: compute angle steps for cordic W cells
	function F_WROM (K : integer) return T_WROM is
		variable WROM : T_WROM;
	begin
		for I in 0 to C_RADIX loop
			WROM(I) := shift_left(to_signed(integer(ATAN(real(I - C_RADIX/2)*4.0**(-K))*2.0**(N-1)),Th), 2*K);
			--if real(I - C_RADIX/2)*4.0**(-K) < 1.0  and real(I - C_RADIX/2)*4.0**(-K) > -1.0 then
				--WROM(I) := shift_left(to_signed(integer((real(I - C_RADIX/2)*4.0**(-K) - ((real(I - C_RADIX/2)*4.0**(-K))**3)/3.0 + ((real(I - C_RADIX/2)*4.0**(-K))**5)/5.0 ) *2.0**(N-1)),Th), 2*K);
			--elsif real(I - C_RADIX/2)*4.0**(-K) = 1.0  or real(I - C_RADIX/2)*4.0**(-K) = -1.0 then
				--WROM(I) := shift_left(to_signed(integer((math_pi/4.0)*2.0**(N-1)),Th), 2*K);
			--else
				--WROM(I) := shift_left(to_signed(integer((math_pi/2.0 - 1.0/(real(I - C_RADIX/2)*4.0**(-K)) + 1.0/(((real(I - C_RADIX/2)*4.0**(-K))**3)*3.0) - 1.0/(((real(I - C_RADIX/2)*4.0**(-K))**5)*5.0) ) *2.0**(N-1)),Th), 2*K);
			--end if;
		end loop;
		return WROM;
	end F_WROM;	
		
	--purpose: compute N and P cascade for each LENGTH
	function F_CASCADE(LENGTHS : T_LENGTH) return T_CASCADE is
		variable M,I : integer;
		variable N,P : CASCADE(0 to C-1) := (others =>(others => '0'));
		variable CAS : T_CASCADE;
	begin
		for J in 0 to LENGTHS'length-1 loop
			N := (others =>(others => '0'));
			P := (others =>(others => '0'));
			M := LENGTHS(J);
			I := 0;
			while M > 1 loop
				if M mod 16 = 0 then
					N(I) := to_unsigned(16,N(I)'length);
					M := M/16;
					P(I) := to_unsigned(1,P(I)'length);
				elsif M mod 8 =	0 then 
					N(I) := to_unsigned(8,N(I)'length);
					M := M/8;
					if LENGTHS(J) mod (8*2) = 0 then
						P(I) := to_unsigned(2,P(I)'length);
					else
						P(I) := to_unsigned(1,P(I)'length);
					end if;
				elsif M mod 4 =	0 then 
					N(I) := to_unsigned(4,N(I)'length);
					M := M/4;
					if LENGTHS(J) mod (4*4) =	0 then 
						P(I) := to_unsigned(4,P(I)'length);
					elsif LENGTHS(J) mod (4*3) = 0 then
						P(I) := to_unsigned(3,P(I)'length);
					elsif LENGTHS(J) mod (2*4) = 0 then
						P(I) := to_unsigned(2,P(I)'length);
					else
						P(I) := to_unsigned(1,P(I)'length);
					end if;
				elsif M mod 3 =	0 then 
					N(I) := to_unsigned(3,N(I)'length);
					M := M/3;
					if M mod 5 = 0 then
						P(I) := to_unsigned(1,P(I)'length);
					elsif M = 2 then 
						P(I) := to_unsigned(2,P(I)'length);
					elsif LENGTHS(J) mod (3*4) = 0 then 
						P(I) := to_unsigned(4,P(I)'length);
					elsif LENGTHS(J) mod (3*3) = 0 then
						P(I) := to_unsigned(3,P(I)'length);
					elsif LENGTHS(J) mod (3*2) = 0 then
						P(I) := to_unsigned(2,P(I)'length);
					else
						P(I) := to_unsigned(1,P(I)'length);
					end if;
				elsif M mod 5 =	0 then 
					N(I) := to_unsigned(5,N(I)'length);
					M := M/5;
					if LENGTHS(J) mod (2*5) = 0 then
						P(I) := to_unsigned(2,P(I)'length);
					else
						P(I) := to_unsigned(1,P(I)'length);
					end if;			
				elsif M mod 2 = 0 then 
					N(I) := to_unsigned(2,N(I)'length);
					M := M/2;
					if LENGTHS(J) mod 3 = 0 then 
						P(I) := to_unsigned(3,P(I)'length);
					elsif LENGTHS(J) mod 5 = 0 then 
						P(I) := to_unsigned(5,P(I)'length);		
					elsif LENGTHS(J) mod 8*2 = 0 then 
						P(I) := to_unsigned(8,P(I)'length);	
					elsif LENGTHS(J) mod 6*2 = 0 then 
						P(I) := to_unsigned(6,P(I)'length);
					elsif LENGTHS(J) mod 5*2 = 0 then 
						P(I) := to_unsigned(5,P(I)'length);			
					elsif LENGTHS(J) mod 4*2 = 0 then 
						P(I) := to_unsigned(4,P(I)'length);
					elsif LENGTHS(J) mod 3*2 = 0 then
						P(I) := to_unsigned(3,P(I)'length);
					elsif LENGTHS(J) mod 2*2 = 0 then
						P(I) := to_unsigned(2,P(I)'length);
					else
						P(I) := to_unsigned(1,P(I)'length);
					end if;	
				end if;
				I := I+1;
			end loop;
			CAS(0)(J) := N;
			CAS(1)(J) := P;
		end loop;
		return CAS;
	end F_CASCADE;
	
	--purpose: calculate the stages number
	function F_SMAX(LENGTHS : T_LENGTH) return T_SMAX is
		variable M,I : integer;
		variable SMAX : T_SMAX;
	begin
		for J in 0 to LENGTHS'length-1 loop
			M := LENGTHS(J);
			I := 0;
			while M > 1 loop
				if M mod 16 = 0 then
					M := M/16;
				elsif M mod 8 =	0 then 
					M := M/8;
				elsif M mod 4 =	0 then 
					M := M/4;
				elsif M mod 3 =	0 then
					M := M/3;
				elsif M mod 5 =	0 then 
					M := M/5;
				elsif M mod 2 = 0 then
					M := M/2;
				end if;
				I := I+1;
			end loop;
			SMAX(J) := to_unsigned(I-1,SMAX(J)'length);
		end loop;
		return SMAX;
	end F_SMAX;
end WORKPACK;
