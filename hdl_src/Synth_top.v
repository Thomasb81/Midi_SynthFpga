module Synth_top(osc_in,usb_rx,usb_tx,audio_r,audio_l,led1,led2,led3,led4);

input osc_in;
output usb_rx; // connected to fpga_uart_tx
input usb_tx; // connected to fpga_uart_rx
output audio_r;
output audio_l;
output reg led1;
output reg led2;
output reg led3;
output reg led4;


wire clk96m;
wire clk32;
wire [7:0] data;
wire valid_data;

wire [6:0] note;
wire [6:0] velocity;
wire note_pressed;
wire note_released;
wire note_keypress;
wire pitch_wheel;
wire [3:0] channel;
wire read;
wire [7:0] data_w_resync;
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
    .clk(clk96m), 
    .rst(rst),
    .note_pressed(note_pressed), 
    .note_released(note_released),
    .note_keypress(note_keypress),
    .pitch_wheel(pitch_wheel),
    .note(note), 
    .velocity(velocity),
    .channel(channel),
    .addr(addr),	 
    .audio_r(audio_r),
    .audio_l(audio_l)

);

assign read = 1'b0;
assign data_w = 8'h00;

uart_ss uart_ss0 (
    .rst(rst),
    .clk96(clk96m), 
    .usb_rx(usb_tx),
    .usb_tx(usb_rx),	 
    .data(data),
    .valid_data(valid_data),
    .write_data(1'b0),
    .di(8'h00)
);

/*
assign led1 = data[0] | data[1];
assign led2 = data[2] | data[3];
assign led3 = data[4] | data[5];
assign led4 = data[6] | data[7];
*/

always @(posedge clk96m) begin
  if (pitch_wheel == 1'b1) begin
  led4 <= note[5];
  led3 <= note[4];
  led2 <= note[3];
  led1 <= note[2];
  end
end



midi_ctrl midi_ctrl (
    .clk(clk96m), 
    .rst(rst), 
    .valid_byte(valid_data), 
    .data(data), 
    .note_presse(note_pressed), 
    .note_release(note_released),
    .note_keypress(note_keypress),
    .pitch_wheel(pitch_wheel),
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
