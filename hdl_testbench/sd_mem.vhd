
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all ; 

entity sd_mem is

  port (
    addr : in std_logic_vector (31 downto 0);
    data : out std_logic_vector (7 downto 0)
  );

end sd_mem;

architecture behav of sd_mem is

--type mem_t is array (0 to 8388607) of std_logic_vector (7 downto 0); -- 8Mo
type mem_t is array (0 to 1048575) of std_logic_vector (7 downto 0); -- 1Mo
type file_t is file of character;

file my_file : file_t;

shared variable mem0: mem_t;
shared variable mem1: mem_t;


begin
read_p : process 

variable i: integer :=0;
variable value: character;

begin
  file_open(my_file,"1Mo_a.bin",read_mode);
  while not endfile(my_file) loop
    read(my_file,value);
    mem0(i) := std_logic_vector(to_unsigned(natural(character'pos(value )),8));
    i := i+1;
  end loop;
  file_close(my_file);
  report("From file 1Mo_b.bin read " & integer'image(i) & " byte(s)");
  i := 0;
  file_open(my_file,"1Mo_b.bin",read_mode);
  while not endfile(my_file) loop
    read(my_file,value);
    mem1(i) := std_logic_vector(to_unsigned(natural(character'pos(value )),8));
    i := i+1;
  end loop;
  file_close(my_file);
  report("From file 1Mo_b.bin read " & integer'image(i) & " byte(s)");

  wait;
end process; 

with addr(20) select 
	data <= mem0(conv_integer(addr(19 downto 0))) when '0',
		mem1(conv_integer(addr(19 downto 0))) when '1';



end behav;
