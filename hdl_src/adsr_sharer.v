`timescale 1ns / 1ps
module adsr_sharer(

    input clk,
    input rst,

    output error,

    input ch0_r_new_sample,
    input ch0_l_new_sample,
    input ch0_volume_pulse,
    input ch0_new_note_pulse,
    input ch0_release_note_pulse,
    input [6:0] ch0_attack_rate,
    input [6:0] ch0_decay_rate,
    input [6:0] ch0_release_rate,
    input [6:0] ch0_sustain_value,
    input [17:0] ch0_input_sample_r,
    output reg [17:0] ch0_output_sample_r,
    input [17:0] ch0_input_sample_l,
    output reg [17:0] ch0_output_sample_l,
    output [4:0] ch0_state,
    output [17:0] ch0_volume_d,


    input ch1_r_new_sample,
    input ch1_l_new_sample,
    input ch1_volume_pulse,
    input ch1_new_note_pulse,
    input ch1_release_note_pulse,
    input [6:0] ch1_attack_rate,
    input [6:0] ch1_decay_rate,
    input [6:0] ch1_release_rate,
    input [6:0] ch1_sustain_value,
    input [17:0] ch1_input_sample_r,
    output reg [17:0] ch1_output_sample_r,
    input [17:0] ch1_input_sample_l,
    output reg [17:0] ch1_output_sample_l,
    output [4:0] ch1_state,
    output [17:0] ch1_volume_d,


    input ch2_r_new_sample,
    input ch2_l_new_sample,
    input ch2_volume_pulse,
    input ch2_new_note_pulse,
    input ch2_release_note_pulse,
    input [6:0] ch2_attack_rate,
    input [6:0] ch2_decay_rate,
    input [6:0] ch2_release_rate,
    input [6:0] ch2_sustain_value,
    input [17:0] ch2_input_sample_r,
    output reg [17:0] ch2_output_sample_r,
    input [17:0] ch2_input_sample_l,
    output reg [17:0] ch2_output_sample_l,
    output [4:0] ch2_state,
    output [17:0] ch2_volume_d,


    input ch3_r_new_sample,
    input ch3_l_new_sample,
    input ch3_volume_pulse,
    input ch3_new_note_pulse,
    input ch3_release_note_pulse,
    input [6:0] ch3_attack_rate,
    input [6:0] ch3_decay_rate,
    input [6:0] ch3_release_rate,
    input [6:0] ch3_sustain_value,
    input [17:0] ch3_input_sample_r,
    output reg [17:0] ch3_output_sample_r,
    input [17:0] ch3_input_sample_l,
    output reg [17:0] ch3_output_sample_l,
    output [4:0] ch3_state,
    output [17:0] ch3_volume_d,


    input ch4_r_new_sample,
    input ch4_l_new_sample,
    input ch4_volume_pulse,
    input ch4_new_note_pulse,
    input ch4_release_note_pulse,
    input [6:0] ch4_attack_rate,
    input [6:0] ch4_decay_rate,
    input [6:0] ch4_release_rate,
    input [6:0] ch4_sustain_value,
    input [17:0] ch4_input_sample_r,
    output reg [17:0] ch4_output_sample_r,
    input [17:0] ch4_input_sample_l,
    output reg [17:0] ch4_output_sample_l,
    output [4:0] ch4_state,
    output [17:0] ch4_volume_d,


    input ch5_r_new_sample,
    input ch5_l_new_sample,
    input ch5_volume_pulse,
    input ch5_new_note_pulse,
    input ch5_release_note_pulse,
    input [6:0] ch5_attack_rate,
    input [6:0] ch5_decay_rate,
    input [6:0] ch5_release_rate,
    input [6:0] ch5_sustain_value,
    input [17:0] ch5_input_sample_r,
    output reg [17:0] ch5_output_sample_r,
    input [17:0] ch5_input_sample_l,
    output reg [17:0] ch5_output_sample_l,
    output [4:0] ch5_state,
    output [17:0] ch5_volume_d,


    input ch6_r_new_sample,
    input ch6_l_new_sample,
    input ch6_volume_pulse,
    input ch6_new_note_pulse,
    input ch6_release_note_pulse,
    input [6:0] ch6_attack_rate,
    input [6:0] ch6_decay_rate,
    input [6:0] ch6_release_rate,
    input [6:0] ch6_sustain_value,
    input [17:0] ch6_input_sample_r,
    output reg [17:0] ch6_output_sample_r,
    input [17:0] ch6_input_sample_l,
    output reg [17:0] ch6_output_sample_l,
    output [4:0] ch6_state,
    output [17:0] ch6_volume_d,


    input ch7_r_new_sample,
    input ch7_l_new_sample,
    input ch7_volume_pulse,
    input ch7_new_note_pulse,
    input ch7_release_note_pulse,
    input [6:0] ch7_attack_rate,
    input [6:0] ch7_decay_rate,
    input [6:0] ch7_release_rate,
    input [6:0] ch7_sustain_value,
    input [17:0] ch7_input_sample_r,
    output reg [17:0] ch7_output_sample_r,
    input [17:0] ch7_input_sample_l,
    output reg [17:0] ch7_output_sample_l,
    output [4:0] ch7_state,
    output [17:0] ch7_volume_d,


    input ch8_r_new_sample,
    input ch8_l_new_sample,
    input ch8_volume_pulse,
    input ch8_new_note_pulse,
    input ch8_release_note_pulse,
    input [6:0] ch8_attack_rate,
    input [6:0] ch8_decay_rate,
    input [6:0] ch8_release_rate,
    input [6:0] ch8_sustain_value,
    input [17:0] ch8_input_sample_r,
    output reg [17:0] ch8_output_sample_r,
    input [17:0] ch8_input_sample_l,
    output reg [17:0] ch8_output_sample_l,
    output [4:0] ch8_state,
    output [17:0] ch8_volume_d,


    input ch9_r_new_sample,
    input ch9_l_new_sample,
    input ch9_volume_pulse,
    input ch9_new_note_pulse,
    input ch9_release_note_pulse,
    input [6:0] ch9_attack_rate,
    input [6:0] ch9_decay_rate,
    input [6:0] ch9_release_rate,
    input [6:0] ch9_sustain_value,
    input [17:0] ch9_input_sample_r,
    output reg [17:0] ch9_output_sample_r,
    input [17:0] ch9_input_sample_l,
    output reg [17:0] ch9_output_sample_l,
    output [4:0] ch9_state,
    output [17:0] ch9_volume_d,


    input ch10_r_new_sample,
    input ch10_l_new_sample,
    input ch10_volume_pulse,
    input ch10_new_note_pulse,
    input ch10_release_note_pulse,
    input [6:0] ch10_attack_rate,
    input [6:0] ch10_decay_rate,
    input [6:0] ch10_release_rate,
    input [6:0] ch10_sustain_value,
    input [17:0] ch10_input_sample_r,
    output reg [17:0] ch10_output_sample_r,
    input [17:0] ch10_input_sample_l,
    output reg [17:0] ch10_output_sample_l,
    output [4:0] ch10_state,
    output [17:0] ch10_volume_d,


    input ch11_r_new_sample,
    input ch11_l_new_sample,
    input ch11_volume_pulse,
    input ch11_new_note_pulse,
    input ch11_release_note_pulse,
    input [6:0] ch11_attack_rate,
    input [6:0] ch11_decay_rate,
    input [6:0] ch11_release_rate,
    input [6:0] ch11_sustain_value,
    input [17:0] ch11_input_sample_r,
    output reg [17:0] ch11_output_sample_r,
    input [17:0] ch11_input_sample_l,
    output reg [17:0] ch11_output_sample_l,
    output [4:0] ch11_state,
    output [17:0] ch11_volume_d,


    input ch12_r_new_sample,
    input ch12_l_new_sample,
    input ch12_volume_pulse,
    input ch12_new_note_pulse,
    input ch12_release_note_pulse,
    input [6:0] ch12_attack_rate,
    input [6:0] ch12_decay_rate,
    input [6:0] ch12_release_rate,
    input [6:0] ch12_sustain_value,
    input [17:0] ch12_input_sample_r,
    output reg [17:0] ch12_output_sample_r,
    input [17:0] ch12_input_sample_l,
    output reg [17:0] ch12_output_sample_l,
    output [4:0] ch12_state,
    output [17:0] ch12_volume_d,


    input ch13_r_new_sample,
    input ch13_l_new_sample,
    input ch13_volume_pulse,
    input ch13_new_note_pulse,
    input ch13_release_note_pulse,
    input [6:0] ch13_attack_rate,
    input [6:0] ch13_decay_rate,
    input [6:0] ch13_release_rate,
    input [6:0] ch13_sustain_value,
    input [17:0] ch13_input_sample_r,
    output reg [17:0] ch13_output_sample_r,
    input [17:0] ch13_input_sample_l,
    output reg [17:0] ch13_output_sample_l,
    output [4:0] ch13_state,
    output [17:0] ch13_volume_d,


    input ch14_r_new_sample,
    input ch14_l_new_sample,
    input ch14_volume_pulse,
    input ch14_new_note_pulse,
    input ch14_release_note_pulse,
    input [6:0] ch14_attack_rate,
    input [6:0] ch14_decay_rate,
    input [6:0] ch14_release_rate,
    input [6:0] ch14_sustain_value,
    input [17:0] ch14_input_sample_r,
    output reg [17:0] ch14_output_sample_r,
    input [17:0] ch14_input_sample_l,
    output reg [17:0] ch14_output_sample_l,
    output [4:0] ch14_state,
    output [17:0] ch14_volume_d,


    input ch15_r_new_sample,
    input ch15_l_new_sample,
    input ch15_volume_pulse,
    input ch15_new_note_pulse,
    input ch15_release_note_pulse,
    input [6:0] ch15_attack_rate,
    input [6:0] ch15_decay_rate,
    input [6:0] ch15_release_rate,
    input [6:0] ch15_sustain_value,
    input [17:0] ch15_input_sample_r,
    output reg [17:0] ch15_output_sample_r,
    input [17:0] ch15_input_sample_l,
    output reg [17:0] ch15_output_sample_l,
    output [4:0] ch15_state,
    output [17:0] ch15_volume_d

    );


`define ATTACK 3'd1
`define DECAY 3'd2
`define SUSTAIN 3'd3
`define RELEASE 3'd4
`define BLANK 3'd5


