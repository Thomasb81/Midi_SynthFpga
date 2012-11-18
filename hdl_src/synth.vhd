--neer: Mike Field <hamster@snap.net.nz<
-- 
-- Module Name:    synth - Behavioral 
--
-- Plays a lullaby
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity synth is
    Port ( clk32  : in  STD_LOGIC;
	        rst    : in STD_LOGIC;
			  note_pressed :  in std_logic;
			  note_released : in std_logic;
			  note_keypress : in std_logic;
			  note_channelpress : in std_logic;
			  note_interface : in std_logic_vector (6 downto 0);
			  velocity : in std_logic_vector (6 downto 0);
			  channel : in std_logic_vector (3 downto 0);
           audio_r  : out STD_LOGIC;
			  audio_l  : out STD_LOGIC;
           state : out  STD_LOGIC_VECTOR (2 downto 0);
			  read_back : in std_logic;
			  data : out std_logic_vector (7 downto 0)
			  );
end synth;

architecture Behavioral of synth is

   COMPONENT dac16
   PORT(
      clk     : IN  std_logic;
		rst     : IN  std_logic;
      data    : IN  std_logic_vector(15 downto 0);          
      dac_out : OUT std_logic
      );
   END COMPONENT;

	COMPONENT wavetable_sharer
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		ch0_r_valid_addr : IN std_logic;
		ch0_r_addr : IN std_logic_vector(9 downto 0);
		ch0_l_valid_addr : IN std_logic;
		ch0_l_addr : IN std_logic_vector(9 downto 0);
		ch1_r_valid_addr : IN std_logic;
		ch1_r_addr : IN std_logic_vector(9 downto 0);
		ch1_l_valid_addr : IN std_logic;
		ch1_l_addr : IN std_logic_vector(9 downto 0);
		ch2_r_valid_addr : IN std_logic;
		ch2_r_addr : IN std_logic_vector(9 downto 0);
		ch2_l_valid_addr : IN std_logic;
		ch2_l_addr : IN std_logic_vector(9 downto 0);
		ch3_r_valid_addr : IN std_logic;
		ch3_r_addr : IN std_logic_vector(9 downto 0);
		ch3_l_valid_addr : IN std_logic;
		ch3_l_addr : IN std_logic_vector(9 downto 0);
		ch4_r_valid_addr : IN std_logic;
		ch4_r_addr : IN std_logic_vector(9 downto 0);
		ch4_l_valid_addr : IN std_logic;
		ch4_l_addr : IN std_logic_vector(9 downto 0);
		ch5_r_valid_addr : IN std_logic;
		ch5_r_addr : IN std_logic_vector(9 downto 0);
		ch5_l_valid_addr : IN std_logic;
		ch5_l_addr : IN std_logic_vector(9 downto 0);
		ch6_r_valid_addr : IN std_logic;
		ch6_r_addr : IN std_logic_vector(9 downto 0);
		ch6_l_valid_addr : IN std_logic;
		ch6_l_addr : IN std_logic_vector(9 downto 0);
		ch7_r_valid_addr : IN std_logic;
		ch7_r_addr : IN std_logic_vector(9 downto 0);
		ch7_l_valid_addr : IN std_logic;
		ch7_l_addr : IN std_logic_vector(9 downto 0);
		ch8_r_valid_addr : IN std_logic;
		ch8_r_addr : IN std_logic_vector(9 downto 0);
		ch8_l_valid_addr : IN std_logic;
		ch8_l_addr : IN std_logic_vector(9 downto 0);
		ch9_r_valid_addr : IN std_logic;
		ch9_r_addr : IN std_logic_vector(9 downto 0);
		ch9_l_valid_addr : IN std_logic;
		ch9_l_addr : IN std_logic_vector(9 downto 0);
		ch10_r_valid_addr : IN std_logic;
		ch10_r_addr : IN std_logic_vector(9 downto 0);
		ch10_l_valid_addr : IN std_logic;
		ch10_l_addr : IN std_logic_vector(9 downto 0);
		ch11_r_valid_addr : IN std_logic;
		ch11_r_addr : IN std_logic_vector(9 downto 0);
		ch11_l_valid_addr : IN std_logic;
		ch11_l_addr : IN std_logic_vector(9 downto 0);
		ch12_r_valid_addr : IN std_logic;
		ch12_r_addr : IN std_logic_vector(9 downto 0);
		ch12_l_valid_addr : IN std_logic;
		ch12_l_addr : IN std_logic_vector(9 downto 0);
		ch13_r_valid_addr : IN std_logic;
		ch13_r_addr : IN std_logic_vector(9 downto 0);
		ch13_l_valid_addr : IN std_logic;
		ch13_l_addr : IN std_logic_vector(9 downto 0);
		ch14_r_valid_addr : IN std_logic;
		ch14_r_addr : IN std_logic_vector(9 downto 0);
		ch14_l_valid_addr : IN std_logic;
		ch14_l_addr : IN std_logic_vector(9 downto 0);
		ch15_r_valid_addr : IN std_logic;
		ch15_r_addr : IN std_logic_vector(9 downto 0);
		ch15_l_valid_addr : IN std_logic;
		ch15_l_addr : IN std_logic_vector(9 downto 0);          
		error : OUT std_logic;
		ch0_r_out : OUT std_logic_vector(17 downto 0);
		ch0_l_out : OUT std_logic_vector(17 downto 0);
		ch1_r_out : OUT std_logic_vector(17 downto 0);
		ch1_l_out : OUT std_logic_vector(17 downto 0);
		ch2_r_out : OUT std_logic_vector(17 downto 0);
		ch2_l_out : OUT std_logic_vector(17 downto 0);
		ch3_r_out : OUT std_logic_vector(17 downto 0);
		ch3_l_out : OUT std_logic_vector(17 downto 0);
		ch4_r_out : OUT std_logic_vector(17 downto 0);
		ch4_l_out : OUT std_logic_vector(17 downto 0);
		ch5_r_out : OUT std_logic_vector(17 downto 0);
		ch5_l_out : OUT std_logic_vector(17 downto 0);
		ch6_r_out : OUT std_logic_vector(17 downto 0);
		ch6_l_out : OUT std_logic_vector(17 downto 0);
		ch7_r_out : OUT std_logic_vector(17 downto 0);
		ch7_l_out : OUT std_logic_vector(17 downto 0);
		ch8_r_out : OUT std_logic_vector(17 downto 0);
		ch8_l_out : OUT std_logic_vector(17 downto 0);
		ch9_r_out : OUT std_logic_vector(17 downto 0);
		ch9_l_out : OUT std_logic_vector(17 downto 0);
		ch10_r_out : OUT std_logic_vector(17 downto 0);
		ch10_l_out : OUT std_logic_vector(17 downto 0);
		ch11_r_out : OUT std_logic_vector(17 downto 0);
		ch11_l_out : OUT std_logic_vector(17 downto 0);
		ch12_r_out : OUT std_logic_vector(17 downto 0);
		ch12_l_out : OUT std_logic_vector(17 downto 0);
		ch13_r_out : OUT std_logic_vector(17 downto 0);
		ch13_l_out : OUT std_logic_vector(17 downto 0);
		ch14_r_out : OUT std_logic_vector(17 downto 0);
		ch14_l_out : OUT std_logic_vector(17 downto 0);
		ch15_r_out : OUT std_logic_vector(17 downto 0);
		ch15_l_out : OUT std_logic_vector(17 downto 0)
		);
	END COMPONENT;

	COMPONENT adsr_sharer
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		ch0_r_new_sample : IN std_logic;
		ch0_l_new_sample : IN std_logic;
		ch0_new_note_pulse : IN std_logic;
		ch0_release_note_pulse : IN std_logic;
		ch0_attack_rate : IN std_logic_vector(6 downto 0);
		ch0_decay_rate : IN std_logic_vector(6 downto 0);
		ch0_release_rate : IN std_logic_vector(6 downto 0);
		ch0_sustain_value : IN std_logic_vector(6 downto 0);
		ch0_input_sample_r : IN std_logic_vector(17 downto 0);
		ch0_input_sample_l : IN std_logic_vector(17 downto 0);
		ch1_r_new_sample : IN std_logic;
		ch1_l_new_sample : IN std_logic;
		ch1_new_note_pulse : IN std_logic;
		ch1_release_note_pulse : IN std_logic;
		ch1_attack_rate : IN std_logic_vector(6 downto 0);
		ch1_decay_rate : IN std_logic_vector(6 downto 0);
		ch1_release_rate : IN std_logic_vector(6 downto 0);
		ch1_sustain_value : IN std_logic_vector(6 downto 0);
		ch1_input_sample_r : IN std_logic_vector(17 downto 0);
		ch1_input_sample_l : IN std_logic_vector(17 downto 0);
		ch2_r_new_sample : IN std_logic;
		ch2_l_new_sample : IN std_logic;
		ch2_new_note_pulse : IN std_logic;
		ch2_release_note_pulse : IN std_logic;
		ch2_attack_rate : IN std_logic_vector(6 downto 0);
		ch2_decay_rate : IN std_logic_vector(6 downto 0);
		ch2_release_rate : IN std_logic_vector(6 downto 0);
		ch2_sustain_value : IN std_logic_vector(6 downto 0);
		ch2_input_sample_r : IN std_logic_vector(17 downto 0);
		ch2_input_sample_l : IN std_logic_vector(17 downto 0);
		ch3_r_new_sample : IN std_logic;
		ch3_l_new_sample : IN std_logic;
		ch3_new_note_pulse : IN std_logic;
		ch3_release_note_pulse : IN std_logic;
		ch3_attack_rate : IN std_logic_vector(6 downto 0);
		ch3_decay_rate : IN std_logic_vector(6 downto 0);
		ch3_release_rate : IN std_logic_vector(6 downto 0);
		ch3_sustain_value : IN std_logic_vector(6 downto 0);
		ch3_input_sample_r : IN std_logic_vector(17 downto 0);
		ch3_input_sample_l : IN std_logic_vector(17 downto 0);
		ch4_r_new_sample : IN std_logic;
		ch4_l_new_sample : IN std_logic;
		ch4_new_note_pulse : IN std_logic;
		ch4_release_note_pulse : IN std_logic;
		ch4_attack_rate : IN std_logic_vector(6 downto 0);
		ch4_decay_rate : IN std_logic_vector(6 downto 0);
		ch4_release_rate : IN std_logic_vector(6 downto 0);
		ch4_sustain_value : IN std_logic_vector(6 downto 0);
		ch4_input_sample_r : IN std_logic_vector(17 downto 0);
		ch4_input_sample_l : IN std_logic_vector(17 downto 0);
		ch5_r_new_sample : IN std_logic;
		ch5_l_new_sample : IN std_logic;
		ch5_new_note_pulse : IN std_logic;
		ch5_release_note_pulse : IN std_logic;
		ch5_attack_rate : IN std_logic_vector(6 downto 0);
		ch5_decay_rate : IN std_logic_vector(6 downto 0);
		ch5_release_rate : IN std_logic_vector(6 downto 0);
		ch5_sustain_value : IN std_logic_vector(6 downto 0);
		ch5_input_sample_r : IN std_logic_vector(17 downto 0);
		ch5_input_sample_l : IN std_logic_vector(17 downto 0);
		ch6_r_new_sample : IN std_logic;
		ch6_l_new_sample : IN std_logic;
		ch6_new_note_pulse : IN std_logic;
		ch6_release_note_pulse : IN std_logic;
		ch6_attack_rate : IN std_logic_vector(6 downto 0);
		ch6_decay_rate : IN std_logic_vector(6 downto 0);
		ch6_release_rate : IN std_logic_vector(6 downto 0);
		ch6_sustain_value : IN std_logic_vector(6 downto 0);
		ch6_input_sample_r : IN std_logic_vector(17 downto 0);
		ch6_input_sample_l : IN std_logic_vector(17 downto 0);
		ch7_r_new_sample : IN std_logic;
		ch7_l_new_sample : IN std_logic;
		ch7_new_note_pulse : IN std_logic;
		ch7_release_note_pulse : IN std_logic;
		ch7_attack_rate : IN std_logic_vector(6 downto 0);
		ch7_decay_rate : IN std_logic_vector(6 downto 0);
		ch7_release_rate : IN std_logic_vector(6 downto 0);
		ch7_sustain_value : IN std_logic_vector(6 downto 0);
		ch7_input_sample_r : IN std_logic_vector(17 downto 0);
		ch7_input_sample_l : IN std_logic_vector(17 downto 0);
		ch8_r_new_sample : IN std_logic;
		ch8_l_new_sample : IN std_logic;
		ch8_new_note_pulse : IN std_logic;
		ch8_release_note_pulse : IN std_logic;
		ch8_attack_rate : IN std_logic_vector(6 downto 0);
		ch8_decay_rate : IN std_logic_vector(6 downto 0);
		ch8_release_rate : IN std_logic_vector(6 downto 0);
		ch8_sustain_value : IN std_logic_vector(6 downto 0);
		ch8_input_sample_r : IN std_logic_vector(17 downto 0);
		ch8_input_sample_l : IN std_logic_vector(17 downto 0);
		ch9_r_new_sample : IN std_logic;
		ch9_l_new_sample : IN std_logic;
		ch9_new_note_pulse : IN std_logic;
		ch9_release_note_pulse : IN std_logic;
		ch9_attack_rate : IN std_logic_vector(6 downto 0);
		ch9_decay_rate : IN std_logic_vector(6 downto 0);
		ch9_release_rate : IN std_logic_vector(6 downto 0);
		ch9_sustain_value : IN std_logic_vector(6 downto 0);
		ch9_input_sample_r : IN std_logic_vector(17 downto 0);
		ch9_input_sample_l : IN std_logic_vector(17 downto 0);
		ch10_r_new_sample : IN std_logic;
		ch10_l_new_sample : IN std_logic;
		ch10_new_note_pulse : IN std_logic;
		ch10_release_note_pulse : IN std_logic;
		ch10_attack_rate : IN std_logic_vector(6 downto 0);
		ch10_decay_rate : IN std_logic_vector(6 downto 0);
		ch10_release_rate : IN std_logic_vector(6 downto 0);
		ch10_sustain_value : IN std_logic_vector(6 downto 0);
		ch10_input_sample_r : IN std_logic_vector(17 downto 0);
		ch10_input_sample_l : IN std_logic_vector(17 downto 0);
		ch11_r_new_sample : IN std_logic;
		ch11_l_new_sample : IN std_logic;
		ch11_new_note_pulse : IN std_logic;
		ch11_release_note_pulse : IN std_logic;
		ch11_attack_rate : IN std_logic_vector(6 downto 0);
		ch11_decay_rate : IN std_logic_vector(6 downto 0);
		ch11_release_rate : IN std_logic_vector(6 downto 0);
		ch11_sustain_value : IN std_logic_vector(6 downto 0);
		ch11_input_sample_r : IN std_logic_vector(17 downto 0);
		ch11_input_sample_l : IN std_logic_vector(17 downto 0);
		ch12_r_new_sample : IN std_logic;
		ch12_l_new_sample : IN std_logic;
		ch12_new_note_pulse : IN std_logic;
		ch12_release_note_pulse : IN std_logic;
		ch12_attack_rate : IN std_logic_vector(6 downto 0);
		ch12_decay_rate : IN std_logic_vector(6 downto 0);
		ch12_release_rate : IN std_logic_vector(6 downto 0);
		ch12_sustain_value : IN std_logic_vector(6 downto 0);
		ch12_input_sample_r : IN std_logic_vector(17 downto 0);
		ch12_input_sample_l : IN std_logic_vector(17 downto 0);
		ch13_r_new_sample : IN std_logic;
		ch13_l_new_sample : IN std_logic;
		ch13_new_note_pulse : IN std_logic;
		ch13_release_note_pulse : IN std_logic;
		ch13_attack_rate : IN std_logic_vector(6 downto 0);
		ch13_decay_rate : IN std_logic_vector(6 downto 0);
		ch13_release_rate : IN std_logic_vector(6 downto 0);
		ch13_sustain_value : IN std_logic_vector(6 downto 0);
		ch13_input_sample_r : IN std_logic_vector(17 downto 0);
		ch13_input_sample_l : IN std_logic_vector(17 downto 0);
		ch14_r_new_sample : IN std_logic;
		ch14_l_new_sample : IN std_logic;
		ch14_new_note_pulse : IN std_logic;
		ch14_release_note_pulse : IN std_logic;
		ch14_attack_rate : IN std_logic_vector(6 downto 0);
		ch14_decay_rate : IN std_logic_vector(6 downto 0);
		ch14_release_rate : IN std_logic_vector(6 downto 0);
		ch14_sustain_value : IN std_logic_vector(6 downto 0);
		ch14_input_sample_r : IN std_logic_vector(17 downto 0);
		ch14_input_sample_l : IN std_logic_vector(17 downto 0);
		ch15_r_new_sample : IN std_logic;
		ch15_l_new_sample : IN std_logic;
		ch15_new_note_pulse : IN std_logic;
		ch15_release_note_pulse : IN std_logic;
		ch15_attack_rate : IN std_logic_vector(6 downto 0);
		ch15_decay_rate : IN std_logic_vector(6 downto 0);
		ch15_release_rate : IN std_logic_vector(6 downto 0);
		ch15_sustain_value : IN std_logic_vector(6 downto 0);
		ch15_input_sample_r : IN std_logic_vector(17 downto 0);
		ch15_input_sample_l : IN std_logic_vector(17 downto 0);          
		error : OUT std_logic;
		ch0_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch0_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch0_state : OUT std_logic_vector(4 downto 0);
		ch1_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch1_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch1_state : OUT std_logic_vector(4 downto 0);
		ch2_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch2_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch2_state : OUT std_logic_vector(4 downto 0);
		ch3_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch3_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch3_state : OUT std_logic_vector(4 downto 0);
		ch4_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch4_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch4_state : OUT std_logic_vector(4 downto 0);
		ch5_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch5_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch5_state : OUT std_logic_vector(4 downto 0);
		ch6_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch6_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch6_state : OUT std_logic_vector(4 downto 0);
		ch7_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch7_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch7_state : OUT std_logic_vector(4 downto 0);
		ch8_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch8_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch8_state : OUT std_logic_vector(4 downto 0);
		ch9_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch9_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch9_state : OUT std_logic_vector(4 downto 0);
		ch10_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch10_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch10_state : OUT std_logic_vector(4 downto 0);
		ch11_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch11_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch11_state : OUT std_logic_vector(4 downto 0);
		ch12_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch12_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch12_state : OUT std_logic_vector(4 downto 0);
		ch13_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch13_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch13_state : OUT std_logic_vector(4 downto 0);
		ch14_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch14_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch14_state : OUT std_logic_vector(4 downto 0);
		ch15_output_sample_r : OUT std_logic_vector(17 downto 0);
		ch15_output_sample_l : OUT std_logic_vector(17 downto 0);
		ch15_state : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;

	COMPONENT freqtable_sharer
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		valid_addr_ch0 : IN std_logic;
		addr_ch0 : IN std_logic_vector(9 downto 0);
		valid_addr_ch1 : IN std_logic;
		addr_ch1 : IN std_logic_vector(9 downto 0);
		valid_addr_ch2 : IN std_logic;
		addr_ch2 : IN std_logic_vector(9 downto 0);
		valid_addr_ch3 : IN std_logic;
		addr_ch3 : IN std_logic_vector(9 downto 0);
		valid_addr_ch4 : IN std_logic;
		addr_ch4 : IN std_logic_vector(9 downto 0);
		valid_addr_ch5 : IN std_logic;
		addr_ch5 : IN std_logic_vector(9 downto 0);
		valid_addr_ch6 : IN std_logic;
		addr_ch6 : IN std_logic_vector(9 downto 0);
		valid_addr_ch7 : IN std_logic;
		addr_ch7 : IN std_logic_vector(9 downto 0);
		valid_addr_ch8 : IN std_logic;
		addr_ch8 : IN std_logic_vector(9 downto 0);
		valid_addr_ch9 : IN std_logic;
		addr_ch9 : IN std_logic_vector(9 downto 0);
		valid_addr_ch10 : IN std_logic;
		addr_ch10 : IN std_logic_vector(9 downto 0);
		valid_addr_ch11 : IN std_logic;
		addr_ch11 : IN std_logic_vector(9 downto 0);
		valid_addr_ch12 : IN std_logic;
		addr_ch12 : IN std_logic_vector(9 downto 0);
		valid_addr_ch13 : IN std_logic;
		addr_ch13 : IN std_logic_vector(9 downto 0);
		valid_addr_ch14 : IN std_logic;
		addr_ch14 : IN std_logic_vector(9 downto 0);
		valid_addr_ch15 : IN std_logic;
		addr_ch15 : IN std_logic_vector(9 downto 0);          
		error : OUT std_logic;
		ch0_out : OUT std_logic_vector(17 downto 0);
		ch1_out : OUT std_logic_vector(17 downto 0);
		ch2_out : OUT std_logic_vector(17 downto 0);
		ch3_out : OUT std_logic_vector(17 downto 0);
		ch4_out : OUT std_logic_vector(17 downto 0);
		ch5_out : OUT std_logic_vector(17 downto 0);
		ch6_out : OUT std_logic_vector(17 downto 0);
		ch7_out : OUT std_logic_vector(17 downto 0);
		ch8_out : OUT std_logic_vector(17 downto 0);
		ch9_out : OUT std_logic_vector(17 downto 0);
		ch10_out : OUT std_logic_vector(17 downto 0);
		ch11_out : OUT std_logic_vector(17 downto 0);
		ch12_out : OUT std_logic_vector(17 downto 0);
		ch13_out : OUT std_logic_vector(17 downto 0);
		ch14_out : OUT std_logic_vector(17 downto 0);
		ch15_out : OUT std_logic_vector(17 downto 0)
		);
	END COMPONENT;



	COMPONENT event_48k_gene
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;          
		events : OUT std_logic_vector(36 downto 0)
		);
	END COMPONENT;

	COMPONENT stereo_channel_mixer
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		calcul_en : IN std_logic;
		ch0_r_sound : IN std_logic_vector(17 downto 0);
		ch1_r_sound : IN std_logic_vector(17 downto 0);
		ch2_r_sound : IN std_logic_vector(17 downto 0);
		ch3_r_sound : IN std_logic_vector(17 downto 0);
		ch4_r_sound : IN std_logic_vector(17 downto 0);
		ch5_r_sound : IN std_logic_vector(17 downto 0);
		ch6_r_sound : IN std_logic_vector(17 downto 0);
		ch7_r_sound : IN std_logic_vector(17 downto 0);
		ch8_r_sound : IN std_logic_vector(17 downto 0);
		ch9_r_sound : IN std_logic_vector(17 downto 0);
		ch10_r_sound : IN std_logic_vector(17 downto 0);
		ch11_r_sound : IN std_logic_vector(17 downto 0);
		ch12_r_sound : IN std_logic_vector(17 downto 0);
		ch13_r_sound : IN std_logic_vector(17 downto 0);
		ch14_r_sound : IN std_logic_vector(17 downto 0);
		ch15_r_sound : IN std_logic_vector(17 downto 0);
		ch0_l_sound : IN std_logic_vector(17 downto 0);
		ch1_l_sound : IN std_logic_vector(17 downto 0);
		ch2_l_sound : IN std_logic_vector(17 downto 0);
		ch3_l_sound : IN std_logic_vector(17 downto 0);
		ch4_l_sound : IN std_logic_vector(17 downto 0);
		ch5_l_sound : IN std_logic_vector(17 downto 0);
		ch6_l_sound : IN std_logic_vector(17 downto 0);
		ch7_l_sound : IN std_logic_vector(17 downto 0);
		ch8_l_sound : IN std_logic_vector(17 downto 0);
		ch9_l_sound : IN std_logic_vector(17 downto 0);
		ch10_l_sound : IN std_logic_vector(17 downto 0);
		ch11_l_sound : IN std_logic_vector(17 downto 0);
		ch12_l_sound : IN std_logic_vector(17 downto 0);
		ch13_l_sound : IN std_logic_vector(17 downto 0);
		ch14_l_sound : IN std_logic_vector(17 downto 0);
		ch15_l_sound : IN std_logic_vector(17 downto 0);          
		data_out_right : OUT std_logic_vector(17 downto 0);
		data_out_left : OUT std_logic_vector(17 downto 0)
		);
	END COMPONENT;


   --signal wave_totals   : unsigned (18 downto 0) := (others => '0');
	
   signal ch0_wave_totals   : unsigned (19 downto 0);
   signal ch0_wave_advance  : std_logic_vector(17 downto 0);
   signal ch0_note : std_logic_vector(6 downto 0);
   signal ch0_velocity : std_logic_vector(6 downto 0);
   signal ch0_sustain : std_logic_vector(6 downto 0);
   signal ch0_note_pressed :  std_logic;
   signal ch0_note_released : std_logic;
   signal ch0_current_note  : std_logic_vector(9 downto 0);
   signal ch0_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch0_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch0_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch0_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch0_sound_r         : std_logic_vector(17 downto 0);
   signal ch0_sound_l         : std_logic_vector(17 downto 0);
   signal ch0_adsr_state : std_logic_vector(4 downto 0);

   signal ch1_wave_totals   : unsigned (19 downto 0);
   signal ch1_wave_advance  : std_logic_vector(17 downto 0);
   signal ch1_note : std_logic_vector(6 downto 0);
   signal ch1_velocity : std_logic_vector(6 downto 0);
   signal ch1_sustain : std_logic_vector(6 downto 0);
   signal ch1_note_pressed : std_logic;
   signal ch1_note_released : std_logic;
   signal ch1_current_note  : std_logic_vector(9 downto 0);
   signal ch1_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch1_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch1_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch1_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch1_sound_r         : std_logic_vector(17 downto 0);
   signal ch1_sound_l         : std_logic_vector(17 downto 0);
   signal ch1_adsr_state : std_logic_vector(4 downto 0);

   signal ch2_wave_totals   : unsigned (19 downto 0);
   signal ch2_wave_advance  : std_logic_vector(17 downto 0);
   signal ch2_note : std_logic_vector(6 downto 0);
   signal ch2_velocity : std_logic_vector(6 downto 0);
   signal ch2_sustain : std_logic_vector(6 downto 0);
   signal ch2_note_pressed : std_logic;
   signal ch2_note_released : std_logic;
   signal ch2_current_note  : std_logic_vector(9 downto 0);
   signal ch2_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch2_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch2_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch2_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch2_sound_r         : std_logic_vector(17 downto 0);
   signal ch2_sound_l         : std_logic_vector(17 downto 0);
   signal ch2_adsr_state : std_logic_vector(4 downto 0);

   signal ch3_wave_totals   : unsigned (19 downto 0);
   signal ch3_wave_advance  : std_logic_vector(17 downto 0);
   signal ch3_note : std_logic_vector(6 downto 0);
   signal ch3_velocity : std_logic_vector(6 downto 0);
   signal ch3_sustain : std_logic_vector(6 downto 0);
   signal ch3_note_pressed : std_logic;
   signal ch3_note_released : std_logic;
   signal ch3_current_note  : std_logic_vector(9 downto 0);
   signal ch3_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch3_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch3_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch3_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch3_sound_r         : std_logic_vector(17 downto 0);
   signal ch3_sound_l         : std_logic_vector(17 downto 0);
   signal ch3_adsr_state : std_logic_vector(4 downto 0);

   signal ch4_wave_totals   : unsigned (19 downto 0);
   signal ch4_wave_advance  : std_logic_vector(17 downto 0);
   signal ch4_note : std_logic_vector(6 downto 0);
   signal ch4_velocity : std_logic_vector(6 downto 0);
   signal ch4_sustain : std_logic_vector(6 downto 0);
   signal ch4_note_pressed :  std_logic;
   signal ch4_note_released : std_logic;
   signal ch4_current_note  : std_logic_vector(9 downto 0);
   signal ch4_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch4_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch4_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch4_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch4_sound_r         : std_logic_vector(17 downto 0);
   signal ch4_sound_l         : std_logic_vector(17 downto 0);
   signal ch4_adsr_state : std_logic_vector(4 downto 0);

   signal ch5_wave_totals   : unsigned (19 downto 0);
   signal ch5_wave_advance  : std_logic_vector(17 downto 0);
   signal ch5_note : std_logic_vector(6 downto 0);
   signal ch5_velocity : std_logic_vector(6 downto 0);
   signal ch5_sustain : std_logic_vector(6 downto 0);
   signal ch5_note_pressed : std_logic;
   signal ch5_note_released : std_logic;
   signal ch5_current_note  : std_logic_vector(9 downto 0);
   signal ch5_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch5_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch5_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch5_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch5_sound_r         : std_logic_vector(17 downto 0);
   signal ch5_sound_l         : std_logic_vector(17 downto 0);
   signal ch5_adsr_state : std_logic_vector(4 downto 0);

   signal ch6_wave_totals   : unsigned (19 downto 0);
   signal ch6_wave_advance  : std_logic_vector(17 downto 0);
   signal ch6_note : std_logic_vector(6 downto 0);
   signal ch6_velocity : std_logic_vector(6 downto 0);
   signal ch6_sustain : std_logic_vector(6 downto 0);
   signal ch6_note_pressed : std_logic;
   signal ch6_note_released : std_logic;
   signal ch6_current_note  : std_logic_vector(9 downto 0);
   signal ch6_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch6_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch6_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch6_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch6_sound_r         : std_logic_vector(17 downto 0);
   signal ch6_sound_l         : std_logic_vector(17 downto 0);
   signal ch6_adsr_state : std_logic_vector(4 downto 0);

   signal ch7_wave_totals   : unsigned (19 downto 0);
   signal ch7_wave_advance  : std_logic_vector(17 downto 0);
   signal ch7_note : std_logic_vector(6 downto 0);
   signal ch7_velocity : std_logic_vector(6 downto 0);
   signal ch7_sustain : std_logic_vector(6 downto 0);
   signal ch7_note_pressed : std_logic;
   signal ch7_note_released : std_logic;
   signal ch7_current_note  : std_logic_vector(9 downto 0);
   signal ch7_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch7_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch7_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch7_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch7_sound_r         : std_logic_vector(17 downto 0);
   signal ch7_sound_l         : std_logic_vector(17 downto 0);
   signal ch7_adsr_state : std_logic_vector(4 downto 0);

   signal ch8_wave_totals   : unsigned (19 downto 0);
   signal ch8_wave_advance  : std_logic_vector(17 downto 0);
   signal ch8_note : std_logic_vector(6 downto 0);
   signal ch8_velocity : std_logic_vector(6 downto 0);
   signal ch8_sustain : std_logic_vector(6 downto 0);
   signal ch8_note_pressed :  std_logic;
   signal ch8_note_released : std_logic;
   signal ch8_current_note  : std_logic_vector(9 downto 0);
   signal ch8_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch8_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch8_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch8_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch8_sound_r         : std_logic_vector(17 downto 0);
   signal ch8_sound_l         : std_logic_vector(17 downto 0);
   signal ch8_adsr_state : std_logic_vector(4 downto 0);

   signal ch9_wave_totals   : unsigned (19 downto 0);
   signal ch9_wave_advance  : std_logic_vector(17 downto 0);
   signal ch9_note : std_logic_vector(6 downto 0);
   signal ch9_velocity : std_logic_vector(6 downto 0);
   signal ch9_sustain : std_logic_vector(6 downto 0);
   signal ch9_note_pressed : std_logic;
   signal ch9_note_released : std_logic;
   signal ch9_current_note  : std_logic_vector(9 downto 0);
   signal ch9_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch9_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch9_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch9_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch9_sound_r         : std_logic_vector(17 downto 0);
   signal ch9_sound_l         : std_logic_vector(17 downto 0);
   signal ch9_adsr_state : std_logic_vector(4 downto 0);

   signal ch10_wave_totals   : unsigned (19 downto 0);
   signal ch10_wave_advance  : std_logic_vector(17 downto 0);
   signal ch10_note : std_logic_vector(6 downto 0);
   signal ch10_velocity : std_logic_vector(6 downto 0);
   signal ch10_sustain : std_logic_vector(6 downto 0);
   signal ch10_note_pressed : std_logic;
   signal ch10_note_released : std_logic;
   signal ch10_current_note  : std_logic_vector(9 downto 0);
   signal ch10_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch10_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch10_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch10_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch10_sound_r         : std_logic_vector(17 downto 0);
   signal ch10_sound_l         : std_logic_vector(17 downto 0);
   signal ch10_adsr_state : std_logic_vector(4 downto 0);

   signal ch11_wave_totals   : unsigned (19 downto 0);
   signal ch11_wave_advance  : std_logic_vector(17 downto 0);
   signal ch11_note : std_logic_vector(6 downto 0);
   signal ch11_velocity : std_logic_vector(6 downto 0);
   signal ch11_sustain : std_logic_vector(6 downto 0);
   signal ch11_note_pressed : std_logic;
   signal ch11_note_released : std_logic;
   signal ch11_current_note  : std_logic_vector(9 downto 0);
   signal ch11_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch11_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch11_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch11_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch11_sound_r         : std_logic_vector(17 downto 0);
   signal ch11_sound_l         : std_logic_vector(17 downto 0);
   signal ch11_adsr_state : std_logic_vector(4 downto 0);

   signal ch12_wave_totals   : unsigned (19 downto 0);
   signal ch12_wave_advance  : std_logic_vector(17 downto 0);
   signal ch12_note : std_logic_vector(6 downto 0);
   signal ch12_velocity : std_logic_vector(6 downto 0);
   signal ch12_sustain : std_logic_vector(6 downto 0);
   signal ch12_note_pressed :  std_logic;
   signal ch12_note_released : std_logic;
   signal ch12_current_note  : std_logic_vector(9 downto 0);
   signal ch12_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch12_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch12_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch12_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch12_sound_r         : std_logic_vector(17 downto 0);
   signal ch12_sound_l         : std_logic_vector(17 downto 0);
   signal ch12_adsr_state : std_logic_vector(4 downto 0);

   signal ch13_wave_totals   : unsigned (19 downto 0);
   signal ch13_wave_advance  : std_logic_vector(17 downto 0);
   signal ch13_note : std_logic_vector(6 downto 0);
   signal ch13_velocity : std_logic_vector(6 downto 0);
   signal ch13_sustain : std_logic_vector(6 downto 0);
   signal ch13_note_pressed : std_logic;
   signal ch13_note_released : std_logic;
   signal ch13_current_note  : std_logic_vector(9 downto 0);
   signal ch13_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch13_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch13_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch13_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch13_sound_r         : std_logic_vector(17 downto 0);
   signal ch13_sound_l         : std_logic_vector(17 downto 0);
   signal ch13_adsr_state : std_logic_vector(4 downto 0);

   signal ch14_wave_totals   : unsigned (19 downto 0);
   signal ch14_wave_advance  : std_logic_vector(17 downto 0);
   signal ch14_note : std_logic_vector(6 downto 0);
   signal ch14_velocity : std_logic_vector(6 downto 0);
   signal ch14_sustain : std_logic_vector(6 downto 0);
   signal ch14_note_pressed : std_logic;
   signal ch14_note_released : std_logic;
   signal ch14_current_note  : std_logic_vector(9 downto 0);
   signal ch14_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch14_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch14_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch14_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch14_sound_r         : std_logic_vector(17 downto 0);
   signal ch14_sound_l         : std_logic_vector(17 downto 0);
   signal ch14_adsr_state : std_logic_vector(4 downto 0);

   signal ch15_wave_totals   : unsigned (19 downto 0);
   signal ch15_wave_advance  : std_logic_vector(17 downto 0);
   signal ch15_note : std_logic_vector(6 downto 0);
   signal ch15_velocity : std_logic_vector(6 downto 0);
   signal ch15_sustain : std_logic_vector(6 downto 0);
   signal ch15_note_pressed : std_logic;
   signal ch15_note_released : std_logic;
   signal ch15_current_note  : std_logic_vector(9 downto 0);
   signal ch15_waves_addr_r    : std_logic_vector(9 downto 0);
   signal ch15_waves_addr_l    : std_logic_vector(9 downto 0);
   signal ch15_waves_out_r   : std_logic_vector(17 downto 0);
   signal ch15_waves_out_l   : std_logic_vector(17 downto 0);
   signal ch15_sound_r         : std_logic_vector(17 downto 0);
   signal ch15_sound_l         : std_logic_vector(17 downto 0);
   signal ch15_adsr_state : std_logic_vector(4 downto 0);



   signal dac_input_r   : std_logic_vector(15 downto 0);
   signal dac_input_l   : std_logic_vector(15 downto 0);

   signal dac_input_r_tmp : std_logic_vector (17 downto 0);
   signal dac_input_l_tmp : std_logic_vector (17 downto 0);


   signal decay_rate    : std_logic_vector( 6 downto 0) := "0100000";   
   signal release_rate  : std_logic_vector( 6 downto 0);
  

   signal events : std_logic_vector (36 downto 0);	

   signal ch17 : std_logic; -- dummy



   
	
	   begin

