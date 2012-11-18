`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:48:16 11/04/2012 
// Design Name: 
// Module Name:    wavetable_sharer 
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
module wavetable_sharer(
    input clk,
    input rst,
    output error,
    input ch0_r_valid_addr,
    input [9:0] ch0_r_addr,
    output reg [17:0] ch0_r_out,
    input ch0_l_valid_addr,
    input [9:0] ch0_l_addr,
    output reg [17:0] ch0_l_out,
    input ch1_r_valid_addr,
    input [9:0] ch1_r_addr,
    output reg [17:0] ch1_r_out,
    input ch1_l_valid_addr,
    input [9:0] ch1_l_addr,
    output reg [17:0] ch1_l_out,
    input ch2_r_valid_addr,
    input [9:0] ch2_r_addr,
    output reg [17:0] ch2_r_out,
    input ch2_l_valid_addr,
    input [9:0] ch2_l_addr,
    output reg [17:0] ch2_l_out,
    input ch3_r_valid_addr,
    input [9:0] ch3_r_addr,
    output reg [17:0] ch3_r_out,
    input ch3_l_valid_addr,
    input [9:0] ch3_l_addr,
    output reg [17:0] ch3_l_out, 

    input ch4_r_valid_addr,
    input [9:0] ch4_r_addr,
    output reg [17:0] ch4_r_out,
    input ch4_l_valid_addr,
    input [9:0] ch4_l_addr,
    output reg [17:0] ch4_l_out,
    input ch5_r_valid_addr,
    input [9:0] ch5_r_addr,
    output reg [17:0] ch5_r_out,
    input ch5_l_valid_addr,
    input [9:0] ch5_l_addr,
    output reg [17:0] ch5_l_out,
    input ch6_r_valid_addr,
    input [9:0] ch6_r_addr,
    output reg [17:0] ch6_r_out,
    input ch6_l_valid_addr,
    input [9:0] ch6_l_addr,
    output reg [17:0] ch6_l_out,
    input ch7_r_valid_addr,
    input [9:0] ch7_r_addr,
    output reg [17:0] ch7_r_out,
    input ch7_l_valid_addr,
    input [9:0] ch7_l_addr,
    output reg [17:0] ch7_l_out, 

    input ch8_r_valid_addr,
    input [9:0] ch8_r_addr,
    output reg [17:0] ch8_r_out,
    input ch8_l_valid_addr,
    input [9:0] ch8_l_addr,
    output reg [17:0] ch8_l_out,
    input ch9_r_valid_addr,
    input [9:0] ch9_r_addr,
    output reg [17:0] ch9_r_out,
    input ch9_l_valid_addr,
    input [9:0] ch9_l_addr,
    output reg [17:0] ch9_l_out,
    input ch10_r_valid_addr,
    input [9:0] ch10_r_addr,
    output reg [17:0] ch10_r_out,
    input ch10_l_valid_addr,
    input [9:0] ch10_l_addr,
    output reg [17:0] ch10_l_out,
    input ch11_r_valid_addr,
    input [9:0] ch11_r_addr,
    output reg [17:0] ch11_r_out,
    input ch11_l_valid_addr,
    input [9:0] ch11_l_addr,
    output reg [17:0] ch11_l_out, 

    input ch12_r_valid_addr,
    input [9:0] ch12_r_addr,
    output reg [17:0] ch12_r_out,
    input ch12_l_valid_addr,
    input [9:0] ch12_l_addr,
    output reg [17:0] ch12_l_out,
    input ch13_r_valid_addr,
    input [9:0] ch13_r_addr,
    output reg [17:0] ch13_r_out,
    input ch13_l_valid_addr,
    input [9:0] ch13_l_addr,
    output reg [17:0] ch13_l_out,
    input ch14_r_valid_addr,
    input [9:0] ch14_r_addr,
    output reg [17:0] ch14_r_out,
    input ch14_l_valid_addr,
    input [9:0] ch14_l_addr,
    output reg [17:0] ch14_l_out,
    input ch15_r_valid_addr,
    input [9:0] ch15_r_addr,
    output reg [17:0] ch15_r_out,
    input ch15_l_valid_addr,
    input [9:0] ch15_l_addr,
    output reg [17:0] ch15_l_out 

    );

reg ch0_r_valid_addr_d, ch0_l_valid_addr_d, ch1_r_valid_addr_d, ch1_l_valid_addr_d;
reg ch2_r_valid_addr_d, ch2_l_valid_addr_d, ch3_r_valid_addr_d, ch3_l_valid_addr_d;
reg ch4_r_valid_addr_d, ch4_l_valid_addr_d, ch5_r_valid_addr_d, ch5_l_valid_addr_d;
reg ch6_r_valid_addr_d, ch6_l_valid_addr_d, ch7_r_valid_addr_d, ch7_l_valid_addr_d;
reg ch8_r_valid_addr_d, ch8_l_valid_addr_d, ch9_r_valid_addr_d, ch9_l_valid_addr_d;
reg ch10_r_valid_addr_d, ch10_l_valid_addr_d, ch11_r_valid_addr_d, ch11_l_valid_addr_d;
reg ch12_r_valid_addr_d, ch12_l_valid_addr_d, ch13_r_valid_addr_d, ch13_l_valid_addr_d;
reg ch14_r_valid_addr_d, ch14_l_valid_addr_d, ch15_r_valid_addr_d, ch15_l_valid_addr_d;


wire [17:0] out_data;
wire [9:0] addr;
wire en;

assign error = 
ch0_r_valid_addr ^ ch0_l_valid_addr ^ ch1_r_valid_addr ^ ch1_l_valid_addr ^
ch2_r_valid_addr ^ ch2_l_valid_addr ^ ch3_r_valid_addr ^ ch3_l_valid_addr ^
ch4_r_valid_addr ^ ch4_l_valid_addr ^ ch5_r_valid_addr ^ ch5_l_valid_addr ^
ch6_r_valid_addr ^ ch6_l_valid_addr ^ ch7_r_valid_addr ^ ch7_l_valid_addr ^
ch8_r_valid_addr ^ ch8_l_valid_addr ^ ch9_r_valid_addr ^ ch9_l_valid_addr ^
ch10_r_valid_addr ^ ch10_l_valid_addr ^ ch11_r_valid_addr ^ ch11_l_valid_addr ^
ch12_r_valid_addr ^ ch12_l_valid_addr ^ ch13_r_valid_addr ^ ch13_l_valid_addr ^
ch14_r_valid_addr ^ ch14_l_valid_addr ^ ch15_r_valid_addr ^ ch15_l_valid_addr;

assign addr = 
( ch0_r_valid_addr == 1'b1) ? ch0_r_addr :
( ch0_l_valid_addr == 1'b1) ? ch0_l_addr :
( ch1_r_valid_addr == 1'b1) ? ch1_r_addr :
( ch1_l_valid_addr == 1'b1) ? ch1_l_addr :
( ch2_r_valid_addr == 1'b1) ? ch2_r_addr :
( ch2_l_valid_addr == 1'b1) ? ch2_l_addr :
( ch3_r_valid_addr == 1'b1) ? ch3_r_addr :
( ch3_l_valid_addr == 1'b1) ? ch3_l_addr :
( ch4_r_valid_addr == 1'b1) ? ch4_r_addr :
( ch4_l_valid_addr == 1'b1) ? ch4_l_addr :
( ch5_r_valid_addr == 1'b1) ? ch5_r_addr :
( ch5_l_valid_addr == 1'b1) ? ch5_l_addr :
( ch6_r_valid_addr == 1'b1) ? ch6_r_addr :
( ch6_l_valid_addr == 1'b1) ? ch6_l_addr :
( ch7_r_valid_addr == 1'b1) ? ch7_r_addr :
( ch7_l_valid_addr == 1'b1) ? ch7_l_addr :
( ch8_r_valid_addr == 1'b1) ? ch8_r_addr :
( ch8_l_valid_addr == 1'b1) ? ch8_l_addr :
( ch9_r_valid_addr == 1'b1) ? ch9_r_addr :
( ch9_l_valid_addr == 1'b1) ? ch9_l_addr :
( ch10_r_valid_addr == 1'b1) ? ch10_r_addr :
( ch10_l_valid_addr == 1'b1) ? ch10_l_addr :
( ch11_r_valid_addr == 1'b1) ? ch11_r_addr :
( ch11_l_valid_addr == 1'b1) ? ch11_l_addr :
( ch12_r_valid_addr == 1'b1) ? ch12_r_addr :
( ch12_l_valid_addr == 1'b1) ? ch12_l_addr :
( ch13_r_valid_addr == 1'b1) ? ch13_r_addr :
( ch13_l_valid_addr == 1'b1) ? ch13_l_addr :
( ch14_r_valid_addr == 1'b1) ? ch14_r_addr :
( ch14_l_valid_addr == 1'b1) ? ch14_l_addr :
( ch15_r_valid_addr == 1'b1) ? ch15_r_addr :
( ch15_l_valid_addr == 1'b1) ? ch15_l_addr :
10'b0000000000;

assign en = 
ch0_r_valid_addr | ch0_r_valid_addr_d | ch0_l_valid_addr | ch0_l_valid_addr_d |
ch1_r_valid_addr | ch1_r_valid_addr_d | ch1_l_valid_addr | ch1_l_valid_addr_d |
ch2_r_valid_addr | ch2_r_valid_addr_d | ch2_l_valid_addr | ch2_l_valid_addr_d |
ch3_r_valid_addr | ch3_r_valid_addr_d | ch3_l_valid_addr | ch3_l_valid_addr_d |
ch4_r_valid_addr | ch4_r_valid_addr_d | ch4_l_valid_addr | ch4_l_valid_addr_d |
ch5_r_valid_addr | ch5_r_valid_addr_d | ch5_l_valid_addr | ch5_l_valid_addr_d |
ch6_r_valid_addr | ch6_r_valid_addr_d | ch6_l_valid_addr | ch6_l_valid_addr_d |
ch7_r_valid_addr | ch7_r_valid_addr_d | ch7_l_valid_addr | ch7_l_valid_addr_d |
ch8_r_valid_addr | ch8_r_valid_addr_d | ch8_l_valid_addr | ch8_l_valid_addr_d |
ch9_r_valid_addr | ch9_r_valid_addr_d | ch9_l_valid_addr | ch9_l_valid_addr_d |
ch10_r_valid_addr | ch10_r_valid_addr_d | ch10_l_valid_addr | ch10_l_valid_addr_d |
ch11_r_valid_addr | ch11_r_valid_addr_d | ch11_l_valid_addr | ch11_l_valid_addr_d |
ch12_r_valid_addr | ch12_r_valid_addr_d | ch12_l_valid_addr | ch12_l_valid_addr_d |
ch13_r_valid_addr | ch13_r_valid_addr_d | ch13_l_valid_addr | ch13_l_valid_addr_d |
ch14_r_valid_addr | ch14_r_valid_addr_d | ch14_l_valid_addr | ch14_l_valid_addr_d |
ch15_r_valid_addr | ch15_r_valid_addr_d | ch15_l_valid_addr | ch15_l_valid_addr_d ;





always @(posedge clk) begin
  if (rst == 1'b1) begin
    ch0_r_out <= 18'd0; ch0_l_out <= 18'd0;
    ch1_r_out <= 18'd0; ch1_l_out <= 18'd0;
    ch2_r_out <= 18'd0; ch2_l_out <= 18'd0;
    ch3_r_out <= 18'd0; ch3_l_out <= 18'd0;
    ch4_r_out <= 18'd0; ch4_l_out <= 18'd0;
    ch5_r_out <= 18'd0; ch5_l_out <= 18'd0;
    ch6_r_out <= 18'd0; ch6_l_out <= 18'd0;
    ch7_r_out <= 18'd0; ch7_l_out <= 18'd0;
    ch8_r_out <= 18'd0; ch8_l_out <= 18'd0;
    ch9_r_out <= 18'd0; ch9_l_out <= 18'd0;
    ch10_r_out <= 18'd0; ch10_l_out <= 18'd0;
    ch11_r_out <= 18'd0; ch11_l_out <= 18'd0;
    ch12_r_out <= 18'd0; ch12_l_out <= 18'd0;
    ch13_r_out <= 18'd0; ch13_l_out <= 18'd0;
    ch14_r_out <= 18'd0; ch14_l_out <= 18'd0;
    ch15_r_out <= 18'd0; ch15_l_out <= 18'd0;
    ch0_r_valid_addr_d <=1'b0; ch0_l_valid_addr_d <=1'b0;
    ch1_r_valid_addr_d <=1'b0; ch1_l_valid_addr_d <=1'b0;
    ch2_r_valid_addr_d <=1'b0; ch2_l_valid_addr_d <=1'b0;
    ch3_r_valid_addr_d <=1'b0; ch3_l_valid_addr_d <=1'b0;
    ch4_r_valid_addr_d <=1'b0; ch4_l_valid_addr_d <=1'b0;
    ch5_r_valid_addr_d <=1'b0; ch5_l_valid_addr_d <=1'b0;
    ch6_r_valid_addr_d <=1'b0; ch6_l_valid_addr_d <=1'b0;
    ch7_r_valid_addr_d <=1'b0; ch7_l_valid_addr_d <=1'b0;
    ch8_r_valid_addr_d <=1'b0; ch8_l_valid_addr_d <=1'b0;
    ch9_r_valid_addr_d <=1'b0; ch9_l_valid_addr_d <=1'b0;
    ch10_r_valid_addr_d <=1'b0; ch10_l_valid_addr_d <=1'b0;
    ch11_r_valid_addr_d <=1'b0; ch11_l_valid_addr_d <=1'b0;
    ch12_r_valid_addr_d <=1'b0; ch12_l_valid_addr_d <=1'b0;
    ch13_r_valid_addr_d <=1'b0; ch13_l_valid_addr_d <=1'b0;
    ch14_r_valid_addr_d <=1'b0; ch14_l_valid_addr_d <=1'b0;
    ch15_r_valid_addr_d <=1'b0; ch15_l_valid_addr_d <=1'b0;
  end
  else begin
    ch0_r_valid_addr_d <= ch0_r_valid_addr; ch0_l_valid_addr_d <= ch0_l_valid_addr;
    ch1_r_valid_addr_d <= ch1_r_valid_addr; ch1_l_valid_addr_d <= ch1_l_valid_addr;
    ch2_r_valid_addr_d <= ch2_r_valid_addr; ch2_l_valid_addr_d <= ch2_l_valid_addr;
    ch3_r_valid_addr_d <= ch3_r_valid_addr; ch3_l_valid_addr_d <= ch3_l_valid_addr;
    ch4_r_valid_addr_d <= ch4_r_valid_addr; ch4_l_valid_addr_d <= ch4_l_valid_addr;
    ch5_r_valid_addr_d <= ch5_r_valid_addr; ch5_l_valid_addr_d <= ch5_l_valid_addr;
    ch6_r_valid_addr_d <= ch6_r_valid_addr; ch6_l_valid_addr_d <= ch6_l_valid_addr;
    ch7_r_valid_addr_d <= ch7_r_valid_addr; ch7_l_valid_addr_d <= ch7_l_valid_addr;
    ch8_r_valid_addr_d <= ch8_r_valid_addr; ch8_l_valid_addr_d <= ch8_l_valid_addr;
    ch9_r_valid_addr_d <= ch9_r_valid_addr; ch9_l_valid_addr_d <= ch9_l_valid_addr;
    ch10_r_valid_addr_d <= ch10_r_valid_addr; ch10_l_valid_addr_d <= ch10_l_valid_addr;
    ch11_r_valid_addr_d <= ch11_r_valid_addr; ch11_l_valid_addr_d <= ch11_l_valid_addr;
    ch12_r_valid_addr_d <= ch12_r_valid_addr; ch12_l_valid_addr_d <= ch12_l_valid_addr;
    ch13_r_valid_addr_d <= ch13_r_valid_addr; ch13_l_valid_addr_d <= ch13_l_valid_addr;
    ch14_r_valid_addr_d <= ch14_r_valid_addr; ch14_l_valid_addr_d <= ch14_l_valid_addr;
    ch15_r_valid_addr_d <= ch15_r_valid_addr; ch15_l_valid_addr_d <= ch15_l_valid_addr;
    if (ch0_r_valid_addr_d == 1'b1) ch0_r_out <= out_data;
    else if (ch0_l_valid_addr_d == 1'b1) ch0_l_out <= out_data;
    else if (ch1_r_valid_addr_d == 1'b1) ch1_r_out <= out_data;
    else if (ch1_l_valid_addr_d == 1'b1) ch1_l_out <= out_data;
    else if (ch2_r_valid_addr_d == 1'b1) ch2_r_out <= out_data;
    else if (ch2_l_valid_addr_d == 1'b1) ch2_l_out <= out_data;
    else if (ch3_r_valid_addr_d == 1'b1) ch3_r_out <= out_data;
    else if (ch3_l_valid_addr_d == 1'b1) ch3_l_out <= out_data;
    else if (ch4_r_valid_addr_d == 1'b1) ch4_r_out <= out_data;
    else if (ch4_l_valid_addr_d == 1'b1) ch4_l_out <= out_data;
    else if (ch5_r_valid_addr_d == 1'b1) ch5_r_out <= out_data;
    else if (ch5_l_valid_addr_d == 1'b1) ch5_l_out <= out_data;
    else if (ch6_r_valid_addr_d == 1'b1) ch6_r_out <= out_data;
    else if (ch6_l_valid_addr_d == 1'b1) ch6_l_out <= out_data;
    else if (ch7_r_valid_addr_d == 1'b1) ch7_r_out <= out_data;
    else if (ch7_l_valid_addr_d == 1'b1) ch7_l_out <= out_data;
    else if (ch8_r_valid_addr_d == 1'b1) ch8_r_out <= out_data;
    else if (ch8_l_valid_addr_d == 1'b1) ch8_l_out <= out_data;
    else if (ch9_r_valid_addr_d == 1'b1) ch9_r_out <= out_data;
    else if (ch9_l_valid_addr_d == 1'b1) ch9_l_out <= out_data;
    else if (ch10_r_valid_addr_d == 1'b1) ch10_r_out <= out_data;
    else if (ch10_l_valid_addr_d == 1'b1) ch10_l_out <= out_data;
    else if (ch11_r_valid_addr_d == 1'b1) ch11_r_out <= out_data;
    else if (ch11_l_valid_addr_d == 1'b1) ch11_l_out <= out_data;
    else if (ch12_r_valid_addr_d == 1'b1) ch12_r_out <= out_data;
    else if (ch12_l_valid_addr_d == 1'b1) ch12_l_out <= out_data;
    else if (ch13_r_valid_addr_d == 1'b1) ch13_r_out <= out_data;
    else if (ch13_l_valid_addr_d == 1'b1) ch13_l_out <= out_data;
    else if (ch14_r_valid_addr_d == 1'b1) ch14_r_out <= out_data;
    else if (ch14_l_valid_addr_d == 1'b1) ch14_l_out <= out_data;
    else if (ch15_r_valid_addr_d == 1'b1) ch15_r_out <= out_data;
    else if (ch15_l_valid_addr_d == 1'b1) ch15_l_out <= out_data;
  end 
end

RAMB16_S18_wavetable wavetable (
    .clk(clk), 
    .addr(addr), 
    .en(en), 
    .do(out_data)
    );

endmodule
