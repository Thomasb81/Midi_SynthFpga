`timescale 1ns / 1ps
module synth2(
  input clk96,
  input rst,
  

  output sclk,
  output mosi,
  input miso,
  output cs,


  input note_pressed,
  input note_released,
  input note_keypress,
  input pitch_wheel,
  input [6:0] note,
  input [6:0] velocity,
  input [3:0] channel,
  input [7:0] addr,
  output audio_r, 
  output audio_l,

  output [7:0] data,
  output reg data_valid,

  output [2:0] SDdriver_state,
  output fifo_empty
);

`define MAX_SND_MEM 8'd255
`define DRUM_CHANNEL 4'd9


`define ATTACK 3'd1
`define DECAY 3'd2
`define SUSTAIN 3'd3
`define RELEASE 3'd4
`define BLANK 3'd0

`define SAMPLE_START 3'd0
`define SAMPLE_NOTE_RESOL 3'd1
`define SAMPLE_ADDR_MEM 3'd2
`define SAMPLE_READ 3'd3
`define SAMPLE_WRITE 3'd4

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

reg [2:0] sample_state;

wire [9:0] wavetable_4left;

wire [4:0] dummy_5bits_ctrl;
wire [4:0] dummy_5bits_sample;

wire [17:0] sound_r;
wire [17:0] sound_l;

wire[9:0] note_calculated;
reg [9:0] pitchwhell_reg;
reg [4:0] pitchwhell_chan[0:15];

wire wavetable_left_valid;
wire wavetable_right_valid;

//drum
wire drum0_valid;
wire [15:0] drum0_sample;

// synthesis translate_off

// for debugging

// synthesis translate_on

always @(posedge clk96) begin
 if (rst == 1'b1) begin
     pitchwhell_chan[0] <= 5'b10000;
     pitchwhell_chan[1] <= 5'b10000;
     pitchwhell_chan[2] <= 5'b10000;
     pitchwhell_chan[3] <= 5'b10000;
     pitchwhell_chan[4] <= 5'b10000;
     pitchwhell_chan[5] <= 5'b10000;
     pitchwhell_chan[6] <= 5'b10000;
     pitchwhell_chan[7] <= 5'b10000;
     pitchwhell_chan[8] <= 5'b10000;
     pitchwhell_chan[9] <= 5'b10000;
     pitchwhell_chan[10] <= 5'b10000;
     pitchwhell_chan[11] <= 5'b10000;
     pitchwhell_chan[12] <= 5'b10000;
     pitchwhell_chan[13] <= 5'b10000;
     pitchwhell_chan[14] <= 5'b10000;
     pitchwhell_chan[15] <= 5'b10000;
 end
 else begin
   if (pitch_wheel ==1'b1)
    pitchwhell_chan[channel] <= note[5:1];
 end
end


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

always @(posedge clk96) begin
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
   addr_ctrl <= addr;
   if (note_pressed == 1'b1 || note_released == 1'b1 || note_keypress == 1'b1) begin
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

     else begin // note_released | note_keypress
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
  .clka(clk96), // input clka
  .rsta(rst), // input rsta
  .wea(we_ctrl), // input [0 : 0] wea
  .addra(addr_ctrl), // input [7 : 0] addra
  .dina(datain_ctrl), // input [71 : 0] dina
  .douta(dataout_ctrl), // output [71 : 0] douta
  .clkb(clk96), // input clkb
  .rstb(rst), // input rstb
  .web(we_sample), // input [0 : 0] web
  .addrb(addr_sample[7:0]), // input [7 : 0] addrb
  .dinb(datain_sample), // input [71 : 0] dinb
  .doutb(dataout_sample), // output [71 : 0] doutb
  .ena(1'b1),
  .enb(1'b1)
);

always @(posedge clk96) begin
  if (rst == 1'b1) begin
    pitchwhell_reg <= {5'b00000,5'b10000}; 
  end
  else begin
    pitchwhell_reg <=  {5'b00000,pitchwhell_chan[channel_sample_r]};
  end
end

//assign note_calculated = {note_sample_r,3'b000} + {5'b00000,pitchwhell_chan[channel_sample_r]} -16;
assign note_calculated = {note_sample_r,3'b000} + pitchwhell_reg -16;

freqtable RAMB16_S18 (
    .clk(clk96), 
    .addr(note_calculated), 
    .en(1'b1), 
    .do(wave_advance)
    );

// sample interface

assign {
wavetable_sample_r,
volume_sample_r,
note_sample_r,
channel_sample_r,
velocity_sample_r, // 7 + 17 = 24
note_pressed_sample_r, // 1+16 = 17
note_released_sample_r, // 1+ 15 = 16
adsr_state_sample_r,// 3 + 12 = 15
sustain_sample_r,  // 5+7 = 12
dummy_5bits_sample // 5
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

// count == 666 => 48Khz @ clk == 32Mhz
// count == 2000 => 48khz @ clk == 96Mhz
always @(posedge clk96) begin
  if (rst == 1'b1) begin
    count <= 11'h000;
  end
  else begin
    if (count == 11'd1999)
      count <= 11'h000;
    else
      count <= count +1;
  end
end

assign data = addr_sample;

always @(posedge clk96) begin
  if (rst == 1'b1) begin
    addr_sample <= 8'h00;
    we_sample <= 1'b0;
    sample_state <= `SAMPLE_START;
    wavetable_sample_w <= 19'h00000;
    note_released_sample_w <= 1'b0;
    note_pressed_sample_w <= 1'b0;
    adsr_state_sample_w <= 1'b0;
    volume_sample_w <= 18'h00000;
    sustain_sample_w <= 7'b0000000;
    data_valid <= 1'b0;
  end
  else begin
    we_sample <=1'b0;
    data_valid <= 1'b0;
    case (sample_state)
     `SAMPLE_START : begin
       sample_state <= `SAMPLE_NOTE_RESOL;
     end
     `SAMPLE_NOTE_RESOL : begin
       sample_state <= `SAMPLE_ADDR_MEM;
     end
     `SAMPLE_ADDR_MEM : begin
       sample_state <= `SAMPLE_READ;
       //Next cycle wave_advance will get the correct value
     end
     `SAMPLE_READ : begin
       sample_state <= `SAMPLE_WRITE;
       if (addr_sample <= `MAX_SND_MEM) begin
         we_sample <= 1'b1;
       end
       wavetable_sample_w <= wavetable_sample_r + wave_advance;
       adsr_state_sample_w <= adsr_state;
       note_pressed_sample_w <= note_pressed_cal;
       note_released_sample_w <= note_released_cal;
       volume_sample_w <= volume_cal;
       if (adsr_state == `BLANK && adsr_state_sample_r != `BLANK) begin
         data_valid <= 1'b1;
       end
    end
    `SAMPLE_WRITE : begin
      if (count < 5* `MAX_SND_MEM) begin
        if (addr_sample < `MAX_SND_MEM) begin
          addr_sample <= addr_sample + 1;
          sample_state <= `SAMPLE_START;
        end
      end
      else if (count == 11'd1999) begin
        sample_state <= `SAMPLE_START;
        addr_sample <= 8'h00;
      end
      else
        sample_state <= `SAMPLE_WRITE;
      end
  endcase
  end
end

assign wavetable_4left = wavetable_sample_r[18:9]+256;

assign wavetable_right_valid = (sample_state == `SAMPLE_ADDR_MEM) && channel_sample_r != `DRUM_CHANNEL;
assign wavetable_left_valid =  (sample_state == `SAMPLE_READ) && channel_sample_r != `DRUM_CHANNEL;
assign drum0_valid = count == 11'd1290 || count == 11'd1291 ||count == 11'd1292 ||count == 11'd1292; 


soundgen soundgen0 (
    .clk(clk96), 
    .rst(rst), 
    .wavetable_r(wavetable_sample_r[18:9]), 
    .wavetable_r_valid(wavetable_right_valid), 
    .wavetable_l(wavetable_4left), 
    .wavetable_l_valid(wavetable_left_valid),
    .volume_adsr(volume_sample_r), 
    .velocity({1'b0,velocity_sample_r,10'b0000000000}),
    .tick48k(count==11'd1999), 
    .sound_r(sound_r), 
    .sound_l(sound_l),
    //drum
    .drum_sample0(drum0_sample),
    .drum_sample0_valid(drum0_valid)
    );

dac16 inst_dac16_r (
    .clk(clk96), 
    .rst(rst), 
    .data(sound_r[17:2]), 
    .dac_out(audio_r)
    );

dac16 inst_dac16_l (
    .clk(clk96), 
    .rst(rst), 
    .data(sound_l[17:2]), 
    .dac_out(audio_l)
    );


SDFeed SD_ss0(
.clk96m(clk96),
.rst(rst),

.sclk(sclk),
.mosi(mosi),
.miso(miso),
.cs(cs),

.id({1'b0,note_sample_r}),
//.id(8'h01),
.note_on(note_pressed_sample_r && channel_sample_r == `DRUM_CHANNEL ),
.note_off(note_released_sample_r && channel_sample_r == `DRUM_CHANNEL),
//.note_off(1'b0),
//.note_off(1'b0),
.completed(),

.rd_en(count == 11'd1298),
.data_out(drum0_sample),
.fifo_full(),
.fifo_empty(fifo_empty),
.fifo_halffull(),
.SDdriver_state(SDdriver_state)
);

initial begin
  sample_state <= `SAMPLE_START;
  pitchwhell_reg <= 10'b0000010000;
end

// synthesis translate_off

// for debugging

// synthesis translate_on

endmodule
