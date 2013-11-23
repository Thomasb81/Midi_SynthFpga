module spi (
input clk,
input rst,

input sclk_fall,
input en,
input [7:0] byte_idata,

output mosi,

output reg [2:0] state

);



always @(posedge clk) begin
  
  if (rst == 1'b1) begin
    state <= 7;
  end
  else begin
    if (en == 1'b1) begin
      if (sclk_fall == 1'b1) begin
        state <= state -1;
      end
    end
    else begin
      state <= 7;
    end
  end
end

assign mosi = (en == 1'b1) ? byte_idata[state] :  1'b1; 


endmodule
