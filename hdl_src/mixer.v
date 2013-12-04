module mixer(
    input clk,
    input [17:0] A,
    input [17:0] B,
    output [17:0] Z
    );

wire [18:0] mult_result;
reg [21:0] addvalue_q;
reg [21:0] addvalue_q2;
reg [21:0] addvalue_q3;
wire [30:0] calcul;

pipelined_multiplier AxB(
.clk(clk),
.a(A),
.b(B),
.p(mult_result)
);

always @(posedge clk) begin
  addvalue_q <= (A<<1) + (B<<1);
  addvalue_q2 <= addvalue_q;
  addvalue_q3 <= addvalue_q2;
end

assign calcul = addvalue_q3 - mult_result - (1<<18);
assign Z = calcul[17:0];

endmodule
