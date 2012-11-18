`timescale 1ns / 1ps
module midi_ctrl(
    input clk,
    input rst,
    input valid_byte,
    input [7:0] data,
    output reg note_presse,
    output reg note_release,
	 output reg note_keypress,
	 output reg note_channelpress,
    output reg[6:0] note,
    output reg[6:0] velocity,
	 output reg [3:0] channel,
	 output reg rst_cmd,
	 output reg read
    );

reg [2:0] state;
reg [2:0] cmd;
reg valid;

always @(posedge clk) begin
  if (rst==1) begin
    state <= 3'b100;
    cmd <= 3'b000;
	 channel <= 4'b0000;
	 note_presse <= 1'b0;
	 note_release <= 1'b0;
	 note_keypress <= 1'b0;
	 note_channelpress <= 1'b0;
	 note <= 7'b0000000;
	 velocity <= 7'b0000000;
	 valid <= 1'b0;
	 rst_cmd <= 1'b0;
	 read <= 1'b0;
  end
  else
    case (state)
	 3'b000:
	   if (valid_byte == 1'b1 && data[7] == 1'b1) begin
		  state <= 3'b001;
		  cmd <= data[6:4];
		  channel <= data[3:0];
		  valid <= data[7];
		  if (data == 8'd255)
		    rst_cmd <= 1'b1;
		end
	 3'b001:	   
	   if (valid_byte == 1'b1) begin
		  if (cmd == 3'b101) begin
		    state <= 3'b100;
			 velocity <= data[6:0];
			 note_channelpress <= 1'b1;
		  end
		  else begin
		    state <= 3'b010;
		    note <= data[6:0];
		  end
		end
	 3'b010:
	   if (valid_byte == 1'b1) begin
		  state <= 3'b011;
		  velocity <= data[6:0];
		end	 
	 3'b011:
	   begin
		if (cmd == 3'b001 && valid == 1'b1)
		  note_presse <= 1'b1;
		else if (cmd == 3'b000 && valid == 1'b1)
		  note_release <= 1'b1;
		else if (cmd == 3'b010 && valid == 1'b1)
		  note_keypress <= 1'b1;
		else if (cmd == 3'b110 && valid == 1'b1)
		  read <= 1'b1;
		state <= 3'b100;
		end
	 3'b100:
	   begin
		  valid <= 1'b0;
		  state <= 3'b000;
		  note_release <= 1'b0;
		  note_presse <= 1'b0;
		  note_keypress <= 1'b0;
		  note_channelpress <= 1'b0;
		  read <=1'b0;
		end
	 endcase
end


endmodule
