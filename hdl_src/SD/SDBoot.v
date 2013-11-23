`timescale 1ns / 1ps
module SDBoot(
    input clk,
    input rst,

    output [6:0] cmd,
    output reg SDctrl_start,
    output en_clk,
    output [7:0] div_clk,
    output reg cs,
    input sclk_fall,
    input SDctrl_valid_status,
    input [6:0] SDctrl_status,
    input SDctrl_available 

);

`define RESET 2'b00
`define CMD0 2'b01
`define CMD1 2'b10
`define WAIT_STATUS 2'b11

reg [1:0] state;
reg [6:0] cnt;


always @(posedge clk) begin
  if (rst == 1'b1) begin
    state <= `RESET;
    cnt <= 7'b0000000;
    cs <= 1'b1;
    SDctrl_start <= 1'b0;
  end
  else begin

    SDctrl_start <= 1'b0;
    
    if (state != `RESET && SDctrl_valid_status == 1'b1) begin
      //Once we are out of RESET state cnt can be reuse
      cnt <= SDctrl_status;
    end
  
    case(state)
      `RESET: begin
        if (cnt[3:0] == 4'b1111) begin
          state <= `CMD0;
          SDctrl_start <= 1'b1;
          cs <= 1'b0;
        end
        else begin
          if (sclk_fall == 1'b1) begin
            cnt[3:0] <= cnt[3:0] +1;
          end
        end
      end
      `CMD0: begin
        if (SDctrl_available == 1'b1 && cnt == 7'h01 ) begin
          SDctrl_start <= 1'b1;
          state <= `CMD1;
        end
        else begin
          state <= `CMD0;
        end
      end
      `CMD1: begin
        if (SDctrl_available == 1'b1 && cnt == 7'h00 ) begin
          state <= `WAIT_STATUS;
        end
        else if (SDctrl_available == 1'b1 && cnt == 7'h01) begin
          state <= `WAIT_STATUS;
        end
        else begin
          state <= `CMD1;
        end
      end
      `WAIT_STATUS: begin
        if (SDctrl_available == 1'b1 && cnt == 7'h01 ) begin
          SDctrl_start <= 1'b1;
          state<=`CMD1;
        end
      end
    endcase
  end
end

assign div_clk = (cnt == 7'h00 && state == `WAIT_STATUS  ) ? 8'h00 : 8'hff;
assign en_clk = 1'b1;
assign cmd = (cnt == 7'h00 && state == `WAIT_STATUS) ? 7'h11 :
             (state == `CMD1 || state == `WAIT_STATUS) ? 7'h01 : 7'h00;


initial begin
  state <= `RESET;
end

endmodule
