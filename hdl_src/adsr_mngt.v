`timescale 1ns / 1ps
module adsr_mngt(
    input clk,
    input rst,
    input new_sample,
    input new_note_pulse,
    input release_note_pulse,
    input [6:0] attack_rate,
    input [6:0] decay_rate,
    input [6:0] release_rate,
    input [6:0] sustain_value,
    output [17:0] volume,
    output reg [4:0] state
    );

`define ATTACK 3'd1
`define DECAY 3'd2
`define SUSTAIN 3'd3
`define RELEASE 3'd4
`define BLANK 3'd5

`define VOLUME_RESET 18'h00000
//`define VOLUME_RESET 18'h00800
//`define VOLUME_MAX 18'h01000
`define VOLUME_MAX 18'h1FFFF

`define VOLUME_SUSTAIN 18'h000C00

wire [17:0] sustain_value_internal;
//assign sustain_value_internal = `VOLUME_SUSTAIN;
assign sustain_value_internal = {6'b000000,sustain_value,5'b00000};

reg [17:0] volume_d;
reg latch_new_note;
reg latch_release_note;

/*initial begin
  latch_new_note = 1'b0;
  latch_release_note = 1'b0;
end*/

assign volume = (state[2:0] == `ATTACK ) ? volume_d + attack_rate :
                (state[2:0] == `DECAY ) ? volume_d - decay_rate :
                (state[2:0] == `SUSTAIN ) ? sustain_value_internal :
                (state[2:0] == `RELEASE ) ? volume_d - release_rate : 
                (state[2:0] == `BLANK) ? `VOLUME_RESET : 
                volume_d;

always @(posedge clk)
if (rst==1'b1) begin
  latch_new_note <= 1'b0;
  latch_release_note <= 1'b0;
end
else begin
  if (new_note_pulse == 1'b1)
    latch_new_note <= 1'b1;
  if (release_note_pulse== 1'b1)
    latch_release_note <= 1'b1; 
	 
  if (state[2:0] == `ATTACK && latch_new_note == 1'b1)
    latch_new_note <= 1'b0;
  if((state[2:0] == `RELEASE || state[2:0] == `BLANK) && 
     latch_release_note == 1'b1)
    latch_release_note <= 1'b0;

end



always @(posedge clk) begin
  if (rst== 1'b1) begin
    state <= `BLANK;
    volume_d <= `VOLUME_RESET;
  end
  else
    begin	
    if (new_sample == 1'b1) begin
      volume_d <= volume;
      case (state[2:0])
	`BLANK: 
	begin
	  if (latch_new_note == 1'b1)
	    state[2:0] <= `ATTACK;
	  else
	    state[2:0] <= `BLANK;			 
	 end
	`ATTACK: 
	begin
          if (volume < `VOLUME_MAX)
	    state[2:0] <= `ATTACK;
	  else
	    state[2:0] <= `DECAY;
	end
	`DECAY:
	begin
	  if (latch_new_note == 1'b1)
	    state[2:0] <= `ATTACK;
	  else if (latch_release_note == 1'b1)
	    state[2:0] <= `RELEASE;
	  else if (volume > sustain_value_internal)
	    state[2:0] <= `DECAY;
	  else
	    state[2:0] <= `SUSTAIN;
	end
	`SUSTAIN:
	begin
	if (latch_new_note == 1'b1)
	  state[2:0] <= `ATTACK;
	else if (latch_release_note == 1'b1)
	  state[2:0] <= `RELEASE;
	else
	  state[2:0]<= `SUSTAIN;
	end				
	`RELEASE:
	begin
	  if (latch_new_note == 1'b1)
	    state[2:0] <= `ATTACK;
	  else if (volume > release_rate)
	    state[2:0] <= `RELEASE;
	  else 
	    state[2:0] <= `BLANK;
	end
      endcase
    end
  state[3] <= latch_new_note;
  state[4] <= latch_release_note;
  end
end


endmodule