`define VOLUME_RESET 18'h00000
`define VOLUME_MAX 18'h1FFFF


wire [17:0] input_sample;
wire [17:0] output_sample;

wire [17:0] volume;

wire [17:0] volume_d;
//wire [17:0] ch0_volume_d, ch1_volume_d, ch2_volume_d, ch3_volume_d, ch4_volume_d,ch5_volume_d, ch6_volume_d, ch7_volume_d;
//wire [17:0] ch8_volume_d, ch9_volume_d, ch10_volume_d, ch11_volume_d, ch12_volume_d,ch13_volume_d, ch14_volume_d, ch15_volume_d;

wire [6:0] attack_rate;
wire [6:0] decay_rate;
wire [6:0] release_rate;
wire [6:0] sustain_value;
wire [2:0] state;


assign {attack_rate,decay_rate,release_rate,sustain_value,state} =
(ch0_r_new_sample || ch0_volume_pulse) ? {ch0_attack_rate,ch0_decay_rate,ch0_release_rate,ch0_sustain_value,ch0_state[2:0]} :
(ch0_l_new_sample || ch0_volume_pulse) ? {ch0_attack_rate,ch0_decay_rate,ch0_release_rate,ch0_sustain_value,ch0_state[2:0]} :
(ch1_r_new_sample || ch1_volume_pulse) ? {ch1_attack_rate,ch1_decay_rate,ch1_release_rate,ch1_sustain_value,ch1_state[2:0]} :
(ch1_l_new_sample || ch1_volume_pulse) ? {ch1_attack_rate,ch1_decay_rate,ch1_release_rate,ch1_sustain_value,ch1_state[2:0]} :
(ch2_r_new_sample || ch2_volume_pulse) ? {ch2_attack_rate,ch2_decay_rate,ch2_release_rate,ch2_sustain_value,ch2_state[2:0]} :
(ch2_l_new_sample || ch2_volume_pulse) ? {ch2_attack_rate,ch2_decay_rate,ch2_release_rate,ch2_sustain_value,ch2_state[2:0]} :
(ch3_r_new_sample || ch3_volume_pulse) ? {ch3_attack_rate,ch3_decay_rate,ch3_release_rate,ch3_sustain_value,ch3_state[2:0]} :
(ch3_l_new_sample || ch3_volume_pulse) ? {ch3_attack_rate,ch3_decay_rate,ch3_release_rate,ch3_sustain_value,ch3_state[2:0]} :
(ch4_r_new_sample || ch4_volume_pulse) ? {ch4_attack_rate,ch4_decay_rate,ch4_release_rate,ch4_sustain_value,ch4_state[2:0]} :
(ch4_l_new_sample || ch4_volume_pulse) ? {ch4_attack_rate,ch4_decay_rate,ch4_release_rate,ch4_sustain_value,ch4_state[2:0]} :
(ch5_r_new_sample || ch5_volume_pulse) ? {ch5_attack_rate,ch5_decay_rate,ch5_release_rate,ch5_sustain_value,ch5_state[2:0]} :
(ch5_l_new_sample || ch5_volume_pulse) ? {ch5_attack_rate,ch5_decay_rate,ch5_release_rate,ch5_sustain_value,ch5_state[2:0]} :
(ch6_r_new_sample || ch6_volume_pulse) ? {ch6_attack_rate,ch6_decay_rate,ch6_release_rate,ch6_sustain_value,ch6_state[2:0]} :
(ch6_l_new_sample || ch6_volume_pulse) ? {ch6_attack_rate,ch6_decay_rate,ch6_release_rate,ch6_sustain_value,ch6_state[2:0]} :
(ch7_r_new_sample || ch7_volume_pulse) ? {ch7_attack_rate,ch7_decay_rate,ch7_release_rate,ch7_sustain_value,ch7_state[2:0]} :
(ch7_l_new_sample || ch7_volume_pulse) ? {ch7_attack_rate,ch7_decay_rate,ch7_release_rate,ch7_sustain_value,ch7_state[2:0]} :
(ch8_r_new_sample || ch8_volume_pulse) ? {ch8_attack_rate,ch8_decay_rate,ch8_release_rate,ch8_sustain_value,ch8_state[2:0]} :
(ch8_l_new_sample || ch8_volume_pulse) ? {ch8_attack_rate,ch8_decay_rate,ch8_release_rate,ch8_sustain_value,ch8_state[2:0]} :
(ch9_r_new_sample || ch9_volume_pulse) ? {ch9_attack_rate,ch9_decay_rate,ch9_release_rate,ch9_sustain_value,ch9_state[2:0]} :
(ch9_l_new_sample || ch9_volume_pulse) ? {ch9_attack_rate,ch9_decay_rate,ch9_release_rate,ch9_sustain_value,ch9_state[2:0]} :
(ch10_r_new_sample || ch10_volume_pulse) ? {ch10_attack_rate,ch10_decay_rate,ch10_release_rate,ch10_sustain_value,ch10_state[2:0]} :
(ch10_l_new_sample || ch10_volume_pulse) ? {ch10_attack_rate,ch10_decay_rate,ch10_release_rate,ch10_sustain_value,ch10_state[2:0]} :
(ch11_r_new_sample || ch11_volume_pulse) ? {ch11_attack_rate,ch11_decay_rate,ch11_release_rate,ch11_sustain_value,ch11_state[2:0]} :
(ch11_l_new_sample || ch11_volume_pulse) ? {ch11_attack_rate,ch11_decay_rate,ch11_release_rate,ch11_sustain_value,ch11_state[2:0]} :
(ch12_r_new_sample || ch12_volume_pulse) ? {ch12_attack_rate,ch12_decay_rate,ch12_release_rate,ch12_sustain_value,ch12_state[2:0]} :
(ch12_l_new_sample || ch12_volume_pulse) ? {ch12_attack_rate,ch12_decay_rate,ch12_release_rate,ch12_sustain_value,ch12_state[2:0]} :
(ch13_r_new_sample || ch13_volume_pulse) ? {ch13_attack_rate,ch13_decay_rate,ch13_release_rate,ch13_sustain_value,ch13_state[2:0]} :
(ch13_l_new_sample || ch13_volume_pulse) ? {ch13_attack_rate,ch13_decay_rate,ch13_release_rate,ch13_sustain_value,ch13_state[2:0]} :
(ch14_r_new_sample || ch14_volume_pulse) ? {ch14_attack_rate,ch14_decay_rate,ch14_release_rate,ch14_sustain_value,ch14_state[2:0]} :
(ch14_l_new_sample || ch14_volume_pulse) ? {ch14_attack_rate,ch14_decay_rate,ch14_release_rate,ch14_sustain_value,ch14_state[2:0]} :
(ch15_r_new_sample || ch15_volume_pulse) ? {ch15_attack_rate,ch15_decay_rate,ch15_release_rate,ch15_sustain_value,ch15_state[2:0]} :
(ch15_l_new_sample || ch15_volume_pulse) ? {ch15_attack_rate,ch15_decay_rate,ch15_release_rate,ch15_sustain_value,ch15_state[2:0]} :
24'h000000;


