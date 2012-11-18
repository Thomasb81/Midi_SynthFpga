`timescale 1ns / 1ps
module resync_data(
    input rst,
    input clkA,
    input validA,
    input [7:0] dataA,
    input clkB,
    output validB,
    output[7:0] dataB
    );

/* Take care only pulse is resync ! 
   No garante that this module will work fine
   Hypothesis that the dataA is still present when ValidB is generated
	=> dependency on clock ratio clkA/ClkB

   Base on http://www.fpga4fun.com/CrossClockDomain.html

 */


reg FlagToggle_clkA;
reg [2:0] SyncA_clkB;

always@(posedge clkA)
if (rst == 1'b1)
  FlagToggle_clkA <= 1'b0;
else
if (validA == 1'b1)
  FlagToggle_clkA <= ~FlagToggle_clkA;
 


always@(posedge clkB)
if (rst == 1'b1)
  SyncA_clkB <= 3'b000;
else
  SyncA_clkB <= {SyncA_clkB[1:0],FlagToggle_clkA};

assign validB = (SyncA_clkB[2] ^ SyncA_clkB[1]);


assign dataB = dataA;

endmodule