process(clk32) begin
if rising_edge(clk32) then
  if read_back = '1' then
     case(velocity) is
	    when "0000000" => data <= ch0_sound_r( 17 downto 10);
	    when "0000001" => data <= ch0_sound_r( 9 downto 2);
	    when "0000010" => data <= ch1_sound_r( 17 downto 10);
	    when "0000011" => data <= ch1_sound_r( 9 downto 2);
	    when "0000100" => data <= ch2_sound_r( 17 downto 10);
	    when "0000101" => data <= ch2_sound_r( 9 downto 2);
	    when "0000110" => data <= ch3_sound_r( 17 downto 10);
	    when "0000111" => data <= ch3_sound_r( 9 downto 2);
	    when "0001000" => data <= ch4_sound_r( 17 downto 10);
	    when "0001001" => data <= ch4_sound_r( 9 downto 2);
	    when "0001010" => data <= ch5_sound_r( 17 downto 10);
	    when "0001011" => data <= ch5_sound_r( 9 downto 2);
	    when "0001100" => data <= ch6_sound_r( 17 downto 10);
	    when "0001101" => data <= ch6_sound_r( 9 downto 2);
	    when "0001110" => data <= ch7_sound_r( 17 downto 10);
	    when "0001111" => data <= ch7_sound_r( 9 downto 2);
	    when "0010000" => data <= ch8_sound_r( 17 downto 10);
	    when "0010001" => data <= ch8_sound_r( 9 downto 2);
	    when "0010010" => data <= ch9_sound_r( 17 downto 10);
	    when "0010011" => data <= ch9_sound_r( 9 downto 2);
	    when "0010100" => data <= ch10_sound_r( 17 downto 10);
	    when "0010101" => data <= ch10_sound_r( 9 downto 2);
	    when "0010110" => data <= ch11_sound_r( 17 downto 10);
	    when "0010111" => data <= ch11_sound_r( 9 downto 2);
	    when "0011000" => data <= ch12_sound_r( 17 downto 10);
	    when "0011001" => data <= ch12_sound_r( 9 downto 2);
	    when "0011010" => data <= ch13_sound_r( 17 downto 10);
	    when "0011011" => data <= ch13_sound_r( 9 downto 2);
	    when "0011100" => data <= ch14_sound_r( 17 downto 10);
	    when "0011101" => data <= ch14_sound_r( 9 downto 2);
	    when "0011110" => data <= ch15_sound_r( 17 downto 10);
	    when "0011111" => data <= ch15_sound_r( 9 downto 2);
		 
            when "0100000" => data <= "000" & ch0_adsr_state;
	    when "0100001" => data <= "000" & ch1_adsr_state;
            when "0100010" => data <= "000" & ch2_adsr_state;
	    when "0100011" => data <= "000" & ch3_adsr_state;
            when "0100100" => data <= "000" & ch4_adsr_state;
	    when "0100101" => data <= "000" & ch5_adsr_state;
            when "0100110" => data <= "000" & ch6_adsr_state;
	    when "0100111" => data <= "000" & ch7_adsr_state;
            when "0101000" => data <= "000" & ch8_adsr_state;
	    when "0101001" => data <= "000" & ch9_adsr_state;
            when "0101010" => data <= "000" & ch10_adsr_state;
	    when "0101011" => data <= "000" & ch11_adsr_state;
            when "0101100" => data <= "000" & ch12_adsr_state;
	    when "0101101" => data <= "000" & ch13_adsr_state;
            when "0101110" => data <= "000" & ch14_adsr_state;
	    when "0101111" => data <= "000" & ch15_adsr_state;
		 
	    when others => data <= "10101010";
	  end case;
  end if;
