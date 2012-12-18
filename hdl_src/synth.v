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
  output[3:0] state,
  input read_back,
  output reg [7:0] data
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

`define CTRL_IDLE 3'd1
`define CTRL_SEARCH_NOTEON 3'd2
`define CTRL_FIND_NOTEON 3'd3
`define CTRL_SEARCH_NOTEOFF 3'd4
`define CTRL_FIND_NOTEOFF 3'd5
`define CTRL_ERROR 3'd6
`define CTRL_WAIT 3'd7
`define CTRL_NXTADDR 3'd0

reg [7:0] addr_ctrl;
reg [7:0] store_addr_ctrl;
reg we_ctrl;
wire [71:0] dataout_ctrl;
wire [71:0] datain_ctrl;

reg [8:0] addr_sample;
reg we_sample;
wire [71:0] dataout_sample;
wire [71:0] datain_sample;

reg [7:0] error_log;
reg [10:0] count;
reg [15:0] count_cmd = 16'h0000;

wire [6:0] note_ctrl_r;
wire [3:0] channel_ctrl_r;
wire [6:0] velocity_ctrl_r;
wire [17:0] volume_ctrl_r;
wire [18:0] wavetable_ctrl_r;
wire note_press_ctrl_r;
wire note_release_ctrl_r;
wire [2:0] adsr_state_ctrl_r;

reg [6:0] note_ctrl_w;
reg [3:0] channel_ctrl_w;
reg [6:0] velocity_ctrl_w;
reg [17:0] volume_ctrl_w;
reg [18:0] wavetable_ctrl_w;
reg note_press_ctrl_w;
reg note_release_ctrl_w;
reg [2:0] adsr_state_ctrl_w;

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
reg [2:0] ctrl_state;

wire [6:0] note_interface_fifoout;
wire [6:0] velocity_fifoout;
wire [3:0] channel_fifoout;
wire note_pressed_fifoout;
wire note_released_fifoout;
wire note_keypress_fifoout;
wire note_channelpress_fifoout;

wire [9:0] wavetable_4left;

wire [11:0] dummy_12bits_ctrl;
wire [11:0] dummy_12bits_sample;

wire [17:0] sound_r;
wire [17:0] sound_l;

