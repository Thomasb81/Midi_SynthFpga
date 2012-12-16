`timescale 1ns / 1ps
module synth2(
  input clk32,
  input rst,
  input note_pressed,
  input note_released,
  input note_keypress,
  input note_channelpress,
  input [6:0] note_interface,
  input [6:0] velocity,
  input [3:0] channel,
  output audio_r, 
  output audio_l,
  output [2:0] state,
  input read_back,
  output [7:0] data
);

`define ATTACK 3'd1
`define DECAY 3'd2
`define SUSTAIN 3'd3
`define RELEASE 3'd4
`define BLANK 3'd0

`define SAMPLE_NEWADDR 2'd0
`define SAMPLE_UPNOTE 2'd1
`define SAMPLE_READ 2'd2
`define SAMPLE_WRITE 2'd3

`define CTRL_IDLE 2'd0
`define CTRL_SEARCH_SET_ADDR 2'd1
`define CTRL_SEARCH_WRITE_ADDR 2'd2


reg [7:0] addr_ctrl;
reg we_ctrl;
wire [71:0] dataout_ctrl;
wire [71:0] datain_ctrl;

reg [8:0] addr_sample;
reg we_sample;
wire [71:0] dataout_sample;
wire [71:0] datain_sample;

reg [10:0] count;

wire [6:0] note_ctrl;
wire [3:0] channel_ctrl;
wire [6:0] velocity_ctrl;
wire [17:0] volume_ctrl;
wire [18:0] wavetable_ctrl;
wire note_press_ctrl;
wire note_release_ctrl;
wire [2:0] adsr_state_ctrl;

wire [6:0] note_sample_r;
wire [3:0] channel_sample_r;
wire [6:0] velocity_sample_r;
wire [17:0] volume_sample_r;
wire [18:0] wavetable_sample_r;
wire note_pressed_sample_r;
wire note_released_sample_r;
wire [2:0] adsr_state_sample_r;
reg [17:0] volume_sample_w;
reg [18:0] wavetable_sample_w;
reg note_pressed_sample_w;
reg note_released_sample_w;
reg [2:0] adsr_state_sample_w;


wire [17:0] wave_advance;
wire [2:0] adsr_state;
wire note_pressed_cal;
wire note_released_cal;
wire [17:0] volume_cal;

reg [1:0] sample_state;
reg [1:0] ctrl_state;


wire [6:0] note_interface_fifoout;
wire [6:0] velocity_fifoout;
wire [3:0] channel_fifoout;
wire note_pressed_fifoout;
wire note_released_fifoout;
wire note_keypress_fifoout;
wire note_channelpress_fifoout;

wire [11:0] dummy_12bits_ctrl;
wire [11:0] dummy_12bits_sample;

fifo fifo0 (
  .clk(clk32), // input clk
  .srst(rst), // input srst
  .din({note_interface,velocity,channel,note_pressed,note_released,note_keypress,note_channelpress}), // input [21 : 0] din
  .wr_en(note_pressed|note_released|note_keypress|note_channelpress), // input wr_en
  .rd_en(we_ctrl), // input rd_en
  .dout(
  {note_interface_fifoout,
   velocity_fifoout,
	channel_fifoout,
	note_pressed_fifoout,
	note_released_fifoout,
	note_keypress_fifoout,
	note_channelpress_fifoout}), // output [21 : 0] dout
  .full(full), // output full
  .overflow(overflow), // output overflow
  .empty(empty) // output empty
);


assign {wavetable_ctrl,
        volume_ctrl,
		  note_ctrl,
		  channel_ctrl,
		  velocity_ctrl,
        note_press_ctrl,
		  note_release_ctrl,
		  adsr_state_ctrl,
		  dummy_12bits_ctrl} = dataout_ctrl;
assign datain_ctrl = {
        wavetable_ctrl,
		  volume_ctrl,
		  note_interface_fifoout,
		  channel_fifoout,
		  velocity_fifoout,
		  note_pressed_fifoout,
		  note_released_fifoout,
		  adsr_state_ctrl,12'b111111111111};


always @(posedge clk32) begin
  if (rst == 1'b1) begin
    addr_ctrl <= 8'hff;
    we_ctrl <= 1'b0;
	 ctrl_state <= `CTRL_IDLE;
  end
  else begin
    we_ctrl <= 1'b0;
    case(ctrl_state)
	 `CTRL_IDLE :
	    if (empty == 1'b0 && we_ctrl == 1'b0) 
		   ctrl_state <= `CTRL_SEARCH_WRITE_ADDR;
    `CTRL_SEARCH_SET_ADDR :
	   begin
		  ctrl_state <= `CTRL_SEARCH_WRITE_ADDR;
      end		
    `CTRL_SEARCH_WRITE_ADDR :
	   begin
		  if ((note_pressed_fifoout == 1'b1 && 
		       adsr_state_ctrl == `BLANK &&
             note_press_ctrl == 1'b0 ) ||
				(note_released_fifoout == 1'b1 &&
				 note_ctrl == note_interface_fifoout &&
				 channel_ctrl == channel_fifoout)
				) 
		  begin
          we_ctrl <= 1'b1;
			 ctrl_state <= `CTRL_IDLE;
		  end
        else begin
          addr_ctrl <= addr_ctrl + 1;
			 ctrl_state <= `CTRL_SEARCH_SET_ADDR;
		  end		  
		end
	 endcase 
   
  end
