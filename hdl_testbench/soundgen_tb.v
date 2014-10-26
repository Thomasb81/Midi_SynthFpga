`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:17:42 11/23/2013
// Design Name:   soundgen2
// Module Name:   /home/tom/prog/git/Midi_SynthFpga/soundgen_tb.v
// Project Name:  Midi_SynthFpga
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: soundgen2
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module soundgen_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [9:0] wavetable_r;
	reg wavetable_r_valid;
	reg [9:0] wavetable_l;
	reg wavetable_l_valid;
	reg [17:0] volume_adsr;
	reg [17:0] velocity;
	reg tick48k;

        reg [11:0] cpt; 

	// Outputs
	wire [17:0] sound_r;
	wire [17:0] sound_l;

	// Instantiate the Unit Under Test (UUT)
	soundgen soundgen0( 
		.clk(clk), 
		.rst(rst), 
		.wavetable_r(wavetable_r), 
		.wavetable_r_valid(wavetable_r_valid), 
		.wavetable_l(wavetable_l), 
		.wavetable_l_valid(wavetable_l_valid), 
		.sound(16'h0000),
		.sound_valid(1'b0),
		.volume_adsr(volume_adsr), 
		.velocity(velocity), 
		.tick48k(tick48k), 
		.sound_r(sound_r), 
		.sound_l(sound_l)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		tick48k = 0;

		// Wait 100 ns for global reset to finish
		#100;
                rst = 0;

        
		// Add stimulus here

	end


always begin
 clk <= ~clk;
 # 5;
end


always @(posedge clk) begin
  if (rst == 1'b1) begin
    cpt <= 0;
    tick48k <= 1'b0;
    wavetable_r_valid <= 0;
    wavetable_l_valid <= 0;
    wavetable_r <= 10'd128;
    wavetable_l <= 10'd128;
  end
  else begin
    tick48k <= 1'b0;
    wavetable_r_valid <= 0;
    wavetable_l_valid <= 0;
    wavetable_r <= 10'd128;
    wavetable_l <= 10'd128;
		volume_adsr <= 18'h00000;
		velocity <= 18'h00000;
    if (cpt == 11'd2000) begin
      cpt <=0;
      tick48k <= 1'b1;
    end
    else begin
      cpt <= cpt +1;
    end

   if (cpt == 11'd0) begin
     wavetable_r_valid <= 1'b1;
   end
   else if (cpt == 11'd1) begin
     wavetable_l_valid <= 1'b1;
   end
   else if (cpt == 11'd4) begin
     wavetable_r_valid <= 1'b1;
   end
   else if (cpt == 11'd5) begin
     wavetable_l_valid <= 1'b1;
   end

  if (0 <= cpt && cpt <=3 ) begin
     wavetable_r <= 0;
     wavetable_l <= 256;
     volume_adsr <= 18'h1ffff;
     velocity <= 18'h1ffff;
  end
  else if (4<= cpt && cpt <=7) begin
     wavetable_r <= wavetable_r + 25;
     wavetable_l <= wavetable_l + 25;
     volume_adsr <= 18'h01010;
     velocity <= 18'h1ffff;

  end

  end

end

      
endmodule