assign input_sample =
(ch0_r_new_sample) ? ch0_input_sample_r :
(ch0_l_new_sample) ? ch0_input_sample_l :
(ch1_r_new_sample) ? ch1_input_sample_r :
(ch1_l_new_sample) ? ch1_input_sample_l :
(ch2_r_new_sample) ? ch2_input_sample_r :
(ch2_l_new_sample) ? ch2_input_sample_l :
(ch3_r_new_sample) ? ch3_input_sample_r :
(ch3_l_new_sample) ? ch3_input_sample_l :
(ch4_r_new_sample) ? ch4_input_sample_r :
(ch4_l_new_sample) ? ch4_input_sample_l :
(ch5_r_new_sample) ? ch5_input_sample_r :
(ch5_l_new_sample) ? ch5_input_sample_l :
(ch6_r_new_sample) ? ch6_input_sample_r :
(ch6_l_new_sample) ? ch6_input_sample_l :
(ch7_r_new_sample) ? ch7_input_sample_r :
(ch7_l_new_sample) ? ch7_input_sample_l :
(ch8_r_new_sample) ? ch8_input_sample_r :
(ch8_l_new_sample) ? ch8_input_sample_l :
(ch9_r_new_sample) ? ch9_input_sample_r :
(ch9_l_new_sample) ? ch9_input_sample_l :
(ch10_r_new_sample) ? ch10_input_sample_r :
(ch10_l_new_sample) ? ch10_input_sample_l :
(ch11_r_new_sample) ? ch11_input_sample_r :
(ch11_l_new_sample) ? ch11_input_sample_l :
(ch12_r_new_sample) ? ch12_input_sample_r :
(ch12_l_new_sample) ? ch12_input_sample_l :
(ch13_r_new_sample) ? ch13_input_sample_r :
(ch13_l_new_sample) ? ch13_input_sample_l :
(ch14_r_new_sample) ? ch14_input_sample_r :
(ch14_l_new_sample) ? ch14_input_sample_l :
(ch15_r_new_sample) ? ch15_input_sample_r :
(ch15_l_new_sample) ? ch15_input_sample_l :
18'h00000;

