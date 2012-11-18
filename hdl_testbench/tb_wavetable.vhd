library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.txt_util.all;

library UNISIM;
use UNISIM.VComponents.all;

entity bench is
end bench;

architecture Behavioral of bench is

signal waves_out : std_logic_vector (17 downto 0);
signal waves_addr : std_logic_vector (10 downto 0) := "00000000000";
signal clk :std_logic := '1'; 

constant clock_period : time := 5 ns;
	COMPONENT RAMB16_S18_wavetable
	PORT(
		clk : IN std_logic;
		addr : IN std_logic_vector(9 downto 0);
		en : IN std_logic;          
		do : OUT std_logic_vector(17 downto 0)
		);
	END COMPONENT;

	
begin


clock_process : process
begin
  clk <= not clk;
  wait for clock_period /2;
end process;

write_file: process (clk)
file waveform0 : TEXT open WRITE_MODE is "waveform0.txt";
variable l: line;
begin
  if clk'event and clk = '1' then
    
    write(l, str(waves_addr)& " " & str(waves_out));
    writeline(waveform0,l);
    
    waves_addr <= std_logic_vector ( unsigned(waves_addr) + 1);
	 
    if waves_addr = "10000000000" then
       assert waves_addr = "10000000000" report "simulation end" severity FAILURE;
    end if;
	 
  end if;

end process;

Inst_RAMB16_S18_wavetable: RAMB16_S18_wavetable PORT MAP(
		clk => clk,
		addr => waves_addr ( 9 downto 0),
		en => '1',
		do => waves_out
	);

end Behavioral;
