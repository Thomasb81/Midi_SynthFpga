`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:53:10 12/18/2012
// Design Name:   adsr_mngt2
// Module Name:   /home/tom/prog/git/Midi_SynthFpga/hdl_testbench/tb_adsr_mgnt2.v
// Project Name:  Midi_SynthFpga
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adsr_mngt2
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_adsr_mgnt2;

	// Inputs
	reg [6:0] sustain_value;
	reg [6:0] attack_rate;
	reg [6:0] decay_rate;
	reg [6:0] release_rate;
	reg [2:0] i_state;
	reg [17:0] i_volume;
	reg i_note_pressed;
	reg i_note_released;

   reg clk;

	// Outputs
	wire [2:0] o_state;
	wire o_note_pressed;
	wire o_note_released;
	wire [17:0] o_volume;

	// Instantiate the Unit Under Test (UUT)
	adsr_mngt2 uut (
		.sustain_value(sustain_value), 
		.attack_rate(attack_rate), 
		.decay_rate(decay_rate), 
		.release_rate(release_rate), 
		.i_state(i_state), 
		.i_volume(i_volume), 
		.i_note_pressed(i_note_pressed), 
		.i_note_released(i_note_released), 
		.o_state(o_state), 
		.o_note_pressed(o_note_pressed), 
		.o_note_released(o_note_released), 
		.o_volume(o_volume)
	);

   always begin
	  #50
	  clk <= ~clk;
	end

	initial begin
		// Initialize Inputs
		sustain_value = 7'h10;
		attack_rate = 7'h7f;
		decay_rate = 7'h7f;
		release_rate = 7'h7f;
		i_state = 0;
		i_volume = 0;
		i_note_pressed = 0;
		i_note_released = 0;
      clk = 0;

		// Wait 100 ns for global reset to finish
		#450;
      
		i_note_pressed = 1;
		#100
		i_note_pressed = 0;
       
      #800000
      i_note_released = 1;
      #100
      i_note_released = 0;		
		// Add stimulus here

	end

always @(posedge clk) begin

  i_state <= o_state;
  i_volume <= o_volume;
  i_note_pressed <= o_note_pressed;
  i_note_released <= o_note_released;

end


      
endmodule

