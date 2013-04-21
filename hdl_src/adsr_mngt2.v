`timescale 1ns / 1ps
module adsr_mngt2(
    input [6:0] velocity_value,
    input [6:0] sustain_value,
    input [6:0] attack_rate,
    input [6:0] decay_rate,
    input [6:0] release_rate,
    input [2:0] i_state,
    input [17:0] i_volume,
    input i_note_pressed,
    input i_note_released,
    output [2:0] o_state,
    output o_note_pressed,
    output o_note_released,
    output [17:0] o_volume
    );

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
wire [17:0] velocity_value_internal;

assign sustain_value_internal = {1'b0,sustain_value,10'b0000000000};
assign velocity_value_internal = {1'b0,velocity_value,10'b0000000000};

/*
assign o_note_pressed = (i_state == `ATTACK && i_note_pressed == 1'b1) ? 1'b0 : i_note_pressed;
assign o_note_released = ((i_state == `RELEASE || i_state == `BLANK) && i_note_released == 1'b1) ?
                         1'b0 : i_note_released; 
*/
assign o_note_pressed = 1'b0;
assign o_note_released = 1'b0;

assign o_state = (i_state == `BLANK && i_note_pressed == 1'b1) ? `ATTACK :
                 (i_state == `ATTACK && i_note_released == 1'b1) ? `RELEASE :
		 (i_state == `ATTACK && i_volume >= velocity_value_internal) ? `DECAY :
                 (i_state == `DECAY && i_note_released == 1'b1) ? `RELEASE:
                 (i_state == `DECAY && i_note_pressed == 1'b1) ? `ATTACK :
                 (i_state == `DECAY && i_volume < sustain_value_internal) ? `SUSTAIN :
                 (i_state == `SUSTAIN && i_note_pressed == 1'b1) ? `ATTACK :
                 (i_state == `SUSTAIN && i_note_released == 1'b1) ? `RELEASE :
                 (i_state == `RELEASE && i_note_pressed == 1'b1) ? `ATTACK :
                 (i_state == `RELEASE && i_volume[17] == 1'b1) ? `BLANK :
                 i_state;

assign o_volume = (i_state == `ATTACK && ((i_volume+attack_rate) > velocity_value_internal)) ? velocity_value_internal :
                  (i_state == `ATTACK )? i_volume + attack_rate :
                  (i_state == `DECAY ) ? i_volume - decay_rate :
                  (i_state == `SUSTAIN ) ? sustain_value_internal :
                  (i_state == `RELEASE ) ? i_volume - release_rate : 
                  (i_state == `BLANK) ? `VOLUME_RESET : 
                  i_volume;

endmodule