assign volume_d =
(ch0_r_new_sample || ch0_volume_pulse) ? ch0_volume_d :
(ch0_l_new_sample || ch0_volume_pulse) ? ch0_volume_d :
(ch1_r_new_sample || ch1_volume_pulse) ? ch1_volume_d :
(ch1_l_new_sample || ch1_volume_pulse) ? ch1_volume_d :
(ch2_r_new_sample || ch2_volume_pulse) ? ch2_volume_d :
(ch2_l_new_sample || ch2_volume_pulse) ? ch2_volume_d :
(ch3_r_new_sample || ch3_volume_pulse) ? ch3_volume_d :
(ch3_l_new_sample || ch3_volume_pulse) ? ch3_volume_d :
(ch4_r_new_sample || ch4_volume_pulse) ? ch4_volume_d :
(ch4_l_new_sample || ch4_volume_pulse) ? ch4_volume_d :
(ch5_r_new_sample || ch5_volume_pulse) ? ch5_volume_d :
(ch5_l_new_sample || ch5_volume_pulse) ? ch5_volume_d :
(ch6_r_new_sample || ch6_volume_pulse) ? ch6_volume_d :
(ch6_l_new_sample || ch6_volume_pulse) ? ch6_volume_d :
(ch7_r_new_sample || ch7_volume_pulse) ? ch7_volume_d :
(ch7_l_new_sample || ch7_volume_pulse) ? ch7_volume_d :
(ch8_r_new_sample || ch8_volume_pulse) ? ch8_volume_d :
(ch8_l_new_sample || ch8_volume_pulse) ? ch8_volume_d :
(ch9_r_new_sample || ch9_volume_pulse) ? ch9_volume_d :
(ch9_l_new_sample || ch9_volume_pulse) ? ch9_volume_d :
(ch10_r_new_sample || ch10_volume_pulse) ? ch10_volume_d :
(ch10_l_new_sample || ch10_volume_pulse) ? ch10_volume_d :
(ch11_r_new_sample || ch11_volume_pulse) ? ch11_volume_d :
(ch11_l_new_sample || ch11_volume_pulse) ? ch11_volume_d :
(ch12_r_new_sample || ch12_volume_pulse) ? ch12_volume_d :
(ch12_l_new_sample || ch12_volume_pulse) ? ch12_volume_d :
(ch13_r_new_sample || ch13_volume_pulse) ? ch13_volume_d :
(ch13_l_new_sample || ch13_volume_pulse) ? ch13_volume_d :
(ch14_r_new_sample || ch14_volume_pulse) ? ch14_volume_d :
(ch14_l_new_sample || ch14_volume_pulse) ? ch14_volume_d :
(ch15_r_new_sample || ch15_volume_pulse) ? ch15_volume_d :
(ch15_l_new_sample || ch15_volume_pulse) ? ch15_volume_d :
18'h00000;


