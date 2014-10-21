`timescale 1ns / 1ps
module soundgen(
    input clk,
    input rst,
    input [9:0] wavetable_r,
    input wavetable_r_valid,
    input [9:0] wavetable_l,
    input wavetable_l_valid,
    input [15:0] sound,
    input sound_valid,
    input [17:0] volume_adsr,
    input [17:0] velocity,
    input tick48k,
    output reg [17:0] sound_r,
    output reg [17:0] sound_l
    );

wire [9:0] addr;
wire [17:0] out_data;
wire [17:0] output_sample;
wire [17:0] sample_latch;
wire [17:0] mix_result;
wire [35:0] mul_result;

wire [17:0] wave;

reg q1, q2, s_valid,  q122, q112, q3,q4,q5;
reg [17:0] sample_r;
reg [17:0] sample_l;

MULT18X18S mul_env (
	.C(clk),
	.CE(1'b1),
	.R(rst),
 .P(mul_result),
 .A({1'b0,volume_adsr[16:0]}),
 .B({1'b0,velocity[16:0]})
);


assign addr = (q1 == 1'b1) ? wavetable_r :
              (q112 == 1'b1) ? wavetable_l :
              10'b0000000000;

always @(posedge clk) begin
  if (rst == 1'b1) begin
    q1 <= 1'b0;
    q2 <= 1'b0;
    q122 <= 1'b0;
    s_valid <= 1'b0;
    sample_r <= 18'h20000;
    sample_l <= 18'h20000;
    sound_r <= 18'h20000;
    sound_l <= 18'h20000;

    q112 <= 1'b0;
    q3 <= 1'b0;
    q4 <= 1'b0;
    q5 <= 1'b0;
  end
  else begin
    q1 <= wavetable_r_valid || (sound_valid && ~s_valid);
    q112 <= q1;
    q122 <= q112;
    q2 <= q122;
    q3 <= q2;
    q4 <= q3;
    q5 <= q4;
    s_valid <= sound_valid;
    
    if ({q4,q5} == 2'b10) begin
      sample_r <= mix_result;
    end
    else if ({q4,q5} == 2'b01) begin
      sample_l <= mix_result;
    end
 
    if (tick48k == 1'b1) begin
      sound_r <= sample_r;
      sound_l <= sample_l;
      sample_r <= 18'h20000;
      sample_l <= 18'h20000;
    end
 
  end
end

assign sample_latch = ({q122,q2} == 2'd2) ? sample_r :
                      ({q122,q2} == 2'd1) ? sample_l :
                      18'h20000;

RAMB16_S18_wavetable wavetable (
    .clk(clk), 
    .addr(addr), 
    .en(1'b1), 
    .do(out_data)
    );

assign wave = (s_valid == 1'b0) ? out_data : {sound,2'b00};

dca apply_env (
    .clk(clk),
    .rst(rst), 
    .sample(wave), 
    .envelope({2'b00,mul_result[33:18]}), 
    .result(output_sample)
    );

mixer mixer0 (
    .clk(clk),
    .rst(rst),
    .A({output_sample[17],output_sample[16:0]}), 
    .B(sample_latch), 
    .Z(mix_result)
    );

endmodule
