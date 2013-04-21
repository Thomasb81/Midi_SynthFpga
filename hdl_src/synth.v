`timescale 1ns / 1ps
module synth2(
  input clk32,
  input rst,
  input note_pressed,
  input note_released,
  input note_keypress,
  input [6:0] note,
  input [6:0] velocity,
  input [3:0] channel,
  input [7:0] addr,
  output audio_r, 
  output audio_l
);

`define MAX_SND_MEM 8'd128

`define ATTACK 3'd1
`define DECAY 3'd2
`define SUSTAIN 3'd3
`define RELEASE 3'd4
`define BLANK 3'd0

`define SAMPLE_NEWADDR 2'd0
`define SAMPLE_UPNOTE 2'd1
`define SAMPLE_READ 2'd2
`define SAMPLE_WRITE 2'd3

reg [7:0] addr_ctrl;
reg [7:0] store_addr_ctrl;
reg we_ctrl;
wire [71:0] dataout_ctrl;
wire [71:0] datain_ctrl;

reg [7:0] addr_sample;
reg we_sample;
wire [71:0] dataout_sample;
wire [71:0] datain_sample;

reg [10:0] count;

wire [6:0] note_ctrl_r;
wire [3:0] channel_ctrl_r;
wire [6:0] velocity_ctrl_r;
wire [6:0] sustain_ctrl_r;
wire [17:0] volume_ctrl_r;
wire [18:0] wavetable_ctrl_r;
wire note_press_ctrl_r;
wire note_release_ctrl_r;
wire [2:0] adsr_state_ctrl_r;

reg [6:0] note_ctrl_w;
reg [3:0] channel_ctrl_w;
reg [6:0] velocity_ctrl_w;
reg [6:0] sustain_ctrl_w;
reg [17:0] volume_ctrl_w;
reg [18:0] wavetable_ctrl_w;
reg note_press_ctrl_w;
reg note_release_ctrl_w;
reg [2:0] adsr_state_ctrl_w;

wire [6:0] note_sample_r;
wire [3:0] channel_sample_r;
wire [6:0] velocity_sample_r;
wire [6:0] sustain_sample_r;
wire [17:0] volume_sample_r;
wire [18:0] wavetable_sample_r;
wire note_pressed_sample_r;
wire note_released_sample_r;
wire [2:0] adsr_state_sample_r;
reg [17:0] volume_sample_w;
reg [6:0] sustain_sample_w;
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

wire [9:0] wavetable_4left;

wire [4:0] dummy_5bits_ctrl;
wire [4:0] dummy_5bits_sample;

wire [17:0] sound_r;
wire [17:0] sound_l;

// synthesis translate_off

// for debugging

// synthesis translate_on


assign {
wavetable_ctrl_r,
volume_ctrl_r,
note_ctrl_r,
channel_ctrl_r,
velocity_ctrl_r,
note_press_ctrl_r,
note_release_ctrl_r,
adsr_state_ctrl_r,
sustain_ctrl_r,
dummy_5bits_ctrl
} = dataout_ctrl;

assign datain_ctrl = {
wavetable_ctrl_w,
volume_ctrl_w,
note_ctrl_w,
channel_ctrl_w,
velocity_ctrl_w,
note_press_ctrl_w,
note_release_ctrl_w,
adsr_state_ctrl_w,
sustain_ctrl_w,
5'b11111};

always @(posedge clk32) begin
 if (rst == 1'b1) begin
   channel_ctrl_w <= 4'h0;
   note_ctrl_w <= 7'h00;
   velocity_ctrl_w <= 7'h00;
   note_press_ctrl_w <= 1'b0;
   note_release_ctrl_w <= 1'b0;
   adsr_state_ctrl_w <= `BLANK;
   addr_ctrl <= 8'h00;
   sustain_ctrl_w <= 7'b0100000;
   wavetable_ctrl_w <= 19'h00000;
 end
 else begin
   if (note_pressed == 1'b1 || note_released == 1'b1) begin
     addr_ctrl <= addr;
     we_ctrl <= 1'b1;
     note_press_ctrl_w <= note_pressed;
     note_release_ctrl_w <= note_released;
     velocity_ctrl_w <= velocity;
     if (note_pressed == 1'b1) begin
       note_ctrl_w <= note;
       channel_ctrl_w <= channel;
       volume_ctrl_w <= 18'h00000;
       adsr_state_ctrl_w <= `BLANK; 
     end
     else begin // note_released
       note_ctrl_w <= note;
       channel_ctrl_w <= channel;
       volume_ctrl_w <= volume_ctrl_r;
       adsr_state_ctrl_w <= adsr_state_ctrl_r;
     end
   end
   else begin
     we_ctrl <= 1'b0;
   end
   
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
  .doutb(dataout_sample), // output [71 : 0] doutb
  .ena(1'b1),
  .enb(1'b1)
);

freqtable RAMB16_S18 (
    .clk(clk32), 
    .addr({3'b000,note_sample_r}), 
    .en(1'b1), 
    .do(wave_advance)
    );


// sample interface

assign {
wavetable_sample_r,
volume_sample_r,
note_sample_r,
channel_sample_r,
velocity_sample_r,
note_pressed_sample_r,
note_released_sample_r,
adsr_state_sample_r,
sustain_sample_r,
dummy_5bits_sample
} = dataout_sample;

assign datain_sample = {
wavetable_sample_w,
volume_sample_w,
note_sample_r,
channel_sample_r,
velocity_sample_r,
note_pressed_sample_w,
note_released_sample_w,
adsr_state_sample_w,
sustain_sample_r,
dummy_5bits_sample};

adsr_mngt2 adsr_mngt2_0(
//.velocity_value(velocity_sample_r),
.sustain_value(sustain_sample_r),
.attack_rate(7'b0100000),
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

// count == 666 => 48Khz @ clk32 == 32Mhz
always @(posedge clk32) begin
  if (rst == 1'b1) begin
    count <= 11'h000;
  end
  else begin
    if (count <= 11'd666)
	   count <= count +1;
	 else
	   count <= 11'h000;
  end
end


always @(posedge clk32) begin
  if (rst == 1'b1) begin
    addr_sample <= 8'h00;
    we_sample <= 1'b0;
    sample_state <= `SAMPLE_NEWADDR;
    wavetable_sample_w <= 19'h00000;
    note_released_sample_w <= 1'b0;
    note_pressed_sample_w <= 1'b0;
    adsr_state_sample_w <= 1'b0;
    volume_sample_w <= 18'h00000;
    sustain_sample_w <= 7'b0000000;
  end
  else begin
    case (sample_state)
     `SAMPLE_NEWADDR : begin
       sample_state<= `SAMPLE_UPNOTE;
     end
     `SAMPLE_UPNOTE : begin
       sample_state <= `SAMPLE_READ;
       //Next cycle wave_advance will get the correct value
     end
     `SAMPLE_READ : begin
       sample_state <= `SAMPLE_WRITE;
       if (addr_sample <= `MAX_SND_MEM)
         we_sample <= 1'b1;
       else
         we_sample <= 1'b0;
       wavetable_sample_w <= wavetable_sample_r + wave_advance;
       adsr_state_sample_w <= adsr_state;
       note_pressed_sample_w <= note_pressed_cal;
       note_released_sample_w <= note_released_cal;
       volume_sample_w <= volume_cal;
    end
    `SAMPLE_WRITE : begin
      we_sample <=1'b0;
      if (count < 4* `MAX_SND_MEM) begin
        if (addr_sample < `MAX_SND_MEM) begin
          addr_sample <= addr_sample + 1;
          sample_state <= `SAMPLE_NEWADDR;
        end
      end
      else if (count == 11'd666) begin
        sample_state <= `SAMPLE_NEWADDR;
        addr_sample <= 8'h00;
      end
      else
        sample_state <= `SAMPLE_WRITE;
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

// synthesis translate_off

// for debugging

// synthesis translate_on

endmodule
