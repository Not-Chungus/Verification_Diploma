package ALSU_sqr_pkg;
import enum_pkg::*;
import ALSU_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_sqr extends uvm_sequencer #(ALSU_seq_item);
  `uvm_component_utils(ALSU_sqr)


  function new(string name = "ALSU_sequencer" , uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass



endpackage
/*
input clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input [2:0] opcode;
input signed [2:0] A, B;

output reg [15:0] leds;
output reg signed [5:0] out;
*/