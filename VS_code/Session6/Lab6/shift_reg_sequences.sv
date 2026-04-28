package shift_reg_seq_pkg;
import enum_pkg::*;
import shift_reg_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class shift_reg_reset_seq extends uvm_sequence #(shift_reg_seq_item);
  `uvm_object_utils(shift_reg_reset_seq)

  shift_reg_seq_item seq_item;

  function new(string name = "shift_reg_reset_seq");
    super.new(name);
  endfunction

  task body;
    seq_item = shift_reg_seq_item::type_id::create("seq_item");
    
    start_item(seq_item);
    seq_item.reset = 1;
    seq_item.serial_in = 0;
    seq_item.direction = direction_e'(0); //direction_e'(0)
    seq_item.mode = mode_e'(0);  //mode_e'(0)
    seq_item.datain = 6'b00_0000;
    finish_item(seq_item);
  endtask

endclass



class shift_reg_main_seq extends uvm_sequence #(shift_reg_seq_item);
  `uvm_object_utils(shift_reg_main_seq)

  shift_reg_seq_item seq_item;

  function new(string name = "shift_reg_main_seq");
    super.new(name);
  endfunction

  task body;
    seq_item = shift_reg_seq_item::type_id::create("seq_item");
    
     
    repeat(1000) begin
      start_item(seq_item);
      assert(seq_item.randomize());
      finish_item(seq_item);
    end

  endtask


endclass



endpackage
/*
input clk, reset, serial_in, direction, mode;
input [5:0] datain;
output reg [5:0] dataout;*/