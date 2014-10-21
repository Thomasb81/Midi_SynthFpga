`timescale 1ns / 1ps
module dca (
  input clk,
  input rst,
  input [17:0] sample,
  input [17:0] envelope,
  output [17:0] result 
);

wire [35:0] produit;

MULT18X18S dac_mult(
.C(clk),
.CE(1'b1),
.R(rst),
.P(produit),
.A({~sample[17],sample[16:0]}),
.B(envelope)
);

assign result = {~produit[35],produit[34:18]};

endmodule
