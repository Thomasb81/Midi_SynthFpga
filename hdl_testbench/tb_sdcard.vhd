-- Adapted from Alex NetSid-papilio project
-- http://code.google.com/p/netsid-papilio/

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use IEEE.std_logic_textio.all;

library std;
	use std.textio.all;

entity testbench_sdcard is
	generic(stim_file: string :="stim.txt");
end testbench_sdcard;

architecture behavior of testbench_sdcard is 

	-- component declaration for the unit under test (uut)

	COMPONENT Synth_top
	PORT(
		osc_in : IN std_logic;
		usb_rx : OUT std_logic;
		usb_tx : IN std_logic;
		audio_r : OUT std_logic;
		audio_l : OUT std_logic;
		led1 : OUT std_logic;
		led2 : OUT std_logic;
		led3 : OUT std_logic;
		led4 : OUT std_logic;
		bp1 : IN std_logic;
		bp2 : IN std_logic;
		bp3 : IN std_logic;
		bp4 : IN std_logic;
		sck : OUT std_logic;
		di : OUT std_logic;
		do : IN std_logic;          
		cs : OUT std_logic
		);
	END COMPONENT;

	component card
          generic (
            card_type_g  : string := "none";
            is_sd_card_g : integer := 1
          );
          port (
            spi_clk_i  : in  std_logic;
            spi_cs_n_i : in  std_logic;
            spi_data_i : in  std_logic;
            spi_data_o : out std_logic
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

        -- SD Card
        signal sck : std_logic;
        signal cs : std_logic;
        signal mosi : std_logic;
        signal miso : std_logic;

begin

	-- Instantiate the Unit Under Test (UUT)

	Synth_top_inst: Synth_top PORT MAP(
		osc_in => clock,
		usb_rx => usb_txd,
		usb_tx => usb_rxd,
		audio_r => audio_l,
		audio_l => audio_r,
		led1 => led(0),
		led2 => led(1),
		led3 => led(2),
		led4 => led(3),
		bp1 => '0',
		bp2 => '0',
		bp3 => '0',
		bp4 => '0',
		sck => sck,
		di => mosi,
		do => miso,
		cs => cs
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
  wait for clock_period*90;
  baud_run <= '1';
  wait;
end process;

card_b : card
  generic map (
    card_type_g  => "MMC Chip",
    is_sd_card_g => 0
  )
  port map (
    spi_clk_i  => sck,
    spi_cs_n_i => cs,
    spi_data_i => mosi,
    spi_data_o => miso
  );


end;
