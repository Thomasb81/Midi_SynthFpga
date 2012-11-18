`timescale 1ns / 1ps
module event_48k_gene(
    input clk,
    input rst,
    output [36:0] events
    );

reg [9:0] count;

always @(posedge clk)
if (rst==1'b1)
  count <= 10'h000;
else if (count == 666)
  count <= 10'h000;
else
  count <= count + 1;

assign events = 
(count == 0  ) ? 37'h0000000001 :
(count == 1  ) ? 37'h0000000002 :
(count == 2  ) ? 37'h0000000004 :
(count == 3  ) ? 37'h0000000008 :
(count == 4  ) ? 37'h0000000010 :
(count == 5  ) ? 37'h0000000020 :
(count == 6  ) ? 37'h0000000040 :
(count == 7  ) ? 37'h0000000080 :
(count == 8  ) ? 37'h0000000100 :
(count == 9  ) ? 37'h0000000200 :
(count == 10 ) ? 37'h0000000400 :
(count == 11 ) ? 37'h0000000800 :
(count == 12 ) ? 37'h0000001000 :
(count == 13 ) ? 37'h0000002000 :
(count == 14 ) ? 37'h0000004000 :
(count == 15 ) ? 37'h0000008000 :
(count == 16 ) ? 37'h0000010000 :
(count == 17 ) ? 37'h0000020000 :
(count == 18 ) ? 37'h0000040000 :
(count == 19 ) ? 37'h0000080000 :
(count == 20 ) ? 37'h0000100000 :
(count == 21 ) ? 37'h0000200000 :
(count == 22 ) ? 37'h0000400000 :
(count == 23 ) ? 37'h0000800000 :
(count == 24 ) ? 37'h0001000000 :
(count == 25 ) ? 37'h0002000000 :
(count == 26 ) ? 37'h0004000000 :
(count == 27 ) ? 37'h0008000000 :
(count == 28 ) ? 37'h0010000000 :
(count == 29 ) ? 37'h0020000000 :
(count == 30 ) ? 37'h0040000000 :
(count == 31 ) ? 37'h0080000000 :
(count == 32 ) ? 37'h0100000000 :
(count == 33 ) ? 37'h0200000000 :
(count == 34 ) ? 37'h0400000000 :
(count == 35 ) ? 37'h0800000000 :
37'h0000000000;

endmodule
