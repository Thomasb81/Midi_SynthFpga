module SDFeed (
input clk96m,
input rst,

output sclk,
output mosi,
input miso,
output cs,

input [6:0] id,

input note_on,
input note_off,
output completed,

input rd_en,
output [15:0] data_out

);

wire [31:0] sd_address;
wire SDctrl_start;
wire rdy_w;
wire [7:0] data_driver;
wire data_driver_valid;
wire fifo_empty;
wire fifo_halffull;
wire [15:0] fifo_data_in;
wire fifo_wr_en;

SDctrl SDctrl0(
.clk(clk96m),
.rst(rst),

.sclk(sclk),
.mosi(mosi),
.miso(miso),
.cs(cs),

.cmd(),
.address(sd_address),
.en( SDctrl_start ),

.valid_status(),
.resp_status(),
.rdy(rdy_w),

.data_out(data_driver),
.data_out_valid(data_driver_valid)

);

SDdriver SDdriver0(
.clk(clk96m),
.rst(rst),
.start(note_on),
.stop(note_off),
.sample_code({1'b0,id}),
.fifo_empty(fifo_empty),
.fifo_prog(fifo_halffull),
.fifo_wr(fifo_wr_en),
.fifo_data(fifo_data_in),

.SDctrl_data(data_driver),
.SDctrl_valid(data_driver_valid),
.SDctrl_available(rdy_w),

.SDctrl_address(sd_address),
.SDctrl_start(SDctrl_start),
.state(),
.nb_data()

);


fifo_256w fifo0(
.clk(clk96m),
.srst(rst),
.din(fifo_data_in),
.wr_en(fifo_wr_en),
.rd_en(rd_en),
.dout(data_out),
.full(),
.empty(fifo_empty),
.prog_full(fifo_halffull)
);






endmodule
