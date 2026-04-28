package shift_reg_sqr_pkg;
import enum_pkg::*;
import shift_reg_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class shift_reg_sqr extends uvm_sequencer #(shift_reg_seq_item);
  `uvm_component_utils(shift_reg_sqr)


  function new(string name = "shift_reg_sequencer" , uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass





endpackage
/*
input clk, reset, serial_in, direction, mode;
input [5:0] datain;
output reg [5:0] dataout;*/