end if;
end process;


																  
	   ch0_waves_addr_r <= "0" & std_logic_vector(ch0_wave_totals(18 downto 10)); 
	   ch0_waves_addr_l <= std_logic_vector(unsigned(ch0_waves_addr_r)+256);

	   ch1_waves_addr_r <= "0" & std_logic_vector(ch1_wave_totals(18 downto 10)); 
	   ch1_waves_addr_l <= std_logic_vector(unsigned(ch1_waves_addr_r)+256);

	   ch2_waves_addr_r <= "0" & std_logic_vector(ch2_wave_totals(18 downto 10)); 
	   ch2_waves_addr_l <= std_logic_vector(unsigned(ch2_waves_addr_r)+256);	

	   ch3_waves_addr_r <= "0" & std_logic_vector(ch3_wave_totals(18 downto 10)); 
	   ch3_waves_addr_l <= std_logic_vector(unsigned(ch3_waves_addr_r)+256);

	   ch4_waves_addr_r <= "0" & std_logic_vector(ch4_wave_totals(18 downto 10)); 
	   ch4_waves_addr_l <= std_logic_vector(unsigned(ch4_waves_addr_r)+256);

	   ch5_waves_addr_r <= "0" & std_logic_vector(ch5_wave_totals(18 downto 10)); 
	   ch5_waves_addr_l <= std_logic_vector(unsigned(ch5_waves_addr_r)+256);

	   ch6_waves_addr_r <= "0" & std_logic_vector(ch6_wave_totals(18 downto 10)); 
	   ch6_waves_addr_l <= std_logic_vector(unsigned(ch6_waves_addr_r)+256);	

	   ch7_waves_addr_r <= "0" & std_logic_vector(ch7_wave_totals(18 downto 10)); 
	   ch7_waves_addr_l <= std_logic_vector(unsigned(ch7_waves_addr_r)+256);

	   ch8_waves_addr_r <= "0" & std_logic_vector(ch8_wave_totals(18 downto 10)); 
	   ch8_waves_addr_l <= std_logic_vector(unsigned(ch8_waves_addr_r)+256);

	   ch9_waves_addr_r <= "0" & std_logic_vector(ch9_wave_totals(18 downto 10)); 
	   ch9_waves_addr_l <= std_logic_vector(unsigned(ch9_waves_addr_r)+256);

	   ch10_waves_addr_r <= "0" & std_logic_vector(ch10_wave_totals(18 downto 10)); 
	   ch10_waves_addr_l <= std_logic_vector(unsigned(ch10_waves_addr_r)+256);	

	   ch11_waves_addr_r <= "0" & std_logic_vector(ch11_wave_totals(18 downto 10)); 
	   ch11_waves_addr_l <= std_logic_vector(unsigned(ch11_waves_addr_r)+256);

	   ch12_waves_addr_r <= "0" & std_logic_vector(ch12_wave_totals(18 downto 10)); 
	   ch12_waves_addr_l <= std_logic_vector(unsigned(ch12_waves_addr_r)+256);

	   ch13_waves_addr_r <= "0" & std_logic_vector(ch13_wave_totals(18 downto 10)); 
	   ch13_waves_addr_l <= std_logic_vector(unsigned(ch13_waves_addr_r)+256);

	   ch14_waves_addr_r <= "0" & std_logic_vector(ch14_wave_totals(18 downto 10)); 
	   ch14_waves_addr_l <= std_logic_vector(unsigned(ch14_waves_addr_r)+256);	

	   ch15_waves_addr_r <= "0" & std_logic_vector(ch15_wave_totals(18 downto 10)); 
	   ch15_waves_addr_l <= std_logic_vector(unsigned(ch15_waves_addr_r)+256);


	   -- dac_input_r    <= ch0_sound_r(17 downto 2);
	   --dac_input_r    <= dac_input_tmp(17 downto 2);
	   --dac_input_l    <= ch0_sound_l(17 downto 2);
	   --dac_input_l    <= ch0_sound_r(17 downto 2);

