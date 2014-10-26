`timescale 1ns / 1ps
module mixer(
    input clk,
    input rst,
    input [17:0] A,
    input [17:0] B,
    output [17:0] Z
    );


wire [35:0] mul_result;
reg [21:0] sum2x;
reg [30:0] calcul;
reg [17:0] A_q,B_q;

MULT18X18SIO #(
.AREG(1),
.BREG(1),
.PREG(1),
.B_INPUT("DIRECT")
) mixer_mul (
.A(A),
.B(B),
.CEA(1'b1),
.CEB(1'b1),
.CEP(1'b1),
.CLK(clk),
.RSTA(rst),
.RSTB(rst),
.RSTP(rst),
.BCIN(18'h00000),
.BCOUT(),
.P(mul_result)
);

always @(posedge clk) begin
  A_q <= A;
  B_q <= B;
  sum2x <= (A_q<<1) + (B_q<<1);
  calcul = sum2x - mul_result[35:17] - (1<<18);
end

assign Z = calcul[17:0];

endmodule
