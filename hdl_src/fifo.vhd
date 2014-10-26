library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all; 


entity fifo is
  generic (
    bits: integer := 11;
    data_width: integer := 8
  );
  port (
    clk:      in std_logic;
    rst:      in std_logic;
    wr:       in std_logic;
    rd:       in std_logic;
    write:    in std_logic_vector(data_width -1 downto 0);
    read :    out std_logic_vector(data_width -1 downto 0);
    full:     out std_logic;
    empty:    out std_logic;
    midle:    out std_logic

  );
end entity fifo;

architecture behave of fifo is

  type mem_t is array (0 to ((2**bits)-1)) of std_logic_vector(data_width -1 downto 0);

  signal memory:  mem_t;

  signal wraddr: unsigned(bits-1 downto 0) := (others => '0');
  signal rdaddr: unsigned(bits-1 downto 0) := (others => '0');
  signal count : unsigned(bits-1 downto 0) := (others => '0');

begin

  process(clk)
  begin
    if rising_edge(clk) then
      read <= memory( conv_integer(std_logic_vector(rdaddr)) );
    end if;
  end process;

  process(clk,rdaddr,wraddr,rst,count)
    variable full_v: std_logic;
    variable empty_v: std_logic;
    variable midle_v: std_logic;
  begin
  
    if rdaddr=wraddr then
      empty_v:='1';
    else
      empty_v:='0';
    end if;

    if wraddr=rdaddr-1 then
      full_v:='1';
    else
      full_v:='0';
    end if;

    if count > (2**(bits-1)-1) then
      midle_v := '1';
    else
      midle_v := '0';
    end if;

    if rising_edge(clk) then
      if rst='1' then
        wraddr <= (others => '0');
        rdaddr <= (others => '0');
      else
  
        if wr='1' and full_v='0' then
          memory(conv_integer(std_logic_vector(wraddr) ) ) <= write;
          wraddr <= wraddr+1;
        end if;
  
        if rd='1' and empty_v='0' then
          rdaddr <= rdaddr+1;
        end if;

	if wr='1' and rd='0' and full_v = '0' then
	  count <= count + 1;
        elsif wr='0' and rd='1' and empty_v = '0' then
	  count <= count - 1;
        end if;


      end if;

      full <= full_v;
      empty <= empty_v;
      midle <= midle_v;

    end if;


  end process;
end behave;
