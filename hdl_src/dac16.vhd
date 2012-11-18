----------------------------------------------------------------------------------
-- Module Name: dac16 - Behavioral 
-- Author:	Mike Field (hamster@snap.net.nz)
-- Revision:	1.0
--
--
-- A 1bit DAC, based on details at http://fpga4fun.com
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dac16 is
    Port ( clk     : in  STD_LOGIC;
           rst     : in  STD_LOGIC;
           data    : in  STD_LOGIC_VECTOR (15 downto 0);
           dac_out : out STD_LOGIC);
end dac16;

architecture Behavioral of dac16 is
  signal sum : unsigned (16 downto 0);
begin
  dac_out <= std_logic(sum(16));
	
  process (Clk)
  begin		
    if rising_edge(clk) then
	   if (rst = '1') then
		  sum <=(others =>'0');
		else
        sum <= ("0" & sum(15 downto 0)) + unsigned(data);
      end if;
	 end if;
  end process;
end Behavioral;

