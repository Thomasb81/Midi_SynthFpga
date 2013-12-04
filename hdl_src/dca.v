module dca (
  input clk,
  input [17:0] sample,
  input [17:0] envelope,
  output [17:0] result 
);

reg [17:0] sample_q, envelope_q;
wire [35:0] produit;

always @(posedge clk) begin
  sample_q <= {~sample[17],sample[16:0]};
  envelope_q <= envelope;
end

MULT18X18 dac_mult(
.P(produit),
.A(sample_q),
.B(envelope_q)
);

assign result = {~produit[35],produit[34:18]};

endmodule
