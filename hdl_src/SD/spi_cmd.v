module spi_cmd(
input clk,
input rst,

input [6:0] cmd,
input [31:0] idata,
input en,
input sclk_fall,

input sclk,
output mosi,
input miso, 

output valid_status,

output reg rdy,

output [6:0] resp_status,
output [7:0] data_out,
output data_out_valid

);


reg [2:0] cpt;

wire [45:0] cmd_message;
wire [7:0] data;
wire [2:0] spi_state;
wire known_cmd;
wire spi_en;
wire valid_status_internal;
reg valid_status_internal_q;
wire cpt_inf6;

reg sclk_q;
reg en_q;
reg [7:0] rsp_message;



`define RECV_IDLE 2'b00
`define RECV_HEADER 2'b01
`define RECV_DATA 2'b10
`define RECV_CRC 2'b11

reg [11:0] recv_cpt;
reg [1:0] recv_state;
reg data_out_valid_q;

assign cmd_message = (cmd == 6'd0) ?  46'h000000000095 :
                     (cmd == 6'd1) ?  46'h010000000095 : //wrong CRC
                     (cmd == 6'd17) ? {6'h11,idata,8'h00} : //wrong CRC
                                      46'hffffffffffff;

assign data = (cpt == 4'd0)  ? {2'b01,cmd_message[45:40]} : 
               (cpt == 4'd1)  ? cmd_message[39:32] :
               (cpt == 4'd2)  ? cmd_message[31:24] :
               (cpt == 4'd3)  ? cmd_message[23:16] :
               (cpt == 4'd4)  ? cmd_message[15:8] :
               (cpt == 4'd5)  ? cmd_message[7:0] : 
               8'hff;

//Send command processus
always @(posedge clk) begin
  if (rst == 1'b1) begin
    cpt <= 0;
  end
  else begin
    if (en_q == 1'b1 ) begin
      if ( sclk_fall == 1'b1) begin
        if (spi_state == 3'b000 && cpt_inf6 == 1'b1)begin
          cpt <= cpt +1;
        end
      end
    end
    else begin
      cpt <= 0;
    end
  end
end

//readback processus
always @(posedge clk) begin 
  if (rst == 1'b1) begin
    rsp_message <= 8'hFF;
  end
  else begin
    if (sclk_q == 1'b0 && sclk == 1'b1) begin
      rsp_message <= {rsp_message[6:0],miso};
    end
  end
end


assign known_cmd = (cmd == 6'd0 || cmd == 6'd1 || cmd == 6'd17 );
assign valid_status_internal = (cpt == 6 && rsp_message[7] ==1'b0 && known_cmd && rdy== 1'b0) ? 1'b1 : 1'b0;

assign resp_status = rsp_message[6:0];
assign valid_status = valid_status_internal_q == 1'b0 && valid_status_internal == 1'b1 && recv_state==`RECV_IDLE; 

//ready handling and valid status
always @(posedge clk) begin
  if (rst == 1'b1) begin
    rdy <= 1'b1;
    en_q <= 1'b0;
    valid_status_internal_q <= 1'b0;
  end
  else begin
    valid_status_internal_q <= valid_status_internal;
    
    if (en == 1'b1) begin
      rdy <= 1'b0; 
    end

    if (rdy == 1'b0) begin
      if (sclk == 1'b0) begin
        en_q <= 1'b1;
      end
    end


    
    if ((cmd == 6'd0 || cmd == 6'd1)  && cpt == 6 && valid_status == 1'b1 ) begin
      rdy <= 1'b1;
      en_q <= 1'b0;
    end
    else if ((cmd == 6'd17)  && recv_state == `RECV_CRC && recv_cpt[4] == 1'b1) begin
      rdy <= 1'b1;
      en_q <= 1'b0;
    end
  end
end



// Handle edge detection on sclk
always @(posedge clk) begin
  if (rst == 1'b1) begin
    sclk_q <= 1'b1;
  end
  else begin
    sclk_q <= sclk;
  end 
end

assign spi_en = en_q && (cpt_inf6 == 1'b1);
assign cpt_inf6 = (cpt < 6)? 1'b1 : 1'b0;

spi spi0 (
.clk(clk),
.rst(rst),
.sclk_fall(sclk_fall),
.en(spi_en),
.byte_idata(data),

.mosi(mosi),

.state(spi_state)

);

/* Receiver part */


always @(posedge clk) begin 
  if (rst == 1'b1) begin
    recv_state <= `RECV_IDLE;
    recv_cpt <= 0;
    data_out_valid_q <= 0;
  end
  else begin

    if ((data_out_valid == 1'b1 || data_out_valid_q==1'b1) && recv_cpt[2:0] == 3'b111 && recv_state == `RECV_DATA ) begin
      data_out_valid_q <= 1'b1;
    end
    else begin
      data_out_valid_q <= 1'b0;
    end

    
    if (sclk_q == 1'b0 && sclk == 1'b1) begin
       case(recv_state)
       `RECV_IDLE: begin
         if (cmd == 6'd17 && rsp_message[7] == 1'b0 && valid_status_internal == 1'b1) begin
         recv_cpt <= 0;
         recv_state <=`RECV_HEADER;
         end
       end
       `RECV_HEADER: begin
       if (rsp_message[7:0] == 8'hfe) begin
         recv_state <= `RECV_DATA;
       end
       end
       `RECV_DATA: begin
       if (recv_cpt == 12'b111111111111) begin
         recv_cpt <=0;
         recv_state <= `RECV_CRC;
       end
       else begin
         recv_cpt <= recv_cpt + 1;
       end
       end
       `RECV_CRC:begin
       if (recv_cpt[4:0] == 5'b10000) begin
         recv_cpt <=0;
         recv_state <= `RECV_IDLE;
       end
       else begin
         recv_cpt <= recv_cpt + 1;
       end
       end
       endcase
    end
  end
end

assign data_out = rsp_message[7:0];
assign data_out_valid = data_out_valid_q == 1'b0 && recv_cpt[2:0] == 3'b111 && recv_state == `RECV_DATA;

initial begin
  recv_state <= `RECV_IDLE;
end

endmodule