always @(posedge clk32) begin
  if (rst == 1'b1) begin
  data <= 8'h00;
  end
  else if (read_back == 1'b1) begin
    if (velocity == 7'h00)
	   data <= count_cmd[15:8];
	 else if (velocity == 7'h01)
	   data <= count_cmd[7:0];
	 else if (velocity == 7'h02)
	   data <= error_log;
	 else
	   data <= 8'h55;
  end
end
  


fifo fifo0 (
  .clk(clk32), // input clk
  .srst(rst), // input srst
  .din({note_interface,velocity,channel,note_pressed,note_released,note_keypress,note_channelpress}), // input [21 : 0] din
  //.wr_en(note_pressed|note_released|note_keypress|note_channelpress), // input wr_en
  .wr_en(note_pressed|note_released), // input wr_en
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

assign state[3] = note_pressed_fifoout;
assign state[2:0] = ctrl_state;

assign {wavetable_ctrl_r,
        volume_ctrl_r,
		  note_ctrl_r,
		  channel_ctrl_r,
		  velocity_ctrl_r,
        note_press_ctrl_r,
		  note_release_ctrl_r,
		  adsr_state_ctrl_r,
		  dummy_12bits_ctrl} = dataout_ctrl;
assign datain_ctrl = {
        wavetable_ctrl_w,
		  volume_ctrl_w,
		  note_ctrl_w,
		  channel_ctrl_w,
		  velocity_ctrl_w,
		  note_press_ctrl_w,
		  note_release_ctrl_w,
		  adsr_state_ctrl_w,
		  12'b111111111111};


always @(posedge clk32) begin
  if (rst == 1'b1) begin
    addr_ctrl <= 8'h00;
	 store_addr_ctrl <= 8'h00;
    we_ctrl <= 1'b0;
	 ctrl_state <= `CTRL_IDLE;
	 error_log <= 8'h00;
	 channel_ctrl_w <= 4'h0;
	 note_ctrl_w <= 7'h00;
	 velocity_ctrl_w <= 7'h00;
	 note_press_ctrl_w <= 1'b0;
	 note_release_ctrl_w <= 1'b0;
	 adsr_state_ctrl_w <= `BLANK;
  end
  else begin
    
    case(ctrl_state)
	 `CTRL_IDLE :
	   begin
	   if (empty == 1'b0 && note_pressed_fifoout == 1'b1) begin
		  ctrl_state <= `CTRL_SEARCH_NOTEON;
		end
		else if (empty == 1'b0 && note_released_fifoout ==1'b1) begin
		  ctrl_state <= `CTRL_SEARCH_NOTEOFF;
		end
		else begin
		  ctrl_state <= `CTRL_IDLE;
		end
		
		if (addr_ctrl == 8'h00)
		  store_addr_ctrl <= 8'b00011111;
      else begin
		  store_addr_ctrl <= addr_ctrl-1;

		end
	 end	
    `CTRL_SEARCH_NOTEON :
	   begin
		  if (addr_ctrl == addr_sample && we_sample == 1'b1) begin
			 ctrl_state <= `CTRL_IDLE; //Need to kill one cycle
		  end
		  else if (addr_ctrl == addr_sample) begin
		    ctrl_state <= `CTRL_SEARCH_NOTEON;
		  end
		  else if (note_ctrl_r == note_interface_fifoout &&
		           channel_ctrl_r == channel_fifoout) begin
			 ctrl_state <= `CTRL_FIND_NOTEON;
		  end
		  else if (adsr_state_ctrl_r == `BLANK && error_log >=1) begin
		    ctrl_state <= `CTRL_FIND_NOTEON;
		  end
		  else if (addr_ctrl != store_addr_ctrl) begin
			 ctrl_state<= `CTRL_NXTADDR;
		  end
		  else begin
		    ctrl_state <= `CTRL_ERROR;
		  end
		end
    `CTRL_FIND_NOTEON :
	   begin
		ctrl_state <= `CTRL_WAIT;
		we_ctrl <= 1'b1;
	   note_ctrl_w <= note_interface_fifoout;
      channel_ctrl_w <= channel_fifoout;
      velocity_ctrl_w <= velocity_fifoout;
      volume_ctrl_w <= 18'h00000;
      wavetable_ctrl_w <= wavetable_ctrl_r;
      note_press_ctrl_w <= 1'b1;
      note_release_ctrl_w <= 1'b0;
      adsr_state_ctrl_w <= `BLANK;
		error_log <= 8'h00;
		count_cmd <= count_cmd + 1;
		end
	 `CTRL_SEARCH_NOTEOFF :
		begin
		  if (addr_ctrl == addr_sample && we_sample == 1'b1) begin
		    ctrl_state <= `CTRL_IDLE; // Need to kill one cycle;
		  end
		  else if (addr_ctrl == addr_sample) begin
		    ctrl_state <= `CTRL_SEARCH_NOTEOFF;
		  end
		  else if (note_ctrl_r == note_interface_fifoout &&
		      channel_ctrl_r == channel_fifoout) begin
		    ctrl_state <= `CTRL_FIND_NOTEOFF;
		  end
		  else if (addr_ctrl != store_addr_ctrl) begin
          ctrl_state <= `CTRL_NXTADDR;
		  end
		  else begin
		    ctrl_state <= `CTRL_ERROR;
		  end
		end 
	 `CTRL_FIND_NOTEOFF :
	   begin
		ctrl_state <= `CTRL_WAIT;
		we_ctrl <= 1'b1;
	   note_ctrl_w <= note_ctrl_r;
      channel_ctrl_w <= channel_ctrl_r;
      velocity_ctrl_w <= velocity_fifoout;
      volume_ctrl_w <= volume_ctrl_r;
      wavetable_ctrl_w <= wavetable_ctrl_r;
      note_press_ctrl_w <= 1'b0;
      note_release_ctrl_w <= 1'b1;
      adsr_state_ctrl_w <= adsr_state_ctrl_r;
      error_log <= 8'h00;
		count_cmd <= count_cmd + 1;
		end
	 `CTRL_ERROR :
	   begin
        if (error_log == 8'hff)		
		    ctrl_state <= `CTRL_ERROR;
		  else begin
		    error_log <= error_log +1;
			 ctrl_state <= `CTRL_IDLE;
/*			 if (addr_sample != 8'd32)
			   addr_ctrl <= addr_sample + 1;
			 else
			   addr_ctrl <= 8'h00;*/
			 
		  end
		end
	 `CTRL_WAIT :
	   begin
		  we_ctrl <= 1'b0;
		  ctrl_state <= `CTRL_IDLE;
		end
	 `CTRL_NXTADDR :
	 begin
	   if (addr_ctrl != 8'd31)
		  addr_ctrl <= addr_ctrl + 1;
		else
		  addr_ctrl <= 8'd0;
		
		if (note_pressed_fifoout == 1'b1)
		  ctrl_state <= `CTRL_SEARCH_NOTEON;
		else if (note_released_fifoout ==1'b1)
		  ctrl_state <= `CTRL_SEARCH_NOTEOFF;
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
.sustain_value(7'b1000000),
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
	                    if (addr_sample <= 9'd31) //32Mhz ->48Khz /667  
	                    begin
							    sample_state <= `SAMPLE_UPNOTE;
							  end
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

assign wavetable_4left = wavetable_sample_r[18:9]+256;

soundgen soundgen0 (
    .clk(clk32), 
    .rst(rst), 
    .wavetable_r(wavetable_sample_r[18:9]), 
    .wavetable_r_valid(sample_state == `SAMPLE_UPNOTE), 
    .wavetable_l(wavetable_4left), 
    .wavetable_l_valid(sample_state == `SAMPLE_READ), 
    .volume(volume_sample_r), 
    .tick48k(count==11'd666), 
    .sound_r(sound_r), 
    .sound_l(sound_l)
    );

dac16 inst_dac16_r (
    .clk(clk32), 
    .rst(rst), 
    .data(sound_r[17:2]), 
    .dac_out(audio_r)
    );

dac16 inst_dac16_l (
    .clk(clk32), 
    .rst(rst), 
    .data(sound_l[17:2]), 
    .dac_out(audio_l)
    );

endmodule
