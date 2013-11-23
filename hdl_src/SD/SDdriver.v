`timescale 1ns / 1ps
module SDdriver(
    input clk,
    input rst,

    input start,
    input stop,
    input [7:0] sample_code,
    input fifo_empty,
    input fifo_prog,
    output reg fifo_wr,
    output reg [15:0] fifo_data,

    input [7:0] SDctrl_data,
    input SDctrl_valid,
    input SDctrl_available,
    output [31:0] SDctrl_address,
    output reg SDctrl_start,
    
    output reg [2:0] state,
    output reg [31:0] nb_data

);

`define IDLE 3'b000
`define BOOT 3'b001
`define FIRST_FETCH 3'b100
`define FETCH 3'b010
`define WAIT 3'b011

reg [10:0] data_cpt;
reg [7:0] addr;
wire finish;
wire [8:0] cpt_bottom;
wire [8:0] cpt_up;
reg [22:0] block_cnt;
reg block_part;

always @(posedge clk) begin
  if (rst == 1'b1) begin
    state <= `IDLE;
    SDctrl_start <= 1'b0;
    data_cpt <= 11'h000;
    fifo_wr <= 1'b0;
    fifo_data <= 16'h8000;
    addr <= 8'h00;
    block_part <= 1'b0;
    block_cnt <= 23'h000000;
    nb_data <= 32'h00000000;
  end
  else begin
    fifo_wr <= 1'b0;

    SDctrl_start <= 1'b0;
    case(state)
      `IDLE: begin
        if (start == 1'b1 && SDctrl_available == 1'b1 && fifo_empty == 1'b1) begin
          state <= `BOOT;
          SDctrl_start <= 1'b1;
          data_cpt <= 11'h000;
          block_cnt <= 23'h000000;
        end
        else begin
          state <= `IDLE;
        end
      end
      `BOOT:begin
        if (SDctrl_valid == 1'b1) begin
          data_cpt <= data_cpt + 1;
          case(data_cpt)
            0+((sample_code+1)<<3): addr[7:0] <= SDctrl_data;
            1+((sample_code+1)<<3): {block_cnt[6:0],block_part} <= SDctrl_data;
            2+((sample_code+1)<<3): block_cnt[14:7] <= SDctrl_data;
            3+((sample_code+1)<<3): block_cnt[22:15] <= SDctrl_data;
            4+((sample_code+1)<<3): nb_data[7:0] <= SDctrl_data;
            5+((sample_code+1)<<3): nb_data[15:8] <= SDctrl_data;
            6+((sample_code+1)<<3): nb_data[23:16] <= SDctrl_data;
            7+((sample_code+1)<<3): nb_data[31:24] <= SDctrl_data;
          endcase
        end
  
        if (SDctrl_available ==1'b1 && SDctrl_start == 1'b0) begin
          state <= `FIRST_FETCH;
          data_cpt <= 11'h000;
          SDctrl_start <= 1'b1;
        end
        else begin
          state <= `BOOT;
        end
      end
      `FIRST_FETCH:
      begin
        if (SDctrl_valid == 1'b1 && finish == 1'b0)begin
          data_cpt <= data_cpt +1;
          
          if ({block_part,data_cpt[7:0]} == 9'h0ff ) begin
            block_part <= ~block_part;
          end
          else if ({block_part,data_cpt[7:0]}== 9'h1ff) begin
            block_cnt <= block_cnt +1;
            block_part <= 1'b0;
          end

          if (cpt_bottom <= data_cpt && data_cpt <= cpt_up) begin
            nb_data <= nb_data -1;
            if (data_cpt[0]==1'b0) begin
               fifo_data[7:0] <= SDctrl_data;
            end
            else begin
               fifo_data[15:8] <= SDctrl_data;
               fifo_wr<= 1'b1;
            end
          end
        end

        if (SDctrl_available ==1'b1 && data_cpt != 10'h000 ) begin
          if (finish == 1'b1) begin
            state <= `IDLE;
          end
          else begin
            state <= `WAIT;
          end
        end
        else begin
          state <= `FIRST_FETCH;
        end
      end
      `FETCH:
      begin
        if (SDctrl_valid == 1'b1 && finish == 1'b0)begin
          data_cpt <= data_cpt +1;
          
          if (cpt_bottom <= data_cpt && data_cpt <= cpt_up) begin
            nb_data <= nb_data -1;
            if (data_cpt[0]==1'b0) begin
               fifo_data[7:0] <= SDctrl_data;
            end
            else begin
               fifo_data[15:8] <= SDctrl_data;
               fifo_wr<= 1'b1;
            end
          end
        end

        if (SDctrl_available ==1'b1 && data_cpt != 10'h000 ) begin
          if (finish == 1'b1) begin
            state <= `IDLE;
          end
          else begin
            state <= `WAIT;
            if (block_part == 1'b1) begin
              block_cnt <= block_cnt +1;
              block_part <= 1'b0;
            end
            else begin
              block_part <= 1'b1;
            end  
          end
        end
        else begin
          state <= `FETCH;
        end
      end
    `WAIT:
    begin
      if (fifo_prog == 1'b0 && SDctrl_start == 1'b0) begin
          SDctrl_start <= 1'b1;
          state <= `FETCH;
          data_cpt <= 10'h000;
      end
      else begin
        state <=`WAIT;
      end
    end
    endcase
  end
end


assign finish = (nb_data == 0 || stop==1'b1)? 1'b1 : 1'b0;
assign SDctrl_address = {block_cnt,9'b000000000} ; 

assign cpt_bottom = (state == `FIRST_FETCH) ? addr[7:0] : 
                     (block_part == 1'b0) ? 9'h00 : 9'h100;

assign cpt_up = (state ==`FIRST_FETCH) ? 512 - addr[7:0] :
                     (block_part == 1'b0) ? 9'hff : 9'h1ff;
                     

initial begin
  state <= `IDLE;
end


endmodule
