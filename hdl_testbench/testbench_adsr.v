`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:34:07 11/06/2012
// Design Name:   ADSR_mngt
// Module Name:   /home/tom/prog/hamster/Synth_Envelope3/testbench_ADSR.v
// Project Name:  Synth_Envelope3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ADSR_mngt
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_ADSR;

	// Inputs
	reg clk;
	reg rst;
	reg new_sample;
	reg new_note_pulse;
	reg release_note_pulse;
	reg [6:0] attack_rate;
	reg [6:0] decay_rate;
	reg [6:0] release_rate;
	reg [6:0] sustain_value;
   wire [17:0] volume;
	wire [4:0] state;


   reg [7:0] count;
   
	// Instantiate the Unit Under Test (UUT)
	adsr_mngt uut (
		.clk(clk), 
		.rst(rst), 
		.new_sample(new_sample), 
		.new_note_pulse(new_note_pulse), 
		.release_note_pulse(release_note_pulse), 
		.attack_rate(attack_rate), 
		.decay_rate(decay_rate), 
		.release_rate(release_rate), 
		.sustain_value(sustain_value), 
		.volume(volume),  
		.state(state)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		new_sample = 0;
		new_note_pulse = 0;
		release_note_pulse = 0;
		attack_rate = 7'hFF;
		decay_rate = 7'hFF;
		release_rate = 7'hFF;
		sustain_value = 7'b0100000;
		count = 0;

		// Wait 10 ns for global reset to finish
		#20;
      rst = 1;
      #60
      rst = 0;		
		
		// Add stimulus here
		#4000
		new_note_pulse = 1;
		#20
		new_note_pulse = 0;
		
		
//		// release in sustain state
//		#80000
//		release_note_pulse = 1;
//		#20
//		release_note_pulse = 0;
	
		// release in sustain state
		#70000
		release_note_pulse = 1;
		#20
		release_note_pulse = 0;

	end

always begin
  #10
  clk <= ~clk;
end 

always @(posedge clk) begin
  count <= count +1;
  
  if (count == 127)
    new_sample <= 1'b1;
  else
    new_sample <= 1'b0;
end


      
endmodule

