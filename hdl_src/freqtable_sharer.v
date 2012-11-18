`timescale 1ns / 1ps
module freqtable_sharer(
    input clk,
    input rst,
    output error,
    
    input valid_addr_ch0,
    input [9:0] addr_ch0,
    output reg [17:0] ch0_out,

    input valid_addr_ch1,
    input [9:0] addr_ch1,
    output reg [17:0] ch1_out,

    input valid_addr_ch2,
    input [9:0] addr_ch2,
    output reg [17:0] ch2_out,

    input valid_addr_ch3,
    input [9:0] addr_ch3,
    output reg [17:0] ch3_out,

    input valid_addr_ch4,
    input [9:0] addr_ch4,
    output reg [17:0] ch4_out,

    input valid_addr_ch5,
    input [9:0] addr_ch5,
    output reg [17:0] ch5_out,

    input valid_addr_ch6,
    input [9:0] addr_ch6,
    output reg [17:0] ch6_out,

    input valid_addr_ch7,
    input [9:0] addr_ch7,
    output reg [17:0] ch7_out,

    input valid_addr_ch8,
    input [9:0] addr_ch8,
    output reg [17:0] ch8_out,

    input valid_addr_ch9,
    input [9:0] addr_ch9,
    output reg [17:0] ch9_out,

    input valid_addr_ch10,
    input [9:0] addr_ch10,
    output reg [17:0] ch10_out,

    input valid_addr_ch11,
    input [9:0] addr_ch11,
    output reg [17:0] ch11_out,

    input valid_addr_ch12,
    input [9:0] addr_ch12,
    output reg [17:0] ch12_out,

    input valid_addr_ch13,
    input [9:0] addr_ch13,
    output reg [17:0] ch13_out,

    input valid_addr_ch14,
    input [9:0] addr_ch14,
    output reg [17:0] ch14_out,

    input valid_addr_ch15,
    input [9:0] addr_ch15,
    output reg [17:0] ch15_out

    );

reg valid_addr_ch0_d, valid_addr_ch1_d, valid_addr_ch2_d, valid_addr_ch3_d;
reg valid_addr_ch4_d, valid_addr_ch5_d, valid_addr_ch6_d, valid_addr_ch7_d;
reg valid_addr_ch8_d, valid_addr_ch9_d, valid_addr_ch10_d, valid_addr_ch11_d;
reg valid_addr_ch12_d, valid_addr_ch13_d, valid_addr_ch14_d, valid_addr_ch15_d;

wire en;
wire [17:0] do;
wire [9:0] addr;

assign addr = 
(valid_addr_ch0 == 1'b1) ? addr_ch0 :
(valid_addr_ch1 == 1'b1) ? addr_ch1 :
(valid_addr_ch2 == 1'b1) ? addr_ch2 :
(valid_addr_ch3 == 1'b1) ? addr_ch3 :
(valid_addr_ch4 == 1'b1) ? addr_ch4 :
(valid_addr_ch5 == 1'b1) ? addr_ch5 :
(valid_addr_ch6 == 1'b1) ? addr_ch6 :
(valid_addr_ch7 == 1'b1) ? addr_ch7 :
(valid_addr_ch8 == 1'b1) ? addr_ch8 :
(valid_addr_ch9 == 1'b1) ? addr_ch9 :
(valid_addr_ch10 == 1'b1) ? addr_ch10 :
(valid_addr_ch11 == 1'b1) ? addr_ch11 :
(valid_addr_ch12 == 1'b1) ? addr_ch12 :
(valid_addr_ch13 == 1'b1) ? addr_ch13 :
(valid_addr_ch14 == 1'b1) ? addr_ch14 :
(valid_addr_ch15 == 1'b1) ? addr_ch15 :
10'h000;

assign en = 
valid_addr_ch0 | valid_addr_ch1 | valid_addr_ch2 | valid_addr_ch3 |
valid_addr_ch4 | valid_addr_ch5 | valid_addr_ch6 | valid_addr_ch7 |
valid_addr_ch8 | valid_addr_ch9 | valid_addr_ch10 | valid_addr_ch11 |
valid_addr_ch12 | valid_addr_ch13 | valid_addr_ch14 | valid_addr_ch15 |
valid_addr_ch0_d | valid_addr_ch1_d | valid_addr_ch2_d | valid_addr_ch3_d |
valid_addr_ch4_d | valid_addr_ch5_d | valid_addr_ch6_d | valid_addr_ch7_d |
valid_addr_ch8_d | valid_addr_ch9_d | valid_addr_ch10_d | valid_addr_ch11_d |
valid_addr_ch12_d | valid_addr_ch13_d | valid_addr_ch14_d | valid_addr_ch15_d;

assign error = 
valid_addr_ch0 ^ valid_addr_ch1 ^ valid_addr_ch2 ^ valid_addr_ch3^
valid_addr_ch4 ^ valid_addr_ch5 ^ valid_addr_ch6 ^ valid_addr_ch7^
valid_addr_ch8 ^ valid_addr_ch9 ^ valid_addr_ch10 ^ valid_addr_ch11^
valid_addr_ch12 ^ valid_addr_ch13 ^ valid_addr_ch14 ^ valid_addr_ch15;

always @(posedge clk) begin
  if (rst==1'b1) begin
  valid_addr_ch0_d <= 18'h00000;
  valid_addr_ch1_d <= 18'h00000;
  valid_addr_ch2_d <= 18'h00000;
  valid_addr_ch3_d <= 18'h00000;
  valid_addr_ch4_d <= 18'h00000;
  valid_addr_ch5_d <= 18'h00000;
  valid_addr_ch6_d <= 18'h00000;
  valid_addr_ch7_d <= 18'h00000;
  valid_addr_ch8_d <= 18'h00000;
  valid_addr_ch9_d <= 18'h00000;
  valid_addr_ch10_d <= 18'h00000;
  valid_addr_ch11_d <= 18'h00000;
  valid_addr_ch12_d <= 18'h00000;
  valid_addr_ch13_d <= 18'h00000;
  valid_addr_ch14_d <= 18'h00000;
  valid_addr_ch15_d <= 18'h00000;
  ch0_out <= 18'h00000;
  ch1_out <= 18'h00000;
  ch2_out <= 18'h00000;
  ch3_out <= 18'h00000;
  ch4_out <= 18'h00000;
  ch5_out <= 18'h00000;
  ch6_out <= 18'h00000;
  ch7_out <= 18'h00000;
  ch8_out <= 18'h00000;
  ch9_out <= 18'h00000;
  ch10_out <= 18'h00000;
  ch11_out <= 18'h00000;
  ch12_out <= 18'h00000;
  ch13_out <= 18'h00000;
  ch14_out <= 18'h00000;
  ch15_out <= 18'h00000;
  end
  else begin
  valid_addr_ch0_d <= valid_addr_ch0;
  valid_addr_ch1_d <= valid_addr_ch1;
  valid_addr_ch2_d <= valid_addr_ch2;
  valid_addr_ch3_d <= valid_addr_ch3;
  valid_addr_ch4_d <= valid_addr_ch4;
  valid_addr_ch5_d <= valid_addr_ch5;
  valid_addr_ch6_d <= valid_addr_ch6;
  valid_addr_ch7_d <= valid_addr_ch7;
  valid_addr_ch8_d <= valid_addr_ch8;
  valid_addr_ch9_d <= valid_addr_ch9;
  valid_addr_ch10_d <= valid_addr_ch10;
  valid_addr_ch11_d <= valid_addr_ch11;
  valid_addr_ch12_d <= valid_addr_ch12;
  valid_addr_ch13_d <= valid_addr_ch13;
  valid_addr_ch14_d <= valid_addr_ch14;
  valid_addr_ch15_d <= valid_addr_ch15;
  if (valid_addr_ch0_d) ch0_out <= do;
  else if (valid_addr_ch1_d) ch1_out <= do;
  else if (valid_addr_ch2_d) ch2_out <= do;
  else if (valid_addr_ch3_d) ch3_out <= do;
  else if (valid_addr_ch4_d) ch4_out <= do;
  else if (valid_addr_ch5_d) ch5_out <= do;
  else if (valid_addr_ch6_d) ch6_out <= do;
  else if (valid_addr_ch7_d) ch7_out <= do;
  else if (valid_addr_ch8_d) ch8_out <= do;
  else if (valid_addr_ch9_d) ch9_out <= do;
  else if (valid_addr_ch10_d) ch10_out <= do;
  else if (valid_addr_ch11_d) ch11_out <= do;
  else if (valid_addr_ch12_d) ch12_out <= do;
  else if (valid_addr_ch13_d) ch13_out <= do;
  else if (valid_addr_ch14_d) ch14_out <= do;
  else if (valid_addr_ch15_d) ch15_out <= do;
  end
end


freqtable RAMB16_S18 (
    .clk(clk), 
    .addr(addr), 
    .en(en), 
    .do(do)
    );
endmodule