always @(posedge clk)
if (rst== 1'b1) begin
  ch0_output_sample_r <= 18'h20000;
  ch0_output_sample_l <= 18'h20000;
  ch1_output_sample_r <= 18'h20000;
  ch1_output_sample_l <= 18'h20000;
  ch2_output_sample_r <= 18'h20000;
  ch2_output_sample_l <= 18'h20000;
  ch3_output_sample_r <= 18'h20000;
  ch3_output_sample_l <= 18'h20000;
  ch4_output_sample_r <= 18'h20000;
  ch4_output_sample_l <= 18'h20000;
  ch5_output_sample_r <= 18'h20000;
  ch5_output_sample_l <= 18'h20000;
  ch6_output_sample_r <= 18'h20000;
  ch6_output_sample_l <= 18'h20000;
  ch7_output_sample_r <= 18'h20000;
  ch7_output_sample_l <= 18'h20000;
  ch8_output_sample_r <= 18'h20000;
  ch8_output_sample_l <= 18'h20000;
  ch9_output_sample_r <= 18'h20000;
  ch9_output_sample_l <= 18'h20000;
  ch10_output_sample_r <= 18'h20000;
  ch10_output_sample_l <= 18'h20000;
  ch11_output_sample_r <= 18'h20000;
  ch11_output_sample_l <= 18'h20000;
  ch12_output_sample_r <= 18'h20000;
  ch12_output_sample_l <= 18'h20000;
  ch13_output_sample_r <= 18'h20000;
  ch13_output_sample_l <= 18'h20000;
  ch14_output_sample_r <= 18'h20000;
  ch14_output_sample_l <= 18'h20000;
  ch15_output_sample_r <= 18'h20000;
  ch15_output_sample_l <= 18'h20000;
end
else if (ch0_r_new_sample) ch0_output_sample_r <= output_sample;
else if (ch1_r_new_sample) ch1_output_sample_r <= output_sample;
else if (ch2_r_new_sample) ch2_output_sample_r <= output_sample;
else if (ch3_r_new_sample) ch3_output_sample_r <= output_sample;
else if (ch4_r_new_sample) ch4_output_sample_r <= output_sample;
else if (ch5_r_new_sample) ch5_output_sample_r <= output_sample;
else if (ch6_r_new_sample) ch6_output_sample_r <= output_sample;
else if (ch7_r_new_sample) ch7_output_sample_r <= output_sample;
else if (ch8_r_new_sample) ch8_output_sample_r <= output_sample;
else if (ch9_r_new_sample) ch9_output_sample_r <= output_sample;
else if (ch10_r_new_sample) ch10_output_sample_r <= output_sample;
else if (ch11_r_new_sample) ch11_output_sample_r <= output_sample;
else if (ch12_r_new_sample) ch12_output_sample_r <= output_sample;
else if (ch13_r_new_sample) ch13_output_sample_r <= output_sample;
else if (ch14_r_new_sample) ch14_output_sample_r <= output_sample;
else if (ch15_r_new_sample) ch15_output_sample_r <= output_sample;
else if (ch0_l_new_sample) ch0_output_sample_l <= output_sample;
else if (ch1_l_new_sample) ch1_output_sample_l <= output_sample;
else if (ch2_l_new_sample) ch2_output_sample_l <= output_sample;
else if (ch3_l_new_sample) ch3_output_sample_l <= output_sample;
else if (ch4_l_new_sample) ch4_output_sample_l <= output_sample;
else if (ch5_l_new_sample) ch5_output_sample_l <= output_sample;
else if (ch6_l_new_sample) ch6_output_sample_l <= output_sample;
else if (ch7_l_new_sample) ch7_output_sample_l <= output_sample;
else if (ch8_l_new_sample) ch8_output_sample_l <= output_sample;
else if (ch9_l_new_sample) ch9_output_sample_l <= output_sample;
else if (ch10_l_new_sample) ch10_output_sample_l <= output_sample;
else if (ch11_l_new_sample) ch11_output_sample_l <= output_sample;
else if (ch12_l_new_sample) ch12_output_sample_l <= output_sample;
else if (ch13_l_new_sample) ch13_output_sample_l <= output_sample;
else if (ch14_l_new_sample) ch14_output_sample_l <= output_sample;
else if (ch15_l_new_sample) ch15_output_sample_l <= output_sample;

adsr_mngt ch0_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch0_volume_pulse),
    .new_note_pulse(ch0_new_note_pulse),
    .release_note_pulse(ch0_release_note_pulse),
    .sustain_value({6'b000000,ch0_sustain_value,5'b00000}),
    .volume_d(ch0_volume_d),
    .volume(volume),
    .state(ch0_state)
    );

