`timescale 1ns / 1ps
module adsr_sharer(

    input clk,
    input rst,

    output error,

    input ch0_r_new_sample,
    input ch0_l_new_sample,
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


    input ch1_r_new_sample,
    input ch1_l_new_sample,
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


    input ch2_r_new_sample,
    input ch2_l_new_sample,
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


    input ch3_r_new_sample,
    input ch3_l_new_sample,
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


    input ch4_r_new_sample,
    input ch4_l_new_sample,
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


    input ch5_r_new_sample,
    input ch5_l_new_sample,
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


    input ch6_r_new_sample,
    input ch6_l_new_sample,
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


    input ch7_r_new_sample,
    input ch7_l_new_sample,
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


    input ch8_r_new_sample,
    input ch8_l_new_sample,
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


    input ch9_r_new_sample,
    input ch9_l_new_sample,
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


    input ch10_r_new_sample,
    input ch10_l_new_sample,
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


    input ch11_r_new_sample,
    input ch11_l_new_sample,
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


    input ch12_r_new_sample,
    input ch12_l_new_sample,
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


    input ch13_r_new_sample,
    input ch13_l_new_sample,
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


    input ch14_r_new_sample,
    input ch14_l_new_sample,
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


    input ch15_r_new_sample,
    input ch15_l_new_sample,
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
    output [4:0] ch15_state

    );


wire [17:0] input_sample;
wire [17:0] output_sample;
wire [17:0] volume;

wire [17:0] ch0_volume, ch1_volume, ch2_volume, ch3_volume, ch4_volume,ch5_volume, ch6_volume, ch7_volume;
wire [17:0] ch8_volume, ch9_volume, ch10_volume, ch11_volume, ch12_volume,ch13_volume, ch14_volume, ch15_volume;


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

assign volume =
(ch0_r_new_sample) ? ch0_volume :
(ch0_l_new_sample) ? ch0_volume :
(ch1_r_new_sample) ? ch1_volume :
(ch1_l_new_sample) ? ch1_volume :
(ch2_r_new_sample) ? ch2_volume :
(ch2_l_new_sample) ? ch2_volume :
(ch3_r_new_sample) ? ch3_volume :
(ch3_l_new_sample) ? ch3_volume :
(ch4_r_new_sample) ? ch4_volume :
(ch4_l_new_sample) ? ch4_volume :
(ch5_r_new_sample) ? ch5_volume :
(ch5_l_new_sample) ? ch5_volume :
(ch6_r_new_sample) ? ch6_volume :
(ch6_l_new_sample) ? ch6_volume :
(ch7_r_new_sample) ? ch7_volume :
(ch7_l_new_sample) ? ch7_volume :
(ch8_r_new_sample) ? ch8_volume :
(ch8_l_new_sample) ? ch8_volume :
(ch9_r_new_sample) ? ch9_volume :
(ch9_l_new_sample) ? ch9_volume :
(ch10_r_new_sample) ? ch10_volume :
(ch10_l_new_sample) ? ch10_volume :
(ch11_r_new_sample) ? ch11_volume :
(ch11_l_new_sample) ? ch11_volume :
(ch12_r_new_sample) ? ch12_volume :
(ch12_l_new_sample) ? ch12_volume :
(ch13_r_new_sample) ? ch13_volume :
(ch13_l_new_sample) ? ch13_volume :
(ch14_r_new_sample) ? ch14_volume :
(ch14_l_new_sample) ? ch14_volume :
(ch15_r_new_sample) ? ch15_volume :
(ch15_l_new_sample) ? ch15_volume :
18'h00000;


always @(posedge clk)
if (rst== 1'b1) begin
  ch0_output_sample_r <= 18'h10000;
  ch0_output_sample_l <= 18'h10000;
  ch1_output_sample_r <= 18'h10000;
  ch1_output_sample_l <= 18'h10000;
  ch2_output_sample_r <= 18'h10000;
  ch2_output_sample_l <= 18'h10000;
  ch3_output_sample_r <= 18'h10000;
  ch3_output_sample_l <= 18'h10000;
  ch4_output_sample_r <= 18'h10000;
  ch4_output_sample_l <= 18'h10000;
  ch5_output_sample_r <= 18'h10000;
  ch5_output_sample_l <= 18'h10000;
  ch6_output_sample_r <= 18'h10000;
  ch6_output_sample_l <= 18'h10000;
  ch7_output_sample_r <= 18'h10000;
  ch7_output_sample_l <= 18'h10000;
  ch8_output_sample_r <= 18'h10000;
  ch8_output_sample_l <= 18'h10000;
  ch9_output_sample_r <= 18'h10000;
  ch9_output_sample_l <= 18'h10000;
  ch10_output_sample_r <= 18'h10000;
  ch10_output_sample_l <= 18'h10000;
  ch11_output_sample_r <= 18'h10000;
  ch11_output_sample_l <= 18'h10000;
  ch12_output_sample_r <= 18'h10000;
  ch12_output_sample_l <= 18'h10000;
  ch13_output_sample_r <= 18'h10000;
  ch13_output_sample_l <= 18'h10000;
  ch14_output_sample_r <= 18'h10000;
  ch14_output_sample_l <= 18'h10000;
  ch15_output_sample_r <= 18'h10000;
  ch15_output_sample_l <= 18'h10000;
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
    .new_sample(ch0_r_new_sample),
    .new_note_pulse(ch0_new_note_pulse),
    .release_note_pulse(ch0_release_note_pulse),
    .attack_rate(ch0_attack_rate),
    .decay_rate(ch0_decay_rate),
    .release_rate(ch0_release_rate),
    .sustain_value(ch0_sustain_value),
    .volume(ch0_volume),
    .state(ch0_state)
    );

adsr_mngt ch1_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch1_r_new_sample),
    .new_note_pulse(ch1_new_note_pulse),
    .release_note_pulse(ch1_release_note_pulse),
    .attack_rate(ch1_attack_rate),
    .decay_rate(ch1_decay_rate),
    .release_rate(ch1_release_rate),
    .sustain_value(ch1_sustain_value),
    .volume(ch1_volume),
    .state(ch1_state)
    );

adsr_mngt ch2_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch2_r_new_sample),
    .new_note_pulse(ch2_new_note_pulse),
    .release_note_pulse(ch2_release_note_pulse),
    .attack_rate(ch2_attack_rate),
    .decay_rate(ch2_decay_rate),
    .release_rate(ch2_release_rate),
    .sustain_value(ch2_sustain_value),
    .volume(ch2_volume),
    .state(ch2_state)
    );

adsr_mngt ch3_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch3_r_new_sample),
    .new_note_pulse(ch3_new_note_pulse),
    .release_note_pulse(ch3_release_note_pulse),
    .attack_rate(ch3_attack_rate),
    .decay_rate(ch3_decay_rate),
    .release_rate(ch3_release_rate),
    .sustain_value(ch3_sustain_value),
    .volume(ch3_volume),
    .state(ch3_state)
    );

adsr_mngt ch4_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch4_r_new_sample),
    .new_note_pulse(ch4_new_note_pulse),
    .release_note_pulse(ch4_release_note_pulse),
    .attack_rate(ch4_attack_rate),
    .decay_rate(ch4_decay_rate),
    .release_rate(ch4_release_rate),
    .sustain_value(ch4_sustain_value),
    .volume(ch4_volume),
    .state(ch4_state)
    );

adsr_mngt ch5_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch5_r_new_sample),
    .new_note_pulse(ch5_new_note_pulse),
    .release_note_pulse(ch5_release_note_pulse),
    .attack_rate(ch5_attack_rate),
    .decay_rate(ch5_decay_rate),
    .release_rate(ch5_release_rate),
    .sustain_value(ch5_sustain_value),
    .volume(ch5_volume),
    .state(ch5_state)
    );

adsr_mngt ch6_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch6_r_new_sample),
    .new_note_pulse(ch6_new_note_pulse),
    .release_note_pulse(ch6_release_note_pulse),
    .attack_rate(ch6_attack_rate),
    .decay_rate(ch6_decay_rate),
    .release_rate(ch6_release_rate),
    .sustain_value(ch6_sustain_value),
    .volume(ch6_volume),
    .state(ch6_state)
    );

adsr_mngt ch7_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch7_r_new_sample),
    .new_note_pulse(ch7_new_note_pulse),
    .release_note_pulse(ch7_release_note_pulse),
    .attack_rate(ch7_attack_rate),
    .decay_rate(ch7_decay_rate),
    .release_rate(ch7_release_rate),
    .sustain_value(ch7_sustain_value),
    .volume(ch7_volume),
    .state(ch7_state)
    );

adsr_mngt ch8_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch8_r_new_sample),
    .new_note_pulse(ch8_new_note_pulse),
    .release_note_pulse(ch8_release_note_pulse),
    .attack_rate(ch8_attack_rate),
    .decay_rate(ch8_decay_rate),
    .release_rate(ch8_release_rate),
    .sustain_value(ch8_sustain_value),
    .volume(ch8_volume),
    .state(ch8_state)
    );

adsr_mngt ch9_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch9_r_new_sample),
    .new_note_pulse(ch9_new_note_pulse),
    .release_note_pulse(ch9_release_note_pulse),
    .attack_rate(ch9_attack_rate),
    .decay_rate(ch9_decay_rate),
    .release_rate(ch9_release_rate),
    .sustain_value(ch9_sustain_value),
    .volume(ch9_volume),
    .state(ch9_state)
    );

adsr_mngt ch10_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch10_r_new_sample),
    .new_note_pulse(ch10_new_note_pulse),
    .release_note_pulse(ch10_release_note_pulse),
    .attack_rate(ch10_attack_rate),
    .decay_rate(ch10_decay_rate),
    .release_rate(ch10_release_rate),
    .sustain_value(ch10_sustain_value),
    .volume(ch10_volume),
    .state(ch10_state)
    );

adsr_mngt ch11_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch11_r_new_sample),
    .new_note_pulse(ch11_new_note_pulse),
    .release_note_pulse(ch11_release_note_pulse),
    .attack_rate(ch11_attack_rate),
    .decay_rate(ch11_decay_rate),
    .release_rate(ch11_release_rate),
    .sustain_value(ch11_sustain_value),
    .volume(ch11_volume),
    .state(ch11_state)
    );

adsr_mngt ch12_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch12_r_new_sample),
    .new_note_pulse(ch12_new_note_pulse),
    .release_note_pulse(ch12_release_note_pulse),
    .attack_rate(ch12_attack_rate),
    .decay_rate(ch12_decay_rate),
    .release_rate(ch12_release_rate),
    .sustain_value(ch12_sustain_value),
    .volume(ch12_volume),
    .state(ch12_state)
    );

adsr_mngt ch13_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch13_r_new_sample),
    .new_note_pulse(ch13_new_note_pulse),
    .release_note_pulse(ch13_release_note_pulse),
    .attack_rate(ch13_attack_rate),
    .decay_rate(ch13_decay_rate),
    .release_rate(ch13_release_rate),
    .sustain_value(ch13_sustain_value),
    .volume(ch13_volume),
    .state(ch13_state)
    );

adsr_mngt ch14_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch14_r_new_sample),
    .new_note_pulse(ch14_new_note_pulse),
    .release_note_pulse(ch14_release_note_pulse),
    .attack_rate(ch14_attack_rate),
    .decay_rate(ch14_decay_rate),
    .release_rate(ch14_release_rate),
    .sustain_value(ch14_sustain_value),
    .volume(ch14_volume),
    .state(ch14_state)
    );

adsr_mngt ch15_adsr_mngt(
    .clk(clk),
    .rst(rst),
    .new_sample(ch15_r_new_sample),
    .new_note_pulse(ch15_new_note_pulse),
    .release_note_pulse(ch15_release_note_pulse),
    .attack_rate(ch15_attack_rate),
    .decay_rate(ch15_decay_rate),
    .release_rate(ch15_release_rate),
    .sustain_value(ch15_sustain_value),
    .volume(ch15_volume),
    .state(ch15_state)
    );


dca apply_env (
    .clk(clk), 
    .sample(input_sample), 
    .envelope(volume), 
    .result(output_sample)
    );



endmodule
