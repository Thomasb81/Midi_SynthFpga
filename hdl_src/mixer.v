`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:36:05 12/17/2012 
// Design Name: 
// Module Name:    mixer 
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
module mixer(
    input [17:0] A,
    input [17:0] B,
    output [17:0] Z
    );

wire [35:0] mult;
wire [21:0] addvalue = ((A << 1) + (B << 1) ); 
assign mult = A*B;
wire [30:0] calcul = addvalue - mult[35:17] - (1<<18);
assign Z = calcul[17:0];

endmodule