adsr_mngt ch1_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch1_volume_pulse),
    .new_note_pulse(ch1_new_note_pulse),
    .release_note_pulse(ch1_release_note_pulse),
    .sustain_value({6'b000000,ch1_sustain_value,5'b00000}),
    .volume_d(ch1_volume_d),
    .volume(volume),
    .state(ch1_state)
    );

adsr_mngt ch2_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch2_volume_pulse),
    .new_note_pulse(ch2_new_note_pulse),
    .release_note_pulse(ch2_release_note_pulse),
    .sustain_value({6'b000000,ch2_sustain_value,5'b00000}),
    .volume_d(ch2_volume_d),
    .volume(volume),
    .state(ch2_state)
    );

adsr_mngt ch3_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch3_volume_pulse),
    .new_note_pulse(ch3_new_note_pulse),
    .release_note_pulse(ch3_release_note_pulse),
    .sustain_value({6'b000000,ch3_sustain_value,5'b00000}),
    .volume_d(ch3_volume_d),
    .volume(volume),
    .state(ch3_state)
    );

adsr_mngt ch4_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch4_volume_pulse),
    .new_note_pulse(ch4_new_note_pulse),
    .release_note_pulse(ch4_release_note_pulse),
    .sustain_value({6'b000000,ch4_sustain_value,5'b00000}),
    .volume_d(ch4_volume_d),
    .volume(volume),
    .state(ch4_state)
    );

