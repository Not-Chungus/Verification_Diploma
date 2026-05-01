package enum_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum reg [2:0] {OR, XOR, ADD, MULT, 
SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;

localparam MAXPOS = 3, ZERO = 0, MAXNEG = -4;

endpackage
/*
input clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input [2:0] opcode;
input signed [2:0] A, B;

output reg [15:0] leds;
output reg signed [5:0] out;
*/