dac_input_r    <= dac_input_r_tmp(17 downto 2);
dac_input_l    <= dac_input_l_tmp(17 downto 2);

Inst_stereo_channel_mixer: stereo_channel_mixer 
PORT MAP(
		clk => CLK32,
		rst => rst,
		calcul_en => events(8),

		ch0_r_sound => ch0_sound_r,
		ch1_r_sound => ch1_sound_r,
		ch2_r_sound => ch2_sound_r,
		ch3_r_sound => ch3_sound_r,
		ch4_r_sound => ch4_sound_r,
		ch5_r_sound => ch5_sound_r,
		ch6_r_sound => ch6_sound_r,
		ch7_r_sound => ch7_sound_r,
		ch8_r_sound => ch8_sound_r,
		ch9_r_sound => ch9_sound_r,
		ch10_r_sound => ch10_sound_r,
		ch11_r_sound => ch11_sound_r,
		ch12_r_sound => ch12_sound_r,
		ch13_r_sound => ch13_sound_r,
		ch14_r_sound => ch14_sound_r,
		ch15_r_sound => ch15_sound_r,
		ch0_l_sound => ch0_sound_l,
		ch1_l_sound => ch1_sound_l,
		ch2_l_sound => ch2_sound_l,
		ch3_l_sound => ch3_sound_l,
		ch4_l_sound => ch4_sound_l,
		ch5_l_sound => ch5_sound_l,
		ch6_l_sound => ch6_sound_l,
		ch7_l_sound => ch7_sound_l,
		ch8_l_sound => ch8_sound_l,
		ch9_l_sound => ch9_sound_l,
		ch10_l_sound => ch10_sound_l,
		ch11_l_sound => ch11_sound_l,
		ch12_l_sound => ch12_sound_l,
		ch13_l_sound => ch13_sound_l,
		ch14_l_sound => ch14_sound_l,
		ch15_l_sound => ch15_sound_l,
		data_out_right => dac_input_r_tmp,
		data_out_left => dac_input_l_tmp

	);


                   
