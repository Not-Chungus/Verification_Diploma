module ALSU_golden (
    A, B, cin, serial_in, red_op_A, red_op_B, opcode,
    bypass_A, bypass_B, clk, rst, direction, leds, out
);

parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER    = "ON";

input clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input [2:0] opcode;
input signed [2:0] A, B;

output reg [15:0] leds;
output reg signed [5:0] out;

reg red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
reg cin_reg;
reg [2:0] opcode_reg;
reg signed [2:0] A_reg, B_reg;

wire invalid_red_op, invalid_opcode, invalid;

assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
assign invalid_opcode = opcode_reg[1] & opcode_reg[2];
assign invalid        = invalid_red_op | invalid_opcode;

// Register all inputs except clk/rst
always @(posedge clk or posedge rst) begin
    if (rst) begin
        cin_reg       <= 1'b0;
        red_op_A_reg  <= 1'b0;
        red_op_B_reg  <= 1'b0;
        bypass_A_reg  <= 1'b0;
        bypass_B_reg  <= 1'b0;
        direction_reg <= 1'b0;
        serial_in_reg <= 1'b0;
        opcode_reg    <= 3'b000;
        A_reg         <= 3'sd0;
        B_reg         <= 3'sd0;
    end
    else begin
        cin_reg       <= cin;
        red_op_A_reg  <= red_op_A;
        red_op_B_reg  <= red_op_B;
        bypass_A_reg  <= bypass_A;
        bypass_B_reg  <= bypass_B;
        direction_reg <= direction;
        serial_in_reg <= serial_in;
        opcode_reg    <= opcode;
        A_reg         <= A;
        B_reg         <= B;
    end
end

// LEDs blink on invalid
always @(posedge clk or posedge rst) begin
  if(rst) begin
      leds <= 0;
  end else begin
      if (invalid)
        leds <= ~leds;
      else
        leds <= 0;
  end
end

// Reference output model
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 6'sd0;
    end
    else begin
        if (bypass_A_reg && bypass_B_reg)
            out <= (INPUT_PRIORITY == "A") ? {{3{A_reg[2]}}, A_reg} : {{3{B_reg[2]}}, B_reg};
        else if (bypass_A_reg)
            out <= {{3{A_reg[2]}}, A_reg};
        else if (bypass_B_reg)
            out <= {{3{B_reg[2]}}, B_reg};
        else if (invalid)
            out <= 6'sd0;
        else begin
            case (opcode_reg)
                3'h0: begin // OR
                    if (red_op_A_reg && red_op_B_reg)
                        out <= (INPUT_PRIORITY == "A") ? {{5{1'b0}}, |A_reg} : {{5{1'b0}}, |B_reg};
                    else if (red_op_A_reg)
                        out <= {{5{1'b0}}, |A_reg};
                    else if (red_op_B_reg)
                        out <= {{5{1'b0}}, |B_reg};
                    else
                        out <= A_reg | B_reg;
                end

                3'h1: begin // XOR
                    if (red_op_A_reg && red_op_B_reg)
                        out <= (INPUT_PRIORITY == "A") ? {{5{1'b0}}, ^A_reg} : {{5{1'b0}}, ^B_reg};
                    else if (red_op_A_reg)
                        out <= {{5{1'b0}}, ^A_reg};
                    else if (red_op_B_reg)
                        out <= {{5{1'b0}}, ^B_reg};
                    else
                        out <= A_reg ^ B_reg;
                end

                3'h2: begin // ADD
                    if (FULL_ADDER == "ON")
                        out <= A_reg + B_reg + cin_reg;
                    else
                        out <= A_reg + B_reg;
                end

                3'h3: begin // MULT
                    out <= $signed({{3{A_reg[2]}}, A_reg}) *
                           $signed({{3{B_reg[2]}}, B_reg});
                end

                3'h4: begin // SHIFT
                    if (direction_reg)
                        out <= {out[4:0], serial_in_reg};
                    else
                        out <= {serial_in_reg, out[5:1]};
                end

                3'h5: begin // ROTATE
                    if (direction_reg)
                        out <= {out[4:0], out[5]};
                    else
                        out <= {out[0], out[5:1]};
                end

                3'h6, 3'h7: out <= 6'sd0;
                default:    out <= 6'sd0;
            endcase
        end
    end
end

endmodule