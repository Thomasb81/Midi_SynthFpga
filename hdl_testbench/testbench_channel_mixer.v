`timescale 1ns / 1ps
module testbench_channel_mixer;

	// Inputs
	reg clk;
	reg rst;
	reg calcul_en;
	reg [17:0] ch0_sound;
	reg [17:0] ch1_sound;
	reg [17:0] ch2_sound;
	reg [17:0] ch3_sound;
	reg [17:0] ch4_sound;
	reg [17:0] ch5_sound;
	reg [17:0] ch6_sound;
	reg [17:0] ch7_sound;
	reg [17:0] ch8_sound;
	reg [17:0] ch9_sound;
	reg [17:0] ch10_sound;
	reg [17:0] ch11_sound;
	reg [17:0] ch12_sound;
	reg [17:0] ch13_sound;
	reg [17:0] ch14_sound;
	reg [17:0] ch15_sound;

	// Outputs
	wire [15:0] data_out;
	wire valid_out;

	// Instantiate the Unit Under Test (UUT)
	channel_mixer uut (
		.clk(clk), 
		.rst(rst), 
		.calcul_en(calcul_en), 
		.ch0_sound(ch0_sound), 
		.ch1_sound(ch1_sound), 
		.ch2_sound(ch2_sound), 
		.ch3_sound(ch3_sound), 
		.ch4_sound(ch4_sound), 
		.ch5_sound(ch5_sound), 
		.ch6_sound(ch6_sound), 
		.ch7_sound(ch7_sound), 
		.ch8_sound(ch8_sound), 
		.ch9_sound(ch9_sound), 
		.ch10_sound(ch10_sound), 
		.ch11_sound(ch11_sound), 
		.ch12_sound(ch12_sound), 
		.ch13_sound(ch13_sound), 
		.ch14_sound(ch14_sound), 
		.ch15_sound(ch15_sound), 
		.data_out(data_out), 
		.valid_out(valid_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		calcul_en = 0;
		ch0_sound = 0;
		ch1_sound = 0;
		ch2_sound = 0;
		ch3_sound = 0;
		ch4_sound = 0;
		ch5_sound = 0;
		ch6_sound = 0;
		ch7_sound = 0;
		ch8_sound = 0;
		ch9_sound = 0;
		ch10_sound = 0;
		ch11_sound = 0;
		ch12_sound = 0;
		ch13_sound = 0;
		ch14_sound = 0;
		ch15_sound = 0;
		
		// Wait 100 ns for global reset to finish
		#100;

		rst = 0;
		calcul_en = 0;
		ch0_sound = 128;
		ch1_sound = 64;
		ch2_sound = 0;
		ch3_sound = 0;
		ch4_sound = 0;
		ch5_sound = 0;
		ch6_sound = 0;
		ch7_sound = 0;
		ch8_sound = 0;
		ch9_sound = 0;
		ch10_sound = 0;
		ch11_sound = 0;
		ch12_sound = 0;
		ch13_sound = 0;
		ch14_sound = 0;
		ch15_sound = 0;

      # 40;
		
		calcul_en = 1;
		ch0_sound = 128;
		ch1_sound = 64;
		ch2_sound = 0;
		ch3_sound = 0;
		ch4_sound = 0;
		ch5_sound = 0;
		ch6_sound = 0;
		ch7_sound = 0;
		ch8_sound = 0;
		ch9_sound = 0;
		ch10_sound = 0;
		ch11_sound = 0;
		ch12_sound = 0;
		ch13_sound = 0;
		ch14_sound = 0;
		ch15_sound = 0;
      
      # 40;
		
		calcul_en = 0;
		ch0_sound = 128;
		ch1_sound = 64;
		ch2_sound = 0;
		ch3_sound = 0;
		ch4_sound = 0;
		ch5_sound = 0;
		ch6_sound = 0;
		ch7_sound = 0;
		ch8_sound = 0;
		ch9_sound = 0;
		ch10_sound = 0;
		ch11_sound = 0;
		ch12_sound = 0;
		ch13_sound = 0;
		ch14_sound = 0;
		ch15_sound = 0;



	end

always begin
  # 20;
  clk <= ~ clk;
end


      
endmodule

