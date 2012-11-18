----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Create Date:    06:23:08 09/11/2012 
-- Module Name:    dca - Behavioral 
-- Project Name:    Synth
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity dca is
    Port ( clk      : in  STD_LOGIC;
           sample   : in  STD_LOGIC_VECTOR (17 downto 0);
           envelope : in  STD_LOGIC_VECTOR (17 downto 0);
           result   : out  STD_LOGIC_VECTOR (17 downto 0));
end dca;

architecture Behavioral of dca is
   signal a   : std_logic_vector(17 downto 0) := (others => '0');
   signal p   : std_logic_vector(17 downto 0) := (others => '0');
   signal p2  : std_logic_vector(35 downto 0) := (others => '0');
begin
   result <= NOT(std_logic(p(17))) & std_logic_vector(p(16 downto 0));
   a      <= not(std_logic(sample(17))) & std_logic_vector(sample(16 downto 0));
   p      <= p2(35 downto 18);

dca_mult : MULT18X18	
   port map (P => p2,
      A => a,
      B => std_logic_vector(envelope)
   );


end Behavioral;