end

DP_ram DP_ram0 (
  .clka(clk32), // input clka
  .rsta(rst), // input rsta
  .wea(we_ctrl), // input [0 : 0] wea
  .addra(addr_ctrl), // input [7 : 0] addra
  .dina(datain_ctrl), // input [71 : 0] dina
  .douta(dataout_ctrl), // output [71 : 0] douta
  .clkb(clk32), // input clkb
  .rstb(rst), // input rstb
  .web(we_sample), // input [0 : 0] web
  .addrb(addr_sample[7:0]), // input [7 : 0] addrb
  .dinb(datain_sample), // input [71 : 0] dinb
  .doutb(dataout_sample) // output [71 : 0] doutb
);

freqtable RAMB16_S18 (
    .clk(clk32), 
    .addr({3'b000,note_sample_r}), 
    .en(1'b1), 
    .do(wave_advance)
    );


// sample interface

assign {wavetable_sample_r,
        volume_sample_r,
		  note_sample_r,
		  channel_sample_r,
		  velocity_sample_r,
        note_pressed_sample_r,
		  note_released_sample_r,
		  adsr_state_sample_r,dummy_12bits_sample} = dataout_sample;

assign datain_sample = {
        wavetable_sample_w,
		  volume_sample_w,
		  note_sample_r,
		  channel_sample_r,
		  velocity_sample_r,
		  note_pressed_sample_w,
		  note_released_sample_w,
		  adsr_state_sample_w,dummy_12bits_sample};

adsr_mngt2 adsr_mngt2_0(
.sustain_value(7'b0001000),
.attack_rate(velocity_sample_r),
.decay_rate(7'b0100000),
.release_rate(7'b0001000),
.i_state(adsr_state_sample_r),
.i_volume(volume_sample_r),
.i_note_pressed(note_pressed_sample_r),
.i_note_released(note_released_sample_r),
.o_state(adsr_state),
.o_note_pressed(note_pressed_cal),
.o_note_released(note_released_cal),
.o_volume(volume_cal)
);


always @(posedge clk32) begin
  if (rst == 1'b1) begin
    addr_sample <= 9'h000;
    we_sample <= 1'b0;
    sample_state <= `SAMPLE_NEWADDR;
	 wavetable_sample_w <= 19'h00000;
	 note_released_sample_w <= 1'b0;
	 note_pressed_sample_w <= 1'b0;
	 adsr_state_sample_w <= 1'b0;
	 volume_sample_w <= 18'h00000;
	 count <= 11'h000;
  end
  else begin
     we_sample <= 1'b0;
	  
	  // Count == 667 at 32Mhz to get 48Khz
	  if (count >= 11'd666) begin
	    count <= 10'd0;
		 addr_sample <= 9'd0;
       sample_state <= `SAMPLE_NEWADDR;		 
	  end
	  else
	    count <= count + 1;
	  
	  case (sample_state)
	  `SAMPLE_NEWADDR : begin
	                    if (addr_sample <= 165) //32Mhz ->48Khz /667  
	                      sample_state <= `SAMPLE_UPNOTE;
							  //else stay here
	                    end
	  `SAMPLE_UPNOTE : begin
	                   sample_state <= `SAMPLE_READ;
							 //Next cycle wave_advance will get the correct value
	                   end
	  `SAMPLE_READ : begin
	                 sample_state <= `SAMPLE_WRITE;
						  we_sample <= 1'b1;
						  wavetable_sample_w <= wavetable_sample_r + wave_advance;
                    adsr_state_sample_w <= adsr_state;
                    note_pressed_sample_w <= note_pressed_cal;
                    note_released_sample_w <= note_released_cal;
                    volume_sample_w <= volume_cal;
	                 end
	  `SAMPLE_WRITE : begin
	                  sample_state <= `SAMPLE_NEWADDR;
							we_sample <=1'b0;
							addr_sample <= addr_sample +1;
	                  end
	  endcase
	  
	  
  end
end

endmodule
