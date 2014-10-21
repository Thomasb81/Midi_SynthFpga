`timescale 1ns / 1ps
module mixer(
    input clk,
    input rst,
    input [17:0] A,
    input [17:0] B,
    output [17:0] Z
    );


reg [35:0] mul_result;
reg [21:0] sum2x;
reg [30:0] calcul;
reg [17:0] A_q,B_q;


always @(posedge clk) begin
  A_q <= A;
  B_q <= B;
  mul_result <= A_q * B_q;
  sum2x <= (A_q<<1) + (B_q<<1);
  calcul = sum2x - mul_result[35:17] - (1<<18);
end

assign Z = calcul[17:0];

endmodule