adsr_mngt ch5_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch5_volume_pulse),
    .new_note_pulse(ch5_new_note_pulse),
    .release_note_pulse(ch5_release_note_pulse),
    .sustain_value({6'b000000,ch5_sustain_value,5'b00000}),
    .volume_d(ch5_volume_d),
    .volume(volume),
    .state(ch5_state)
    );

adsr_mngt ch6_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch6_volume_pulse),
    .new_note_pulse(ch6_new_note_pulse),
    .release_note_pulse(ch6_release_note_pulse),
    .sustain_value({6'b000000,ch6_sustain_value,5'b00000}),
    .volume_d(ch6_volume_d),
    .volume(volume),
    .state(ch6_state)
    );

adsr_mngt ch7_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch7_volume_pulse),
    .new_note_pulse(ch7_new_note_pulse),
    .release_note_pulse(ch7_release_note_pulse),
    .sustain_value({6'b000000,ch7_sustain_value,5'b00000}),
    .volume_d(ch7_volume_d),
    .volume(volume),
    .state(ch7_state)
    );

adsr_mngt ch8_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch8_volume_pulse),
    .new_note_pulse(ch8_new_note_pulse),
    .release_note_pulse(ch8_release_note_pulse),
    .sustain_value({6'b000000,ch8_sustain_value,5'b00000}),
    .volume_d(ch8_volume_d),
    .volume(volume),
    .state(ch8_state)
    );

