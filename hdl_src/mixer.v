module mixer(
    input clk,
    input [17:0] A,
    input [17:0] B,
    output [17:0] Z
    );

wire [21:0] addvalue;
reg [21:0] addvalue_q;
reg [35:17] mult_q;
wire [35:0] mult;
reg [17:0] A_q, B_q;


always @(posedge clk)begin
  addvalue_q<= addvalue;
  mult_q <= mult[35:17];
  A_q <= A;
  B_q <= B;
end


assign addvalue = ((A_q << 1) + (B_q << 1) ); 
assign mult = A_q*B_q;
wire [30:0] calcul = addvalue_q - mult_q - (1<<18);
assign Z = calcul[17:0];


endmodule
