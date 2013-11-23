`timescale 1ns / 1ps
module soundgen(
    input clk,
    input rst,
    input [9:0] wavetable_r,
    input wavetable_r_valid,
    input [9:0] wavetable_l,
    input wavetable_l_valid,
    input [17:0] volume_adsr,
    input [17:0] velocity,
    input tick48k,
    output reg [17:0] sound_r,
    output reg [17:0] sound_l
    );

wire [9:0] addr;
wire [17:0] out_data;
wire [17:0] output_sample;
reg [17:0] output_sample_reg;
wire [17:0] mix_result;
wire en;
wire [35:0] mul_result;
reg [17:0] mul_result_reg;
reg [17:0] volume_adsr_q,velocity_q; 
reg [9:0] wavetable_r_q, wavetable_l_q;

reg valid, valid_q, valid_q2, valid_q3, valid_q4, valid_q5, valid_q6;
reg [17:0] sample_r;
reg [17:0] sample_l;

wire [17:0] mixerA, mixerB;
wire ctrl_mixerA,ctrl_mixerB, ctrl_muxAddr;

always @(posedge clk) begin
  volume_adsr_q <= volume_adsr;
  velocity_q <= velocity;
end

assign mul_result = volume_adsr_q * velocity_q;


always @(posedge clk) begin
  mul_result_reg <= mul_result[35:18];
end

assign addr = (ctrl_muxAddr == 1'b1) ? wavetable_l_q : wavetable_r_q;

always @(posedge clk) begin
  wavetable_l_q <= wavetable_l;
  wavetable_r_q <= wavetable_r;
end

assign en = wavetable_r_valid | wavetable_l_valid | valid | valid_q;

RAMB16_S18_wavetable wavetable (
    .clk(clk), 
    .addr(addr), 
    .en(en), 
    .do(out_data)
    );

dca apply_env (
    .clk(clk), 
    .sample(out_data), 
    .envelope(mul_result_reg), 
    .result(output_sample)
    );

always @(posedge clk) begin
  output_sample_reg <= output_sample;
end

assign mixerA = (ctrl_mixerA == 1'b1) ? 18'h20000 : output_sample_reg;
assign mixerB = (ctrl_mixerB == 1'b1) ? sample_l : sample_r;

mixer mixer0 (
    .clk(clk),
    .A(mixerA), 
    .B(mixerB), 
    .Z(mix_result)
    );

always @(posedge clk) begin
  if (rst == 1'b1) begin
    sample_r <= 18'h20000;
    sample_l <= 18'h20000;
  end
  else begin
    if (valid_q5 == 1'b1) begin
      sample_r <= mix_result;
    end
    else if (valid_q6 == 1'b1) begin
      sample_l <= mix_result;
    end
    else if (tick48k == 1'b1) begin
      sound_r <= sample_r;
      sound_l <= sample_l;
      sample_r <= 18'h20000;
      sample_l <= 18'h20000;
    end
  end
end


always @(posedge clk) begin
  valid <= wavetable_r_valid;
  valid_q <= valid;
  valid_q2 <= valid_q;
  valid_q3 <= valid_q2;
  valid_q4 <= valid_q3;
  valid_q5 <= valid_q4;
  valid_q6 <= valid_q5;
end

assign {ctrl_mixerA,ctrl_mixerB} = (valid_q3 == 1'b1 && valid_q4==1'b0) ? 2'b00 :
                                   (valid_q3 == 1'b0 && valid_q4==1'b1) ? 2'b01 :
                                                                          2'b11 ;
assign ctrl_muxAddr = (valid_q == 1'b1) ? 1'b1 : 1'b0;
endmodule