adsr_mngt ch9_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch9_volume_pulse),
    .new_note_pulse(ch9_new_note_pulse),
    .release_note_pulse(ch9_release_note_pulse),
    .sustain_value({6'b000000,ch9_sustain_value,5'b00000}),
    .volume_d(ch9_volume_d),
    .volume(volume),
    .state(ch9_state)
    );

adsr_mngt ch10_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch10_volume_pulse),
    .new_note_pulse(ch10_new_note_pulse),
    .release_note_pulse(ch10_release_note_pulse),
    .sustain_value({6'b000000,ch10_sustain_value,5'b00000}),
    .volume_d(ch10_volume_d),
    .volume(volume),
    .state(ch10_state)
    );

adsr_mngt ch11_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch11_volume_pulse),
    .new_note_pulse(ch11_new_note_pulse),
    .release_note_pulse(ch11_release_note_pulse),
    .sustain_value({6'b000000,ch11_sustain_value,5'b00000}),
    .volume_d(ch11_volume_d),
    .volume(volume),
    .state(ch11_state)
    );

adsr_mngt ch12_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch12_volume_pulse),
    .new_note_pulse(ch12_new_note_pulse),
    .release_note_pulse(ch12_release_note_pulse),
    .sustain_value({6'b000000,ch12_sustain_value,5'b00000}),
    .volume_d(ch12_volume_d),
    .volume(volume),
    .state(ch12_state)
    );

adsr_mngt ch13_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch13_volume_pulse),
    .new_note_pulse(ch13_new_note_pulse),
    .release_note_pulse(ch13_release_note_pulse),
    .sustain_value({6'b000000,ch13_sustain_value,5'b00000}),
    .volume_d(ch13_volume_d),
    .volume(volume),
    .state(ch13_state)
    );

adsr_mngt ch14_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch14_volume_pulse),
    .new_note_pulse(ch14_new_note_pulse),
    .release_note_pulse(ch14_release_note_pulse),
    .sustain_value({6'b000000,ch14_sustain_value,5'b00000}),
    .volume_d(ch14_volume_d),
    .volume(volume),
    .state(ch14_state)
    );

adsr_mngt ch15_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch15_volume_pulse),
    .new_note_pulse(ch15_new_note_pulse),
    .release_note_pulse(ch15_release_note_pulse),
    .sustain_value({6'b000000,ch15_sustain_value,5'b00000}),
    .volume_d(ch15_volume_d),
    .volume(volume),
    .state(ch15_state)
    );


dca apply_env (
    .clk(clk), 
    .sample(input_sample), 
    .envelope(volume), 
    .result(output_sample)
    );


assign volume = (state[2:0] == `ATTACK ) ? volume_d + attack_rate :
                (state[2:0] == `DECAY ) ? volume_d - decay_rate :
                (state[2:0] == `SUSTAIN ) ? {6'b000000,sustain_value,5'b00000} :
                (state[2:0] == `RELEASE ) ? volume_d - release_rate : 
                (state[2:0] == `BLANK) ? `VOLUME_RESET : 
                volume_d;

endmodule
