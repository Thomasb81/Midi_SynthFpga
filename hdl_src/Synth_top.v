module Synth_top(osc_in,nreset,usb_rx,usb_tx,audio_r,audio_l,led1,led2,led3,led4);

input osc_in;
input nreset;
output usb_rx; // connected to fpga_uart_tx
input usb_tx; // connected to fpga_uart_rx
output audio_r;
output audio_l;
output led1;
output led2;
output led3;
output led4;


wire clk96m;
wire clk32;
wire [7:0] data;
wire [7:0] data_resync;
wire valid_data;
wire valid_data_resync;

wire [6:0] note;
wire [6:0] velocity;
wire note_pressed;
wire note_released;
wire note_keypress;
wire [3:0] channel;
wire read;
wire read_resync;
wire [7:0] data_w, data_w_resync;
wire [7:0] addr;

wire rst;
wire rst_cmd;
reg [3:0] rst_cpt;


DCM0 clk_builder0 (
    .CLKIN_IN(osc_in), 
    .CLKFX_OUT(clk96m), 
    .CLK0_OUT(clk32)
    );
	 
synth2 synth0 (
    .clk32(clk32), 
    .rst(rst),
    .note_pressed(note_pressed), 
    .note_released(note_released),
    .note_keypress(note_keypress),
    .note(note), 
    .velocity(velocity),
    .channel(channel),
    .addr(addr),	 
    .audio_r(audio_r),
    .audio_l(audio_l)

);

assign read = 1'b0;
assign data_w = 8'h00;

resync_data resync_valid0 (
    .rst(rst),
    .clkA(clk96m), 
    .validA(valid_data), 
    .dataA(data), 
    .clkB(clk32), 
    .validB(valid_data_resync), 
    .dataB(data_resync)
);
	 
resync_data resync_valid1 (    
    .rst(rst),
    .clkA(clk32), 
    .validA(read), 
    .dataA(data_w), 
    .clkB(clk96m), 
    .validB(read_resync), 
    .dataB(data_w_resync)
);
	 
	 
uart_ss uart_ss0 (
    .rst(rst),
    .clk96(clk96m), 
    .usb_rx(usb_tx),
    .usb_tx(usb_rx),	 
    .data(data),
    .valid_data(valid_data),
    .write_data(read_resync),
    .di(data_w_resync)
);

assign led1 = data[0] | data[1];
assign led2 = data[2] | data[3];
assign led3 = data[4] | data[5];
assign led4 = data[6] | data[7];




midi_ctrl midi_ctrl (
    .clk(clk32), 
    .rst(rst), 
    .valid_byte(valid_data_resync), 
    .data(data_resync), 
    .note_presse(note_pressed), 
    .note_release(note_released),
    .note_keypress(note_keypress),
    .note(note), 
    .velocity(velocity),
    .channel(channel),	 
    .rst_cmd(rst_cmd),
    .addr(addr)
);

//assign led4 = (velocity == 7'b0000000)? 1 : 0;

// Reset part ! close your eyes or you will be chocked :)
always @(posedge clk96m) begin
  if (rst_cmd == 1'b1)
    rst_cpt <= 4'b0000;
  if (rst_cpt != 4'b1111)
    rst_cpt <= rst_cpt+1;
end
	 
assign rst = (rst_cpt == 4'b1111) ? 1'b0 : 1'b1;

initial begin
  rst_cpt <= 4'b0000;
  
end
	 
endmodule