inst_dac16_r: dac16 PORT MAP(
      clk => clk32,
		rst => rst,
      data => dac_input_r,
      dac_out => audio_r
   );
inst_dac16_l: dac16 PORT MAP(
      clk => clk32,
		rst =>rst,
      data => dac_input_l,
      dac_out => audio_l
   );
  
waves: wavetable_sharer PORT MAP(
		clk => CLK32,
		rst => rst,
		error => open,
		ch0_r_valid_addr => events(0),
		ch0_r_addr => ch0_waves_addr_r,
		ch0_r_out => ch0_waves_out_r,
		ch0_l_valid_addr => events(1),
		ch0_l_addr => ch0_waves_addr_l,
		ch0_l_out => ch0_waves_out_l,
		ch1_r_valid_addr => events(2),
		ch1_r_addr => ch1_waves_addr_r ,
		ch1_r_out => ch1_waves_out_r,
		ch1_l_valid_addr => events(3),
		ch1_l_addr =>ch1_waves_addr_l,
		ch1_l_out => ch1_waves_out_l,
		ch2_r_valid_addr => events(4),
		ch2_r_addr => ch2_waves_addr_r,
		ch2_r_out => ch2_waves_out_r,
		ch2_l_valid_addr =>events(5),
		ch2_l_addr => ch2_waves_addr_l,
		ch2_l_out =>ch2_waves_out_l ,
		ch3_r_valid_addr => events(6),
		ch3_r_addr => ch3_waves_addr_r,
		ch3_r_out => ch3_waves_out_r,
		ch3_l_valid_addr =>events(7),
		ch3_l_addr => ch3_waves_addr_l,
		ch3_l_out => ch3_waves_out_l,
		
		ch4_r_valid_addr => events(8),
		ch4_r_addr => ch4_waves_addr_r,
		ch4_r_out => ch4_waves_out_r,
		ch4_l_valid_addr => events(9),
		ch4_l_addr => ch4_waves_addr_l,
		ch4_l_out => ch4_waves_out_l,
		ch5_r_valid_addr => events(10),
		ch5_r_addr => ch5_waves_addr_r,
		ch5_r_out => ch5_waves_out_r,
		ch5_l_valid_addr => events(11),
		ch5_l_addr => ch5_waves_addr_l,
		ch5_l_out => ch5_waves_out_l,
		ch6_r_valid_addr => events(12),
		ch6_r_addr => ch6_waves_addr_r,
		ch6_r_out => ch6_waves_out_r,
		ch6_l_valid_addr => events(13),
		ch6_l_addr => ch6_waves_addr_l,
		ch6_l_out => ch6_waves_out_l,
		ch7_r_valid_addr => events(14),
		ch7_r_addr => ch7_waves_addr_r,
		ch7_r_out => ch7_waves_out_r,
		ch7_l_valid_addr => events(15),
		ch7_l_addr => ch7_waves_addr_l,
		ch7_l_out => ch7_waves_out_l,
		ch8_r_valid_addr => events(16),
		ch8_r_addr => ch8_waves_addr_r,
		ch8_r_out => ch8_waves_out_r,
		ch8_l_valid_addr => events(17),
		ch8_l_addr => ch8_waves_addr_l,
		ch8_l_out => ch8_waves_out_l,
		ch9_r_valid_addr => events(18),
		ch9_r_addr => ch9_waves_addr_r,
		ch9_r_out => ch9_waves_out_r,
		ch9_l_valid_addr => events(19),
		ch9_l_addr => ch9_waves_addr_l,
		ch9_l_out => ch9_waves_out_l,
		ch10_r_valid_addr => events(20),
		ch10_r_addr => ch10_waves_addr_r,
		ch10_r_out => ch10_waves_out_r,
		ch10_l_valid_addr => events(21),
		ch10_l_addr => ch10_waves_addr_l,
		ch10_l_out => ch10_waves_out_l,
		ch11_r_valid_addr => events(22),
		ch11_r_addr => ch11_waves_addr_r,
		ch11_r_out => ch11_waves_out_r,
		ch11_l_valid_addr => events(23),
		ch11_l_addr => ch11_waves_addr_l,
		ch11_l_out => ch11_waves_out_l,
		ch12_r_valid_addr => events(24),
		ch12_r_addr => ch12_waves_addr_r,
		ch12_r_out => ch12_waves_out_r,
		ch12_l_valid_addr => events(25),
		ch12_l_addr => ch12_waves_addr_l,
		ch12_l_out => ch12_waves_out_l,
		ch13_r_valid_addr => events(26),
		ch13_r_addr => ch13_waves_addr_r,
		ch13_r_out => ch13_waves_out_r,
		ch13_l_valid_addr => events(27),
		ch13_l_addr => ch13_waves_addr_l,
		ch13_l_out => ch13_waves_out_l,
		ch14_r_valid_addr => events(28),
		ch14_r_addr => ch14_waves_addr_r,
		ch14_r_out => ch14_waves_out_r,
		ch14_l_valid_addr => events(29),
		ch14_l_addr => ch14_waves_addr_l,
		ch14_l_out => ch14_waves_out_l,
		ch15_r_valid_addr => events(30),
		ch15_r_addr => ch15_waves_addr_r,
		ch15_r_out => ch15_waves_out_r,
		ch15_l_valid_addr => events(31),
		ch15_l_addr => ch15_waves_addr_l,
		ch15_l_out => ch15_waves_out_l
		
	);

