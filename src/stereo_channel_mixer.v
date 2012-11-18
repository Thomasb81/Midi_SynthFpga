`timescale 1ns / 1ps
module stereo_channel_mixer(
    input clk,
    input rst,
    input calcul_en,
    input [17:0] ch0_r_sound,
    input [17:0] ch1_r_sound,
    input [17:0] ch2_r_sound,
    input [17:0] ch3_r_sound,
    input [17:0] ch4_r_sound,
    input [17:0] ch5_r_sound,
    input [17:0] ch6_r_sound,
    input [17:0] ch7_r_sound,
    input [17:0] ch8_r_sound,
    input [17:0] ch9_r_sound,
    input [17:0] ch10_r_sound,
    input [17:0] ch11_r_sound,
    input [17:0] ch12_r_sound,
    input [17:0] ch13_r_sound,
    input [17:0] ch14_r_sound,
    input [17:0] ch15_r_sound,
    input [17:0] ch0_l_sound,
    input [17:0] ch1_l_sound,
    input [17:0] ch2_l_sound,
    input [17:0] ch3_l_sound,
    input [17:0] ch4_l_sound,
    input [17:0] ch5_l_sound,
    input [17:0] ch6_l_sound,
    input [17:0] ch7_l_sound,
    input [17:0] ch8_l_sound,
    input [17:0] ch9_l_sound,
    input [17:0] ch10_l_sound,
    input [17:0] ch11_l_sound,
    input [17:0] ch12_l_sound,
    input [17:0] ch13_l_sound,
    input [17:0] ch14_l_sound,
    input [17:0] ch15_l_sound,
    output reg [17:0] data_out_right,
    output reg [17:0] data_out_left
    );

`define IDLE 0
`define CALCUL_RIGHT 1
`define WAIT_RIGHT 2
`define CALCUL_LEFT 3
`define WAIT_LEFT 4


reg control;
reg calcul;
reg [2:0] state;
wire [18*16-1:0] sound;
wire valid_out;
wire [17:0] data_out;

assign sound = (control == 0) ?
{
ch0_r_sound,ch1_r_sound,ch2_r_sound,ch3_r_sound,
ch4_r_sound,ch5_r_sound,ch6_r_sound,ch7_r_sound,
ch8_r_sound,ch9_r_sound,ch10_r_sound,ch11_r_sound,
ch12_r_sound,ch13_r_sound,ch14_r_sound,ch15_r_sound} :
{
ch0_l_sound,ch1_l_sound,ch2_l_sound,ch3_l_sound,
ch4_l_sound,ch5_l_sound,ch6_l_sound,ch7_l_sound,
ch8_l_sound,ch9_l_sound,ch10_l_sound,ch11_l_sound,
ch12_l_sound,ch13_l_sound,ch14_l_sound,ch15_l_sound} ;

always @(posedge clk)
if (rst==1'b1) begin
  calcul <= 1'b0;
  control <= 1'b0;
  state <= `IDLE;
  data_out_right <= 16'h0000;
  data_out_left <= 16'h0000;
end
else begin
  case (state)
  `IDLE :
    if (calcul_en == 1'b1)
	   state <= `CALCUL_RIGHT;
	 else begin
	   calcul <= 1'b0;
		control <= 1'b0;
		state <= `IDLE;
	 end
  `CALCUL_RIGHT:
     begin
	    state <= `WAIT_RIGHT;
		 calcul <= 1'b1;
		 control <= 1'b0;
	  end
  `WAIT_RIGHT:
     if (valid_out == 1'b1) begin
	    data_out_right <= data_out;
		 state <= `CALCUL_LEFT;
		 calcul <= 1'b0;
		 control <= 1'b0;
		 end
	  else begin
	    state <= `WAIT_RIGHT;
		 calcul <= 1'b0;
		 control <= 1'b0;
	  end
  `CALCUL_LEFT:
      begin
      state <= `WAIT_LEFT;
		calcul <= 1'b1;
		control <=1'b1;
		end
  `WAIT_LEFT:
     if (valid_out == 1'b1) begin
	    data_out_left <= data_out;
		 state <= `IDLE;
		 calcul <= 1'b0;
		 control <= 1'b1;
		 end
	  else
	    begin
	    state <= `WAIT_LEFT;
		 calcul <= 1'b0;
		 control <= 1'b1;
		 end
	default: 
	  begin
	  state <= `IDLE;
	  end
  endcase
end


// Instantiate the module
channel_mixer channel_mixer_multiplexed (
    .clk(clk), 
    .rst(rst), 
    .calcul_en(calcul), 
    .ch0_sound(sound[18*16-1:18*15]), 
    .ch1_sound(sound[18*15-1:18*14]), 
    .ch2_sound(sound[18*14-1:18*13]), 
    .ch3_sound(sound[18*13-1:18*12]), 
    .ch4_sound(sound[18*12-1:18*11]), 
    .ch5_sound(sound[18*11-1:18*10]), 
    .ch6_sound(sound[18*10-1:18* 9]), 
    .ch7_sound(sound[18* 9-1:18* 8]), 
    .ch8_sound(sound[18* 8-1:18* 7]), 
    .ch9_sound(sound[18* 7-1:18* 6]), 
    .ch10_sound(sound[18*6-1:18* 5]), 
    .ch11_sound(sound[18*5-1:18* 4]), 
    .ch12_sound(sound[18*4-1:18* 3]), 
    .ch13_sound(sound[18*3-1:18* 2]), 
    .ch14_sound(sound[18*2-1:18* 1]), 
    .ch15_sound(sound[18*1-1:18* 0]), 
    .data_out(data_out), 
    .valid_out(valid_out)
    );

endmodule
