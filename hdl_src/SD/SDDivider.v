module SDDivider(
input clk,
input rst,
input en,
input [7:0] value,
output reg sclk,
output sclk_fall
);

reg [7:0] cpt;

always @(posedge clk) begin
  if (rst == 1'b1) begin
    sclk <= 1'b1;
    cpt <=0;
  end
  else begin 
    if (en == 1'b1) begin
      if (cpt == value ) begin
        sclk <= ~sclk;
        cpt <= 0;
      end
      else begin
        cpt <= cpt + 1;
      end
    end
  end
end

assign sclk_fall = ((cpt == 8'h00) && sclk==1'b0) ? 1'b1: 1'b0;


endmodule

