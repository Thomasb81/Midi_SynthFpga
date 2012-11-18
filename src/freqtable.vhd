library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity freqtable is
port(
	 clk : in std_logic;
	 addr : in std_logic_vector (9 downto 0);
	 en :in std_logic;
	 do : out std_logic_vector ( 17 downto 0));	 
end freqtable;

architecture Behavioral of freqtable is

begin
notes : RAMB16_S18 -- The 127 constants of how far to advance the saveform each 1/48,000th of a second
   generic map (
      INIT => X"000",
      SRVAL => X"000",
      INIT_00 => X"01650151013e012c011c010c00fd00ee00e100d400c800bd00b300a9009f0000",
      INIT_01 => X"03840352032202f502ca02a2027c02590237021701f901dd01c201a90191017a",
      INIT_02 => X"08dc085d07e50773070806a3064405ea0595054504f904b1046e042e03f203ba",
      INIT_03 => X"1653151313e412c711b810ba0fc90ee70e100d460c880bd40b2a0a8909f20963",
      INIT_04 => X"38423519321e2f4e2ca72a2527c8258c237021731f931dcd1c211a8d190f17a7",
      INIT_05 => X"8dc285cd7e4b773470836a33643d5e9d594d544a4f8f4b1846e142e73f253b9a",
      INIT_06 => X"653551283e3c2c601b840b9afc95ee68e107d465c87abd39b29aa8949f1e9630",
      INIT_07 => X"841a519621e7f4e5ca6aa2517c7858bf37081734f92adcd0c20da8cb90f37a72",
      INITP_00 => X"feaaa55555500000000000000000000000000000000000000000000000000000",
      WRITE_MODE => "WRITE_FIRST")
   port map (
      DO   => do(15 downto 0),   -- 16-bit Data Output
      DOP  => do(17 downto 16),  -- 2-bit parity Output
      ADDR => addr, -- 10-bit Address Input
      CLK  => clk,             -- Clock
      DI   => (others => '0'),   -- 8-bit Data Input
      DIP  => (others => '0'),   -- 1-bit parity Input
      EN   => '1',               -- RAM Enable Input
      SSR  => '0',                 -- Synchronous Set/Reset Input
      WE   => '0'                -- Write Enable Input
   );
	
end Behavioral;

