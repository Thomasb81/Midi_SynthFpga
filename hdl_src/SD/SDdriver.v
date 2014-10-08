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

/*
* SD Driver module read an entry at the beginning of the memory card relatif
* to sample code. Then fetch a first block of data until it is align on 512
* byte. 512 byte => 256 samples.
 */

`define IDLE 3'b000
`define BOOT 3'b001
`define FIRST_FETCH 3'b100
`define FETCH 3'b010
`define WAIT 3'b011

reg [10:0] data_cpt;
reg [7:0] addr;
reg [22:0] block_cnt;
reg block_part;
reg [7:0] sample_code_latch;

wire finish;
wire [8:0] cpt_bottom;
wire state_end;
reg state_end_latch;
reg SDctrl_available_latch;

// State transition
always @(posedge clk) begin

  if(rst == 1'b1) begin
    state <= `IDLE;
    block_cnt <= 23'h000000;
    nb_data <= 32'h00000000;
    data_cpt <= 11'h000;
    addr <= 8'h00;
    block_part <= 1'b0;
    sample_code_latch <= 8'h00;

  end
  else begin
    fifo_wr <= 1'b0;
    SDctrl_start <= 1'b0;

    case(state)
    `IDLE: begin
      if (start == 1'b1 && SDctrl_available == 1'b1 && SDctrl_available_latch == 1'b1) begin
        state <= `BOOT;
        SDctrl_start <= 1'b1;
        data_cpt <= 11'h000;
        block_cnt <= 23'h000000;
	sample_code_latch <= sample_code+1;
      end
      else begin
        state <= `IDLE;
      end
    end

    `BOOT: begin
      if (fifo_empty == 1'b1 & state_end_latch == 1'b1 & SDctrl_available == 1'b1 && SDctrl_available_latch == 1'b1) begin
	state <= `FIRST_FETCH;
	data_cpt <= 11'h000;
	SDctrl_start <= 1'b1;
      end
      else begin
	state <= `BOOT;
	if (SDctrl_valid == 1'b1 ) begin
	  data_cpt <= data_cpt +1;
	  case(data_cpt)
            0+((sample_code_latch)<<3): addr[7:0] <= SDctrl_data;
            1+((sample_code_latch)<<3): {block_cnt[6:0],block_part} <= SDctrl_data;
            2+((sample_code_latch)<<3): block_cnt[14:7] <= SDctrl_data;
            3+((sample_code_latch)<<3): block_cnt[22:15] <= SDctrl_data;
            4+((sample_code_latch)<<3): nb_data[7:0] <= SDctrl_data;
            5+((sample_code_latch)<<3): nb_data[15:8] <= SDctrl_data;
            6+((sample_code_latch)<<3): nb_data[23:16] <= SDctrl_data;
            7+((sample_code_latch)<<3): nb_data[31:24] <= SDctrl_data;
	  endcase
	end
      end
    end

    `FIRST_FETCH: begin
      if (finish ==  1'b1)begin
        state <= `IDLE;
      end
      else if (SDctrl_available == 1'b1 &&SDctrl_available_latch == 1'b1 && state_end_latch == 1'b1) begin
	state <= `WAIT;
      end
      else begin
	state <= `FIRST_FETCH;
	if (SDctrl_valid == 1'b1 ) begin
	  data_cpt <= data_cpt + 1;
	  //handle address
	  if (data_cpt==11'h1ff) begin
	    block_cnt <= block_cnt +1;
	  end
	  //handle data
	  if (cpt_bottom <= data_cpt ) begin
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
      end
    end

    `FETCH: begin
      if (finish ==  1'b1 && state_end_latch == 1'b1)begin
        state <= `IDLE;
      end
      else if ( finish == 1'b0 && state_end_latch == 1'b1) begin
	state <= `WAIT;
	//address for next fetch
	block_part <= ~block_part;
	if (block_part == 1'b1) begin
	  block_cnt <= block_cnt + 1;
        end
      end
      else begin
	state <= `FETCH;
	if (SDctrl_valid == 1'b1 ) begin
	  data_cpt <= data_cpt + 1;
	  //handle address
	  //handle data
	  if (cpt_bottom <= data_cpt ) begin
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
      end
    end

    `WAIT:begin
      if (finish ==  1'b1)begin
        state <= `IDLE;
      end
      else if (fifo_prog == 1'b1 && SDctrl_available == 1'b1 && SDctrl_available_latch == 1'b1) begin
	state <= `FETCH;
        SDctrl_start <= 1'b1;
	data_cpt <= 11'h000;
      end
      else begin
	state <= `WAIT;
      end
    end

    endcase

  end

end

assign finish = (nb_data == 0 || stop==1'b1)? 1'b1 : 1'b0;
assign SDctrl_address = {block_cnt,9'b000000000} ; 

assign cpt_bottom = (state == `FIRST_FETCH) ? {block_part,addr[7:0]} : {block_part,8'h00}; 

assign state_end = (state == `BOOT && data_cpt == 7+((sample_code_latch)<<3) +1) ||
	           (state == `FIRST_FETCH && data_cpt == 11'h1ff) || 
		   (state == `FETCH && block_part == 1'b0 && data_cpt == 11'h0ff) ||
		   (state == `FETCH && block_part == 1'b1 && data_cpt == 11'h1ff) ||
		   finish;

always @(posedge clk) begin

  if(rst == 1'b1) begin
    state_end_latch <= 1'b0;
    SDctrl_available_latch <= 1'b0;
  end
  else begin
    SDctrl_available_latch <= SDctrl_available;

    if ((state == `BOOT && state_end == 1'b1) ||
       (state == `FIRST_FETCH && state_end == 1'b1) ||
       (state == `FETCH && state_end == 1'b1) 
       )
    begin
      state_end_latch <= 1'b1; 
    end
    else if (SDctrl_available_latch == 1'b1 ) begin
      state_end_latch <= 1'b0;
    end
  end
end

endmodule