notes: freqtable_sharer 
PORT MAP(
		clk => clk32,
		rst => rst,
		error => open,
		valid_addr_ch0 => events(2),
		addr_ch0 => ch0_current_note(9 downto 0),
		ch0_out => ch0_wave_advance,
		valid_addr_ch1 => events(3),
		addr_ch1 => ch1_current_note(9 downto 0),
		ch1_out => ch1_wave_advance,
		valid_addr_ch2 => events(4),
		addr_ch2 =>ch2_current_note(9 downto 0),
		ch2_out => ch2_wave_advance,
		valid_addr_ch3 => events(5),
		addr_ch3 => ch3_current_note(9 downto 0),
		ch3_out => ch3_wave_advance,	
		valid_addr_ch4 => events(6),
		addr_ch4 => ch4_current_note(9 downto 0),
		ch4_out => ch4_wave_advance,
		valid_addr_ch5 => events(7),
		addr_ch5 => ch5_current_note(9 downto 0),
		ch5_out => ch5_wave_advance,
		valid_addr_ch6 => events(8),
		addr_ch6 => ch6_current_note(9 downto 0),
		ch6_out => ch6_wave_advance,
		valid_addr_ch7 => events(9),
		addr_ch7 => ch7_current_note(9 downto 0),
		ch7_out => ch7_wave_advance,
		valid_addr_ch8 => events(10),
		addr_ch8 => ch8_current_note(9 downto 0),
		ch8_out => ch8_wave_advance,
		valid_addr_ch9 => events(11),
		addr_ch9 => ch9_current_note(9 downto 0),
		ch9_out => ch9_wave_advance,
		valid_addr_ch10 => events(12),
		addr_ch10 => ch10_current_note(9 downto 0),
		ch10_out => ch10_wave_advance,
		valid_addr_ch11 => events(13),
		addr_ch11 => ch11_current_note(9 downto 0),
		ch11_out => ch11_wave_advance,
		valid_addr_ch12 => events(14),
		addr_ch12 => ch12_current_note(9 downto 0),
		ch12_out => ch12_wave_advance,
		valid_addr_ch13 => events(15),
		addr_ch13 => ch13_current_note(9 downto 0),
		ch13_out => ch13_wave_advance,
		valid_addr_ch14 => events(16),
		addr_ch14 => ch14_current_note( 9 downto 0),
		ch14_out => ch14_wave_advance,
		valid_addr_ch15 => events(17),
		addr_ch15 => ch15_current_note( 9 downto 0),
		ch15_out => ch15_wave_advance 		



		);


release_rate <=  "0001000";


state(2 downto 0) <= ch0_adsr_state (2 downto 0);


Inst_adsr_sharer: adsr_sharer 
PORT MAP(
		clk => clk32,
		rst => rst,
		error => open,
		ch0_r_new_sample => events(3),
		ch0_l_new_sample => events(4),
		ch0_new_note_pulse => ch0_note_pressed,
		ch0_release_note_pulse => ch0_note_released,
		ch0_attack_rate => ch0_velocity,
		ch0_decay_rate => decay_rate,
		ch0_release_rate => release_rate,
		ch0_sustain_value => ch0_sustain,
		ch0_input_sample_r => ch0_waves_out_r,
		ch0_output_sample_r => ch0_sound_r,
		ch0_input_sample_l => ch0_waves_out_l,
		ch0_output_sample_l => ch0_sound_l,
		ch0_state => ch0_adsr_state,
		
                ch1_r_new_sample => events(5),
		ch1_l_new_sample => events(6),
		ch1_new_note_pulse => ch1_note_pressed,
		ch1_release_note_pulse => ch1_note_released,
		ch1_attack_rate => ch1_velocity,
		ch1_decay_rate => decay_rate,
		ch1_release_rate => release_rate,
		ch1_sustain_value => ch1_sustain,
		ch1_input_sample_r => ch1_waves_out_r,
		ch1_output_sample_r => ch1_sound_r,
		ch1_input_sample_l => ch1_waves_out_l,
		ch1_output_sample_l => ch1_sound_l,
		ch1_state => ch1_adsr_state,
		
                ch2_r_new_sample => events(7),
		ch2_l_new_sample => events(8),
		ch2_new_note_pulse => ch2_note_pressed,
		ch2_release_note_pulse => ch2_note_released,
		ch2_attack_rate => ch2_velocity,
		ch2_decay_rate => decay_rate,
		ch2_release_rate => release_rate,
		ch2_sustain_value => ch2_sustain,
		ch2_input_sample_r => ch2_waves_out_r,
		ch2_output_sample_r => ch2_sound_r,
		ch2_input_sample_l => ch2_waves_out_l,
		ch2_output_sample_l => ch2_sound_l,
		ch2_state => ch2_adsr_state,

		ch3_r_new_sample => events(9),
		ch3_l_new_sample => events(10),
		ch3_new_note_pulse => ch3_note_pressed,
		ch3_release_note_pulse => ch3_note_released,
		ch3_attack_rate => ch3_velocity,
		ch3_decay_rate => decay_rate,
		ch3_release_rate => release_rate,
		ch3_sustain_value => ch3_sustain,
		ch3_input_sample_r => ch3_waves_out_r,
		ch3_output_sample_r => ch3_sound_r,
		ch3_input_sample_l => ch3_waves_out_l,
		ch3_output_sample_l => ch3_sound_l,
		ch3_state => ch3_adsr_state,

		ch4_r_new_sample => events(11),
		ch4_l_new_sample => events(12),
		ch4_new_note_pulse => ch4_note_pressed,
		ch4_release_note_pulse => ch4_note_released,
		ch4_attack_rate => ch4_velocity,
		ch4_decay_rate => decay_rate,
		ch4_release_rate => release_rate,
		ch4_sustain_value => ch4_sustain,
		ch4_input_sample_r => ch4_waves_out_r,
		ch4_output_sample_r => ch4_sound_r,
		ch4_input_sample_l => ch4_waves_out_l,
		ch4_output_sample_l => ch4_sound_l,
		ch4_state => ch4_adsr_state,

		ch5_r_new_sample => events(13),
		ch5_l_new_sample => events(14),
		ch5_new_note_pulse => ch5_note_pressed,
		ch5_release_note_pulse => ch5_note_released,
		ch5_attack_rate => ch5_velocity,
		ch5_decay_rate => decay_rate,
		ch5_release_rate => release_rate,
		ch5_sustain_value => ch5_sustain,
		ch5_input_sample_r => ch5_waves_out_r,
		ch5_output_sample_r => ch5_sound_r,
		ch5_input_sample_l => ch5_waves_out_l,
		ch5_output_sample_l => ch5_sound_l,
		ch5_state => ch5_adsr_state,
		ch6_r_new_sample => events(15),
		ch6_l_new_sample => events(16),

		ch6_new_note_pulse => ch6_note_pressed,
		ch6_release_note_pulse => ch6_note_released,
		ch6_attack_rate => ch6_velocity,
		ch6_decay_rate => decay_rate,
		ch6_release_rate => release_rate,
		ch6_sustain_value => ch6_sustain,
		ch6_input_sample_r => ch6_waves_out_r,
		ch6_output_sample_r => ch6_sound_r,
		ch6_input_sample_l => ch6_waves_out_l,
		ch6_output_sample_l => ch6_sound_l,
		ch6_state => ch6_adsr_state,

		ch7_r_new_sample => events(17),
		ch7_l_new_sample => events(18),
		ch7_new_note_pulse => ch7_note_pressed,
		ch7_release_note_pulse => ch7_note_released,
		ch7_attack_rate => ch7_velocity,
		ch7_decay_rate => decay_rate,
		ch7_release_rate => release_rate,
		ch7_sustain_value => ch7_sustain,
		ch7_input_sample_r => ch7_waves_out_r,
		ch7_output_sample_r => ch7_sound_r,
		ch7_input_sample_l => ch7_waves_out_l,
		ch7_output_sample_l => ch7_sound_l,
		ch7_state => ch7_adsr_state,

		ch8_r_new_sample => events(19),
		ch8_l_new_sample => events(20),
		ch8_new_note_pulse => ch8_note_pressed,
		ch8_release_note_pulse => ch8_note_released,
		ch8_attack_rate => ch8_velocity,
		ch8_decay_rate => decay_rate,
		ch8_release_rate => release_rate,
		ch8_sustain_value => ch8_sustain,
		ch8_input_sample_r => ch8_waves_out_r,
		ch8_output_sample_r => ch8_sound_r,
		ch8_input_sample_l => ch8_waves_out_l,
		ch8_output_sample_l => ch8_sound_l,
		ch8_state => ch8_adsr_state,

		ch9_r_new_sample => events(21),
		ch9_l_new_sample => events(22),
		ch9_new_note_pulse => ch9_note_pressed,
		ch9_release_note_pulse => ch9_note_released,
		ch9_attack_rate => ch9_velocity,
		ch9_decay_rate => decay_rate,
		ch9_release_rate => release_rate,
		ch9_sustain_value => ch9_sustain,
		ch9_input_sample_r => ch9_waves_out_r,
		ch9_output_sample_r => ch9_sound_r,
		ch9_input_sample_l => ch9_waves_out_l,
		ch9_output_sample_l => ch9_sound_l,
		ch9_state => ch9_adsr_state,

		ch10_r_new_sample => events(23),
		ch10_l_new_sample => events(24),
		ch10_new_note_pulse => ch10_note_pressed,
		ch10_release_note_pulse => ch10_note_released,
		ch10_attack_rate => ch10_velocity,
		ch10_decay_rate => decay_rate,
		ch10_release_rate => release_rate,
		ch10_sustain_value => ch10_sustain,
		ch10_input_sample_r => ch10_waves_out_r,
		ch10_output_sample_r => ch10_sound_r,
		ch10_input_sample_l => ch10_waves_out_l,
		ch10_output_sample_l => ch10_sound_l,
		ch10_state => ch10_adsr_state,

		ch11_r_new_sample => events(25),
		ch11_l_new_sample => events(26),
		ch11_new_note_pulse => ch11_note_pressed,
		ch11_release_note_pulse => ch11_note_released,
		ch11_attack_rate => ch11_velocity,
		ch11_decay_rate => decay_rate,
		ch11_release_rate => release_rate,
		ch11_sustain_value => ch11_sustain,
		ch11_input_sample_r => ch11_waves_out_r,
		ch11_output_sample_r => ch11_sound_r,
		ch11_input_sample_l => ch11_waves_out_l,
		ch11_output_sample_l => ch11_sound_l,
		ch11_state => ch11_adsr_state,

		ch12_r_new_sample => events(27),
		ch12_l_new_sample => events(28),
		ch12_new_note_pulse => ch12_note_pressed,
		ch12_release_note_pulse => ch12_note_released,
		ch12_attack_rate => ch12_velocity,
		ch12_decay_rate => decay_rate,
		ch12_release_rate => release_rate,
		ch12_sustain_value => ch12_sustain,
		ch12_input_sample_r => ch12_waves_out_r,
		ch12_output_sample_r => ch12_sound_r,
		ch12_input_sample_l => ch12_waves_out_l,
		ch12_output_sample_l => ch12_sound_l,
		ch12_state => ch12_adsr_state,

		ch13_r_new_sample => events(29),
		ch13_l_new_sample => events(30),
		ch13_new_note_pulse => ch13_note_pressed,
		ch13_release_note_pulse => ch13_note_released,
		ch13_attack_rate => ch13_velocity,
		ch13_decay_rate => decay_rate,
		ch13_release_rate => release_rate,
		ch13_sustain_value => ch13_sustain,
		ch13_input_sample_r => ch13_waves_out_r,
		ch13_output_sample_r => ch13_sound_r,
		ch13_input_sample_l => ch13_waves_out_l,
		ch13_output_sample_l => ch13_sound_l,
		ch13_state => ch13_adsr_state,

		ch14_r_new_sample => events(31),
		ch14_l_new_sample => events(32),
		ch14_new_note_pulse => ch14_note_pressed,
		ch14_release_note_pulse => ch14_note_released,
		ch14_attack_rate => ch14_velocity,
		ch14_decay_rate => decay_rate,
		ch14_release_rate => release_rate,
		ch14_sustain_value => ch14_sustain,
		ch14_input_sample_r => ch14_waves_out_r,
		ch14_output_sample_r => ch14_sound_r,
		ch14_input_sample_l => ch14_waves_out_l,
		ch14_output_sample_l => ch14_sound_l,
		ch14_state => ch14_adsr_state,

		ch15_r_new_sample => events(33),
		ch15_l_new_sample => events(34),
		ch15_new_note_pulse => ch15_note_pressed,
		ch15_release_note_pulse => ch15_note_released,
		ch15_attack_rate => ch15_velocity,
		ch15_decay_rate => decay_rate,
		ch15_release_rate => release_rate,
		ch15_sustain_value => ch15_sustain,
		ch15_input_sample_r => ch15_waves_out_r,
		ch15_output_sample_r => ch15_sound_r,
		ch15_input_sample_l => ch15_waves_out_l,
		ch15_output_sample_l => ch15_sound_l,
		ch15_state => ch15_adsr_state
		);





  
