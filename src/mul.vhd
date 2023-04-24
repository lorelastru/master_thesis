------------------------------------------------
-- Complex Multiplier
-- Lorenzo Lastrucci
------------------------------------------------
-- Entity Name       : MEM_CU
-- Architecture Name : RTL
------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.WORKPACK.all;

entity MUL is
  generic( K : integer :=0 );
  port (
    X    : in COMPLEX;
    SEL  : in std_logic_vector(1 downto 0);
    Y    : out COMPLEX);

end MUL;

architecture RTL of MUL is
	signal W : TF_ROM := ((others=>'0'),(others=>'0'));
	signal ADDR : unsigned(MRbit -1 downto 0);
begin  
  	MULT: process (X, W)
    	variable ER, ES, ED, YR, YI : signed(2*N+1 downto 0);
  	begin 
    	ER := W(0) * (resize(X(0),N+1) - resize(X(1),N+1));
    	ES := (resize(W(0),N+2) + resize(W(1),N+2)) * X(0);
	 	ED := (resize(W(0),N+2) - resize(W(1),N+2)) * X(1);

	 	YR := ED + ER;
    	YI := ES - ER;

		Y(0) <= YR(2*N+1)&YR(2*N-3 downto N-1); 
		Y(1) <= YI(2*N+1)&YI(2*N-3 downto N-1); 
	end process MULT;

	--Y(0) <= resize(X(0)*W(0) - X(1)*W(1),Y(0)'length);
	--Y(1) <= resize(X(0)*W(1) + X(1)*W(0),Y(1)'length);

	--Y(0) <= to_signed(integer(real(to_integer(X(0)))*real(to_integer(W(0)))*2.0**(-F) - real(to_integer(X(1)))*real(to_integer(W(1)))*2.0**(-F)),Y(0)'length);
	--Y(1) <= to_signed(integer(real(to_integer(X(0)))*real(to_integer(W(1)))*2.0**(-F) + real(to_integer(X(1)))*real(to_integer(W(0)))*2.0**(-F)),Y(1)'length);

	ROM : entity WORK.MULROM(RTL) 
	generic map(
	K => K)
	port map(
	ADDR => ADDR,
	DATA => W);

	ADDR_GEN: process(SEL)
	begin
		case SEL is
			when "00" => ADDR <= to_unsigned((0),ADDR'length);
			when "01" => ADDR <= to_unsigned((1),ADDR'length);
			when "10" => ADDR <= to_unsigned((2),ADDR'length);
			when others => ADDR <= to_unsigned((3),ADDR'length);
		end case;
	end process ADDR_GEN;

end RTL;
