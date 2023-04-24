library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.workpack.all;

entity TB_RX2_ref is
  
end TB_RX2_ref;

architecture TEST of TB_RX2_ref is
	signal A,B,X,Y,Z : COMPLEX := ((others=>'0'),(others=>'0'));
	signal CLK : std_logic;
begin  -- TEST

  process
  begin
    A(0) <= to_signed(1,A(0)'length);
    A(1) <= to_signed(1,A(0)'length);
    B(0) <= to_signed(1,A(0)'length);
    B(1) <= to_signed(1,A(0)'length);
    for I in 0 to 15 loop
      A(0) <= A(0)+to_signed(I,A(0)'length);
      A(1) <= A(1)+to_signed(I,A(0)'length);
      B(0) <= B(0)+to_signed(I,A(0)'length);
      B(1) <= B(1)+to_signed(I,A(0)'length);
      
      CLK <= '0'; 
      wait for 10 ns;
      CLK <= '1';
      wait for 10 ns;
    end loop;  -- I
    wait;
  end process; 
  
  -- NB: change the name of the entity and the architecture according to those chosen by you
  DUT : entity WORK.RX_2_ref(RTL) port map (
        A  => A,
        B  => B,
        X  => X,
        Y  => Y,
        Z  => Z);

end TEST;