-- generate pulse @ 48Khz  
Inst_event_48k_gene: event_48k_gene PORT MAP(
		clk => clk32,
		rst => rst,
		events => events
	);

process(clk32) begin
if rising_edge(clk32) then

if (rst = '1') then 
ch0_wave_totals <= "00000000000000000000";
ch1_wave_totals <= "00000000000000000000";
ch2_wave_totals <= "00000000000000000000";
ch3_wave_totals <= "00000000000000000000";
ch4_wave_totals <= "00000000000000000000";
ch5_wave_totals <= "00000000000000000000";
ch6_wave_totals <= "00000000000000000000";
ch7_wave_totals <= "00000000000000000000";
ch8_wave_totals <= "00000000000000000000";
ch9_wave_totals <= "00000000000000000000";
ch10_wave_totals <= "00000000000000000000";
ch11_wave_totals <= "00000000000000000000";
ch12_wave_totals <= "00000000000000000000";
ch13_wave_totals <= "00000000000000000000";
ch14_wave_totals <= "00000000000000000000";
ch15_wave_totals <= "00000000000000000000";
elsif (events(0) = '1') then
ch0_wave_totals   <= ch0_wave_totals + unsigned(ch0_wave_advance);
ch1_wave_totals   <= ch1_wave_totals + unsigned(ch1_wave_advance);
ch2_wave_totals   <= ch2_wave_totals + unsigned(ch2_wave_advance);
ch3_wave_totals   <= ch3_wave_totals + unsigned(ch3_wave_advance);
ch4_wave_totals   <= ch4_wave_totals + unsigned(ch4_wave_advance);
ch5_wave_totals   <= ch5_wave_totals + unsigned(ch5_wave_advance);
ch6_wave_totals   <= ch6_wave_totals + unsigned(ch6_wave_advance);
ch7_wave_totals   <= ch7_wave_totals + unsigned(ch7_wave_advance);
ch8_wave_totals   <= ch8_wave_totals + unsigned(ch8_wave_advance);
ch9_wave_totals   <= ch9_wave_totals + unsigned(ch9_wave_advance);
ch10_wave_totals   <= ch10_wave_totals + unsigned(ch10_wave_advance);
ch11_wave_totals   <= ch11_wave_totals + unsigned(ch11_wave_advance);
ch12_wave_totals   <= ch12_wave_totals + unsigned(ch12_wave_advance);
ch13_wave_totals   <= ch13_wave_totals + unsigned(ch13_wave_advance);
ch14_wave_totals   <= ch14_wave_totals + unsigned(ch14_wave_advance);
ch15_wave_totals   <= ch15_wave_totals + unsigned(ch15_wave_advance);
end if;

if (rst ='1') then
ch0_note <= "0000000";
ch1_note <= "0000000";
ch2_note <= "0000000";
ch3_note <= "0000000";
ch4_note <= "0000000";
ch5_note <= "0000000";
ch6_note <= "0000000";
ch7_note <= "0000000";
ch8_note <= "0000000";
ch9_note <= "0000000";
ch10_note <= "0000000";
ch11_note <= "0000000";
ch12_note <= "0000000";
ch13_note <= "0000000";
ch14_note <= "0000000";
ch15_note <= "0000000";
ch0_note_pressed <= '0';
ch0_note_released <= '0';
ch0_velocity <= "0000000";
ch0_sustain <= "0001000";
ch1_note_pressed <= '0';
ch1_note_released <= '0';
ch1_velocity <= "0000000";
ch1_sustain <= "0001000";
ch2_note_pressed <= '0';
ch2_note_released <= '0';
ch2_velocity <= "0000000";
ch2_sustain <= "0001000";
ch3_note_pressed <= '0';
ch3_note_released <= '0';
ch3_sustain <= "0001000";
ch3_velocity <= "0000000";
ch4_note_pressed <= '0';
ch4_note_released <= '0';
ch4_velocity <= "0000000";
ch4_sustain <= "0001000";
ch5_note_pressed <= '0';
ch5_note_released <= '0';
ch5_velocity <= "0000000";
ch5_sustain <= "0001000";
ch6_note_pressed <= '0';
ch6_note_released <= '0';
ch6_velocity <= "0000000";
ch6_sustain <= "0001000";
ch7_note_pressed <= '0';
ch7_note_released <= '0';
ch7_velocity <= "0000000";
ch7_sustain <= "0001000";
ch8_note_pressed <= '0';
ch8_note_released <= '0';
ch8_velocity <= "0000000";
ch8_sustain <= "0001000";
ch9_note_pressed <= '0';
ch9_note_released <= '0';
ch9_velocity <= "0000000";
ch9_sustain <= "0001000";
ch10_note_pressed <= '0';
ch10_note_released <= '0';
ch10_velocity <= "0000000";
ch10_sustain <= "0001000";
ch11_note_pressed <= '0';
ch11_note_released <= '0';
ch11_velocity <= "0000000";
ch11_sustain <= "0001000";
ch12_note_pressed <= '0';
ch12_note_released <= '0';
ch12_velocity <= "0000000";
ch12_sustain <= "0001000";
ch13_note_pressed <= '0';
ch13_note_released <= '0';
ch13_velocity <= "0000000";
ch13_sustain <= "0001000";
ch14_note_pressed <= '0';
ch14_note_released <= '0';
ch14_velocity <= "0000000";
ch14_sustain <= "0001000";
ch15_note_pressed <= '0';
ch15_note_released <= '0';
ch15_velocity <= "0000000";
ch15_sustain <= "0001000";

elsif (note_pressed = '1')then
case channel is
when "0000" => 
ch0_note <= note_interface;
ch0_velocity <= velocity;
ch0_note_pressed <= '1';
ch0_note_released <= '0';
when "0001" => 
ch1_note <= note_interface;
ch1_velocity <= velocity;
ch1_note_pressed <= '1';
ch1_note_released <= '0';
when "0010" => 
ch2_note <= note_interface;
ch2_velocity <= velocity;
ch2_note_pressed <= '1';
ch2_note_released <= '0';
when "0011" => 
ch3_note <= note_interface;
ch3_velocity <= velocity;
ch3_note_pressed <= '1';
ch3_note_released <= '0';
when "0100" => 
ch4_note <= note_interface;
ch4_velocity <= velocity;
ch4_note_pressed <= '1';
ch4_note_released <= '0';
when "0101" => 
ch5_note <= note_interface;
ch5_velocity <= velocity;
ch5_note_pressed <= '1';
ch5_note_released <= '0';
when "0110" => 
ch6_note <= note_interface;
ch6_velocity <= velocity;
ch6_note_pressed <= '1';
ch6_note_released <= '0';
when "0111" => 
ch7_note <= note_interface;
ch7_velocity <= velocity;
ch7_note_pressed <= '1';
ch7_note_released <= '0';
when "1000" => 
ch8_note <= note_interface;
ch8_velocity <= velocity;
ch8_note_pressed <= '1';
ch8_note_released <= '0';
when "1001" => 
ch9_note <= note_interface;
ch9_velocity <= velocity;
ch9_note_pressed <= '1';
ch9_note_released <= '0';
when "1010" => 
ch10_note <= note_interface;
ch10_velocity <= velocity;
ch10_note_pressed <= '1';
ch10_note_released <= '0';
when "1011" => 
ch11_note <= note_interface;
ch11_velocity <= velocity;
ch11_note_pressed <= '1';
ch11_note_released <= '0';
when "1100" => 
ch12_note <= note_interface;
ch12_velocity <= velocity;
ch12_note_pressed <= '1';
ch12_note_released <= '0';
when "1101" => 
ch13_note <= note_interface;
ch13_velocity <= velocity;
ch13_note_pressed <= '1';
ch13_note_released <= '0';
when "1110" => 
ch14_note <= note_interface;
ch14_velocity <= velocity;
ch14_note_pressed <= '1';
ch14_note_released <= '0';
when "1111" => 
ch15_note <= note_interface;
ch15_velocity <= velocity;
ch15_note_pressed <= '1';
ch15_note_released <= '0';
when others => ch17 <= '1';
end case;

