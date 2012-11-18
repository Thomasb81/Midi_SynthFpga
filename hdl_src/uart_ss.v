`timescale 1ns / 1ps
module uart_ss(
    input rst,
    input clk96,
    input usb_rx,
	 output usb_tx,
	 output reg [7:0] data,
	 output valid_data,
	 input write_data,
	 input [7:0] di
    );

reg en_16_x_baud;
wire [7:0]data_out;
wire buffer_data_present;


assign valid_data = buffer_data_present;

uart_rx uart_rx_inst (
    .serial_in(usb_rx), 
    .data_out(data_out), 
    .read_buffer(1'b1), 
    .reset_buffer(rst), 
    .en_16_x_baud(en_16_x_baud), 
    .buffer_data_present(buffer_data_present), 
    .buffer_full(), 
    .buffer_half_full(), 
    .clk(clk96)
    );

uart_tx uart_tx_inst (
    .data_in(di), 
    .write_buffer(write_data), 
    .reset_buffer(rst), 
    .en_16_x_baud(en_16_x_baud), 
    .serial_out(usb_tx), 
    .buffer_full(), 
    .buffer_half_full(), 
    .clk(clk96)
    );

initial begin
en_16_x_baud <= 1'b0;
end

always @(posedge clk96) begin
  if (buffer_data_present) begin
    data <= data_out;
  end
  en_16_x_baud <= ~ en_16_x_baud;
end


endmodule
