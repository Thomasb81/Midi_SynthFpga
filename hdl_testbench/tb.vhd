-- Adapted from Alex NetSid-papilio project
-- http://code.google.com/p/netsid-papilio/

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use IEEE.std_logic_textio.all;

library std;
	use std.textio.all;

entity testbench is
	generic(stim_file: string :="stim.txt");
end testbench;

architecture behavior of testbench is 

	-- component declaration for the unit under test (uut)

	component Synth_top
	port(
		osc_in  : in  std_logic;
		nreset : in std_logic;
		usb_rx : out std_logic;
      usb_tx : in std_logic;
      audio_l : out std_logic;		
		audio_r : out std_logic;
		led4     : out std_logic;
		led3     : out std_logic;
		led2     : out std_logic;
		led1     : out std_logic
	
	);
	end component;

	-- Inputs
	file stimulus: text open read_mode is stim_file;
	signal nreset  : std_logic := '1';
	signal osc_in  : std_logic := '0';
	signal usb_txd : std_logic := '1';
	signal button  : std_logic := '1';

	-- Outputs
	signal audio_l  : std_logic := '0';
	signal audio_r  : std_logic := '0';
	signal usb_rxd  : std_logic := '1';
	signal led      : std_logic_vector (3 downto 0) := "0000";

	signal clock    : std_logic := '1';
	signal baud_run : std_logic := '0';
	constant clock_period : time := 31.25 ns;
	constant baud_period  : time := 333 ns; -- 3Mbps
begin

	-- Instantiate the Unit Under Test (UUT)
	uut: Synth_top port map (
		osc_in 	=> clock,
		nreset => nreset,
		usb_tx => usb_rxd,
		usb_rx => usb_txd,
		audio_l => audio_l,
		audio_r => audio_r,
		led1 		=> led(3),
		led2 		=> led(2),
		led3 		=> led(1),
		led4 		=> led(0)
	);

	-- Clock process definitions
	clock_process :process
	begin
		clock <= not clock;
		wait for clock_period/2;
	end process;

  serial_in : process
		variable inline : line;
		variable bv : std_logic_vector(7 downto 0);
	begin
		if baud_run = '1' then
			while not endfile(stimulus) loop
				readline(stimulus, inline);		-- read a line
				for byte in 0 to 3 loop				-- 4 bytes per line
					hread(inline, bv);					-- convert hex byte to vector
					usb_rxd <= '0';							-- start bit
					wait for baud_period;
					for i in 0 to 7 loop				-- bits 0 to 7
						usb_rxd <= bv(i);
						wait for baud_period;
					end loop;
					usb_rxd <= '1';							-- stop bit
					wait for baud_period;
				end loop;
			end loop;
		else
			wait for baud_period;
		end if;
	end process;

	-- Stimulus process
	stim_proc: process
	begin		
		nreset <= '0';
		baud_run <= '0';
		wait for clock_period*10;
		nreset <= '1';
		wait for clock_period*30;
		baud_run <= '1';
		wait;
	end process;

end;
