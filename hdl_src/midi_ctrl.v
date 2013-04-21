`timescale 1ns / 1ps
module midi_ctrl(
    input clk,
    input rst,
    input valid_byte,
    input [7:0] data,
    output reg note_presse,
    output reg note_release,
    output reg note_keypress,
    output reg note_channelpress,
    output reg[6:0] note,
    output reg[6:0] velocity,
    output reg [3:0] channel,
    output reg rst_cmd,
    output reg read,
    // controler control
    output reg c_valid,
    output reg [6:0] c_cmd,
    output reg [7:0] c_byte0,
    output reg [7:0] c_byte1,
    output reg [7:0] c_byte2 
);

reg [3:0] state;
reg [2:0] cmd;
reg valid;

always @(posedge clk) begin
  if (rst==1) begin
    state <= 4'b0100;
    cmd <= 3'b000;
    channel <= 4'b0000;
    note_presse <= 1'b0;
    note_release <= 1'b0;
    note_keypress <= 1'b0;
    note_channelpress <= 1'b0;
    note <= 7'b0000000;
    velocity <= 7'b0000000;
    valid <= 1'b0;
    rst_cmd <= 1'b0;
    read <= 1'b0;
    c_valid <= 1'b0;
    c_cmd <= 7'b000000;
    c_byte0 <= 8'h00;
    c_byte1 <= 8'h00;
    c_byte2 <= 8'h00; 
  end
  else
    case (state)
     4'b0000: // generic start state byte 0
       if (valid_byte == 1'b1 && data[7] == 1'b1) begin // byte0[7] == 1 == midi cmd
          state <= 4'b0001;
          cmd <= data[6:4];
          channel <= data[3:0];
          valid <= data[7];
          if (data == 8'd255)
            rst_cmd <= 1'b1;
          end
       else if (valid_byte == 1'b1 && data[7] == 1'b0) begin
         c_cmd <= data[6:0];
         state <= 4'b0101;
       end
           
     4'b0001: // state 1 receive midi cmd byte 1  
       if (valid_byte == 1'b1) begin
          if (cmd == 3'b101) begin // cmd is Channel Pressure (After-touch)
            state <= 4'b0100;
             velocity <= data[6:0];
             note_channelpress <= 1'b1;
          end
          else begin // cmd is something else
            state <= 4'b0010;
            note <= data[6:0];
          end
        end
     4'b0010: // state 2 received midi cmd byte 2
       if (valid_byte == 1'b1) begin
          state <= 4'b0011;
          velocity <= data[6:0];
        end  
     4'b0011:
       begin
        if (cmd == 3'b001 && valid == 1'b1) // cmd is note press
          note_presse <= 1'b1;
        else if (cmd == 3'b000 && valid == 1'b1) //cmd is note released
          note_release <= 1'b1;
        else if (cmd == 3'b010 && valid == 1'b1) //cmd is keypress
          note_keypress <= 1'b1;
        else if (cmd == 3'b110 && valid == 1'b1) //cmd is pitch wheel but use to ask a readback 
          read <= 1'b1;
        state <= 4'b0100;
        end
     4'b0100: // reset state
       begin
          valid <= 1'b0;
          state <= 4'b0000;
          note_release <= 1'b0;
          note_presse <= 1'b0;
          note_keypress <= 1'b0;
          note_channelpress <= 1'b0;
          read <=1'b0;
          c_valid<= 1'b0;
        end
      4'b0101: //c_byte0;
        begin
          if (valid_byte == 1'b1) begin
            c_byte0 <= data;
            state <= 4'b0110;
          end
        end
      4'b0110: // c_byte1;
        begin
          if (valid_byte == 1'b1) begin
            c_byte1 <= data;
            state <= 4'b0111;
          end
        end
      4'b0111: // c_byte2;
        begin
          if (valid_byte == 1'b1) begin
            c_byte2 <= data;
            state <= 4'b1000;
          end
        end
      4'b1000: //c_valid == 1;
        begin
          c_valid <= 1'b1;
          state <= 4'b0100;
        end
     endcase
end


endmodule
