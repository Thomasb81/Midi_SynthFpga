`timescale 1ns / 1ps
module adsr_mngt2(
    input [6:0] i_sustain_value,
    input [6:0] i_attack_rate,
    input [6:0] i_decay_rate,
    input [6:0] i_release_rate,
    input [2:0] i_state,
    input [17:0] i_volume,
    input i_note_pressed,
    input i_note_released,
    input [3:0] i_channel,
    input i_fifo_empty,
    output [2:0] o_state,
    output o_note_pressed,
    output o_note_released,
    output [17:0] o_volume
    );

parameter DRUM_CHANNEL = 9;


`define ATTACK 3'd1
`define DECAY 3'd2
`define SUSTAIN 3'd3
`define RELEASE 3'd4
`define BLANK 3'd0

`define VOLUME_RESET 18'h00000
//`define VOLUME_RESET 18'h00800
//`define VOLUME_MAX 18'h01000
`define VOLUME_MAX 18'h1FFFF

wire [17:0] sustain_value_internal;

assign sustain_value_internal = {1'b0,i_sustain_value,10'b0000000000};

/*
assign o_note_pressed = (i_state == `ATTACK && i_note_pressed == 1'b1) ? 1'b0 : i_note_pressed;
assign o_note_released = ((i_state == `RELEASE || i_state == `BLANK) && i_note_released == 1'b1) ?
                         1'b0 : i_note_released; 
*/
assign o_note_pressed = 1'b0;
assign o_note_released = 1'b0;

assign o_state = (i_channel == DRUM_CHANNEL ) ? (
	           ( i_state == `BLANK && i_note_pressed == 1'b1)  ? `ATTACK :
		   ( i_state == `ATTACK && i_fifo_empty == 1'b0)  ? `SUSTAIN : 
		   ( i_state == `SUSTAIN && i_fifo_empty == 1'b0)  ? `SUSTAIN :
		   ( i_state == `SUSTAIN && i_fifo_empty == 1'b1)  ? `BLANK :
		                                                     i_state
	                                        ) :
	         (i_state == `BLANK && i_note_pressed == 1'b1) ? `ATTACK :
                 (i_state == `ATTACK && i_note_released == 1'b1) ? `RELEASE :
		 (i_state == `ATTACK && i_volume >= `VOLUME_MAX) ? `DECAY :
                 (i_state == `DECAY && i_note_released == 1'b1) ? `RELEASE:
                 (i_state == `DECAY && i_note_pressed == 1'b1) ? `ATTACK :
                 (i_state == `DECAY && i_volume < sustain_value_internal) ? `SUSTAIN :
                 (i_state == `SUSTAIN && i_note_pressed == 1'b1) ? `ATTACK :
                 (i_state == `SUSTAIN && i_note_released == 1'b1) ? `RELEASE :
                 (i_state == `RELEASE && i_note_pressed == 1'b1) ? `ATTACK :
                 (i_state == `RELEASE && i_volume[17] == 1'b1) ? `BLANK :
                 i_state;

//assign o_volume = (i_channel == DRUM_CHANNEL ) ? sustain_value_internal :
assign o_volume = (i_channel == DRUM_CHANNEL ) ? `VOLUME_MAX :
	          (i_state == `ATTACK && ((i_volume+i_attack_rate) > `VOLUME_MAX)) ? `VOLUME_MAX :
                  (i_state == `ATTACK )? i_volume + i_attack_rate :
                  (i_state == `DECAY ) ? i_volume - i_decay_rate :
                  (i_state == `SUSTAIN ) ? sustain_value_internal :
                  (i_state == `RELEASE ) ? i_volume - i_release_rate : 
                  (i_state == `BLANK) ? `VOLUME_RESET : 
                  i_volume;

endmodule