elsif (note_released = '1')then
case channel is
when "0000" => 
ch0_note <= note_interface;
ch0_velocity <= velocity;
ch0_note_released <= '1';
ch0_note_pressed <= '0';
when "0001" => 
ch1_note <= note_interface;
ch1_velocity <= velocity;
ch1_note_released <= '1';
ch1_note_pressed <= '0';
when "0010" => 
ch2_note <= note_interface;
ch2_velocity <= velocity;
ch2_note_released <= '1';
ch2_note_pressed <= '0';
when "0011" => 
ch3_note <= note_interface;
ch3_velocity <= velocity;
ch3_note_released <= '1';
ch3_note_pressed <= '0';
when "0100" => 
ch4_note <= note_interface;
ch4_velocity <= velocity;
ch4_note_released <= '1';
ch4_note_pressed <= '0';
when "0101" => 
ch5_note <= note_interface;
ch5_velocity <= velocity;
ch5_note_released <= '1';
ch5_note_pressed <= '0';
when "0110" => 
ch6_note <= note_interface;
ch6_velocity <= velocity;
ch6_note_released <= '1';
ch6_note_pressed <= '0';
when "0111" => 
ch7_note <= note_interface;
ch7_velocity <= velocity;
ch7_note_released <= '1';
ch7_note_pressed <= '0';
when "1000" => 
ch8_note <= note_interface;
ch8_velocity <= velocity;
ch8_note_released <= '1';
ch8_note_pressed <= '0';
when "1001" => 
ch9_note <= note_interface;
ch9_velocity <= velocity;
ch9_note_released <= '1';
ch9_note_pressed <= '0';
when "1010" => 
ch10_note <= note_interface;
ch10_velocity <= velocity;
ch10_note_released <= '1';
ch10_note_pressed <= '0';
when "1011" => 
ch11_note <= note_interface;
ch11_velocity <= velocity;
ch11_note_released <= '1';
ch11_note_pressed <= '0';
when "1100" => 
ch12_note <= note_interface;
ch12_velocity <= velocity;
ch12_note_released <= '1';
ch12_note_pressed <= '0';
when "1101" => 
ch13_note <= note_interface;
ch13_velocity <= velocity;
ch13_note_released <= '1';
ch13_note_pressed <= '0';
when "1110" => 
ch14_note <= note_interface;
ch14_velocity <= velocity;
ch14_note_released <= '1';
ch14_note_pressed <= '0';
when "1111" => 
ch15_note <= note_interface;
ch15_velocity <= velocity;
ch15_note_released <= '1';
ch15_note_pressed <= '0';
when others => ch17 <= '1';
end case;

elsif (note_keypress = '1')then
case channel is
when "0000" => 
ch0_note <= note_interface;
ch0_sustain <= velocity;
ch0_note_released <= '0';
ch0_note_pressed <= '0';
when "0001" => 
ch1_note <= note_interface;
ch1_sustain <= velocity;
ch1_note_released <= '0';
ch1_note_pressed <= '0';
when "0010" => 
ch2_note <= note_interface;
ch2_sustain <= velocity;
ch2_note_released <= '0';
ch2_note_pressed <= '0';
when "0011" => 
ch3_note <= note_interface;
ch3_sustain <= velocity;
ch3_note_released <= '0';
ch3_note_pressed <= '0';
when "0100" => 
ch4_note <= note_interface;
ch4_sustain <= velocity;
ch4_note_released <= '0';
ch4_note_pressed <= '0';
when "0101" => 
ch5_note <= note_interface;
ch5_sustain <= velocity;
ch5_note_released <= '0';
ch5_note_pressed <= '0';
when "0110" => 
ch6_note <= note_interface;
ch6_sustain <= velocity;
ch6_note_released <= '0';
ch6_note_pressed <= '0';
when "0111" => 
ch7_note <= note_interface;
ch7_sustain <= velocity;
ch7_note_released <= '0';
ch7_note_pressed <= '0';
when "1000" => 
ch8_note <= note_interface;
ch8_sustain <= velocity;
ch8_note_released <= '0';
ch8_note_pressed <= '0';
when "1001" => 
ch9_note <= note_interface;
ch9_sustain <= velocity;
ch9_note_released <= '0';
ch9_note_pressed <= '0';
when "1010" => 
ch10_note <= note_interface;
ch10_sustain <= velocity;
ch10_note_released <= '0';
ch10_note_pressed <= '0';
when "1011" => 
ch11_note <= note_interface;
ch11_sustain <= velocity;
ch11_note_released <= '0';
ch11_note_pressed <= '0';
when "1100" => 
ch12_note <= note_interface;
ch12_sustain <= velocity;
ch12_note_released <= '0';
ch12_note_pressed <= '0';
when "1101" => 
ch13_note <= note_interface;
ch13_sustain <= velocity;
ch13_note_released <= '0';
ch13_note_pressed <= '0';
when "1110" => 
ch14_note <= note_interface;
ch14_sustain <= velocity;
ch14_note_released <= '0';
ch14_note_pressed <= '0';
when "1111" => 
ch15_note <= note_interface;
ch15_sustain <= velocity;
ch15_note_released <= '0';
ch15_note_pressed <= '0';
when others => ch17 <= '1';
end case;

elsif (note_channelpress = '1')then
case channel is
when "0000" => 
ch0_sustain <= velocity;
ch0_note_released <= '0';
ch0_note_pressed <= '0';
when "0001" => 
ch1_sustain <= velocity;
ch1_note_released <= '0';
ch1_note_pressed <= '0';
when "0010" => 
ch2_sustain <= velocity;
ch2_note_released <= '0';
ch2_note_pressed <= '0';
when "0011" => 
ch3_sustain <= velocity;
ch3_note_released <= '0';
ch3_note_pressed <= '0';
when "0100" => 
ch4_sustain <= velocity;
ch4_note_released <= '0';
ch4_note_pressed <= '0';
when "0101" => 
ch5_sustain <= velocity;
ch5_note_released <= '0';
ch5_note_pressed <= '0';
when "0110" => 
ch6_sustain <= velocity;
ch6_note_released <= '0';
ch6_note_pressed <= '0';
when "0111" => 
ch7_sustain <= velocity;
ch7_note_released <= '0';
ch7_note_pressed <= '0';
when "1000" => 
ch8_sustain <= velocity;
ch8_note_released <= '0';
ch8_note_pressed <= '0';
when "1001" => 
ch9_sustain <= velocity;
ch9_note_released <= '0';
ch9_note_pressed <= '0';
when "1010" => 
ch10_sustain <= velocity;
ch10_note_released <= '0';
ch10_note_pressed <= '0';
when "1011" => 
ch11_sustain <= velocity;
ch11_note_released <= '0';
ch11_note_pressed <= '0';
when "1100" => 
ch12_sustain <= velocity;
ch12_note_released <= '0';
ch12_note_pressed <= '0';
when "1101" => 
ch13_sustain <= velocity;
ch13_note_released <= '0';
ch13_note_pressed <= '0';
when "1110" => 
ch14_sustain <= velocity;
ch14_note_released <= '0';
ch14_note_pressed <= '0';
when "1111" => 
ch15_sustain <= velocity;
ch15_note_released <= '0';
ch15_note_pressed <= '0';
when others => ch17 <= '1';
end case;



else
ch0_note_pressed <= '0';
ch0_note_released <= '0';
ch1_note_pressed <= '0';
ch1_note_released <= '0';
ch2_note_pressed <= '0';
ch2_note_released <= '0';
ch3_note_pressed <= '0';
ch3_note_released <= '0';
ch4_note_pressed <= '0';
ch4_note_released <= '0';
ch5_note_pressed <= '0';
ch5_note_released <= '0';
ch6_note_pressed <= '0';
ch6_note_released <= '0';
ch7_note_pressed <= '0';
ch7_note_released <= '0';
ch8_note_pressed <= '0';
ch8_note_released <= '0';
ch9_note_pressed <= '0';
ch9_note_released <= '0';
ch10_note_pressed <= '0';
ch10_note_released <= '0';
ch11_note_pressed <= '0';
ch11_note_released <= '0';
ch12_note_pressed <= '0';
ch12_note_released <= '0';
ch13_note_pressed <= '0';
ch13_note_released <= '0';
ch14_note_pressed <= '0';
ch14_note_released <= '0';
ch15_note_pressed <= '0';
ch15_note_released <= '0';
end if;	 
end if;
end process;

ch0_current_note <=  "000" & ch0_note;
ch1_current_note <=  "000" & ch1_note;
ch2_current_note <=  "000" & ch2_note;
ch3_current_note <=  "000" & ch3_note;
ch4_current_note <=  "000" & ch4_note;
ch5_current_note <=  "000" & ch5_note;
ch6_current_note <=  "000" & ch6_note;
ch7_current_note <=  "000" & ch7_note;
ch8_current_note <=  "000" & ch8_note;
ch9_current_note <=  "000" & ch9_note;
ch10_current_note <=  "000" & ch10_note;
ch11_current_note <=  "000" & ch11_note;
ch12_current_note <=  "000" & ch12_note;
ch13_current_note <=  "000" & ch13_note;
ch14_current_note <=  "000" & ch14_note;
ch15_current_note <=  "000" & ch15_note;

end Behavioral;
