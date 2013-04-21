`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:44:42 12/17/2012 
// Design Name: 
// Module Name:    soundgen 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module soundgen(
    input clk,
    input rst,
    input [9:0] wavetable_r,
    input wavetable_r_valid,
    input [9:0] wavetable_l,
    input wavetable_l_valid,
    input [17:0] volume,
    input tick48k,
    output reg [17:0] sound_r,
    output reg [17:0] sound_l
    );

wire [9:0] addr;
wire [17:0] out_data;
wire [17:0] output_sample;
wire [17:0] sample_latch;
wire [17:0] mix_result;
wire en;

reg r_valid, l_valid;
reg [17:0] sample_r;
reg [17:0] sample_l;


assign addr = (wavetable_r_valid == 1'b1) ? wavetable_r :
              (wavetable_l_valid == 1'b1) ? wavetable_l :
              10'b0000000000;

assign en = wavetable_r_valid | wavetable_l_valid | r_valid | l_valid;

always @(posedge clk) begin
  if (rst == 1'b1) begin
    r_valid <= 1'b0;
    l_valid <= 1'b0;
    sample_r <= 18'h20000;
    sample_l <= 18'h20000;
    sound_r <= 18'h20000;
    sound_l <= 18'h20000;
  end
  else begin
    r_valid <= wavetable_r_valid;
    l_valid <= wavetable_l_valid;
    
    if (r_valid == 1'b1) begin
      sample_r <= mix_result;
    end
    else if (l_valid == 1'b1) begin
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

assign sample_latch = (r_valid== 1'b1) ? sample_r :
                      (l_valid== 1'b1) ? sample_l :
                      18'h20000;

RAMB16_S18_wavetable wavetable (
    .clk(clk), 
    .addr(addr), 
    .en(en), 
    .do(out_data)
    );

dca apply_env (
    .clk(clk), 
    .sample(out_data), 
    .envelope(volume), 
    .result(output_sample)
    );

mixer mixer0 (
    .A(output_sample), 
    .B(sample_latch), 
    .Z(mix_result)
    );

endmodule
