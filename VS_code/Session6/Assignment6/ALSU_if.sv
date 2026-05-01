////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: ALSU register Interface
// 
////////////////////////////////////////////////////////////////////////////////
import enum_pkg::*;
interface ALSU_if (clk);
  input clk;
  logic cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
  opcode_e opcode;
  logic signed [2:0] A, B;
  logic [15:0] leds;
  logic signed [5:0] out;
endinterface : ALSU_if

/*
input clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input [2:0] opcode;
input signed [2:0] A, B;

output reg [15:0] leds;
output reg signed [5:0] out;
*/