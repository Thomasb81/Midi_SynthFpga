`timescale 1ns / 1ps
module channel_mixer(
    input clk,
    input rst,
    input calcul_en,
    input [17:0] ch0_sound,
    input [17:0] ch1_sound,
    input [17:0] ch2_sound,
    input [17:0] ch3_sound,
    input [17:0] ch4_sound,
    input [17:0] ch5_sound,
    input [17:0] ch6_sound,
    input [17:0] ch7_sound,
    input [17:0] ch8_sound,
    input [17:0] ch9_sound,
    input [17:0] ch10_sound,
    input [17:0] ch11_sound,
    input [17:0] ch12_sound,
    input [17:0] ch13_sound,
    input [17:0] ch14_sound,
    input [17:0] ch15_sound,
    output reg [17:0] data_out,
    output reg valid_out
);

/*
 * Base on
 * Viktor T. Toth - Mixing digital audio
 * http://www.vttoth.com/CMS/index.php/technical-notes/68 
 */


reg [4:0] count;
reg [17:0] inter_calcul;
reg [17:0] A,B;
wire [35:0] product;
wire [18:0]const;
assign const = 1<<18;
wire [18:0] product_remove;

wire [21:0] add_value =
(count == 1) ? ((ch1_sound << 1) + (inter_calcul<<1)):
(count == 2) ? ((ch2_sound << 1) + (inter_calcul<<1)):
(count == 3) ? ((ch3_sound << 1) + (inter_calcul<<1)):
(count == 4) ? ((ch4_sound << 1) + (inter_calcul<<1)):
(count == 5) ? ((ch5_sound << 1) + (inter_calcul<<1)):
(count == 6) ? ((ch6_sound << 1) + (inter_calcul<<1)):
(count == 7) ? ((ch7_sound << 1) + (inter_calcul<<1)):
(count == 8) ? ((ch8_sound << 1) + (inter_calcul<<1)):
(count == 9) ? ((ch9_sound << 1) + (inter_calcul<<1)):
(count == 10) ? ((ch10_sound << 1) + (inter_calcul<<1)):
(count == 11) ? ((ch11_sound << 1) + (inter_calcul<<1)):
(count == 12) ? ((ch12_sound << 1) + (inter_calcul<<1)):
(count == 13) ? ((ch13_sound << 1) + (inter_calcul<<1)):
(count == 14) ? ((ch14_sound << 1) + (inter_calcul<<1)):
(count == 15) ? ((ch15_sound << 1) + (inter_calcul<<1)):
21'h000000;



assign product_remove = product[35:17];

wire [30:0] calcul = add_value - product_remove - const;

assign product = A * B;

always @(posedge clk)
if (rst == 1'b1) begin
  count <= 5'h00;
  inter_calcul <= 18'h00000;
  valid_out <= 1'b0;
  A <= 18'h00000;
  B <= 18'h00000;
  data_out <= 18'h00000;
end
else begin
 if (calcul_en == 1'b1) begin
   valid_out <= 1'b0;
   count <= 5'h00;
	data_out <= 18'h00000;
	end
 else
   case (count)
	5'd0 : begin
	A <= ch0_sound;
	B <= ch1_sound;
	count <= count +1;
	end
	5'd1 : begin
	B <= ch2_sound;
	A <= calcul[17:0];
	// A & inter_calcul have result of muxing 2 channel
	count <= count +1;
	end
	5'd2 : begin
	B <= ch3_sound;
	A <= calcul[17:0];
	// inter_calcul have result of muxing 3 channel
	count <= count +1;
	end
	5'd3 : begin
	B <= ch4_sound;
	A <= calcul[17:0];
	// inter_calcul have result of muxing 4 channel
	count <= count +1;
	end			
	5'd4 : begin
	B <= ch5_sound;
	A <= calcul[17:0];
	// inter_calcul have result of muxing 5 channel
	count <= count +1;
	end
	5'd5 : begin
	B <= ch6_sound;
	A <= calcul[17:0];
	// inter_calcul have result of muxing 6 channel
	count <= count +1;
	end
	5'd6 : begin
	B <= ch7_sound;
	A <= calcul[17:0];
	// inter_calcul have result of muxing 7 channel
	count <= count +1;
	end
	5'd7 : begin
	B <= ch8_sound;
	A <= calcul[17:0];
	// inter_calcul have result of muxing 8 channel
	count <= count +1;
	end
	5'd8 : begin
	B <= ch9_sound;
	A <= calcul[17:0];
	// inter_calcul have result of muxing 9 channel
	count <= count +1;
	end
	5'd9 : begin
	B <= ch10_sound;
	A <= calcul[17:0];
	// inter_calcul have result of muxing 10 channel
	count <= count +1;
	end
	5'd10 : begin
	B <= ch11_sound;
	A <= calcul[17:0];
	// inter_calcul have result of muxing 11 channel
	count <= count +1;
	end
	5'd11 : begin
	B <= ch12_sound;
	A <= calcul[17:0];
	// inter_calcul have result of muxing 12 channel
	count <= count +1;
	end
	5'd12 : begin
	B <= ch13_sound;
	A <= calcul[17:0];
	// inter_calcul have result of muxing 13 channel
	count <= count +1;
	end
	5'd13 : begin
	B <= ch14_sound;
	A <= calcul[17:0];
	count <= count +1;
	end
	5'd14 : begin
	B <= ch15_sound;
	A <= calcul[17:0];
	// inter_calcul have result of muxing 15 channel
	count <= count +1;
	end
	5'd15 : begin
	A <= 17'h00000;
	B <= 17'h00000;
	data_out <= calcul[17:0];
	valid_out <= 1'b1;
	// inter_calcul have result of muxing 16 channel
	count <= count +1;
	end
	5'd16 : begin
	valid_out <= 1'b0;
	count <= count +1;
	end
	default : 
	begin
	A <= 17'h00000;
	B <= 17'h00000;
	valid_out <= 1'b0;
	end	  
	endcase

end

endmodule
