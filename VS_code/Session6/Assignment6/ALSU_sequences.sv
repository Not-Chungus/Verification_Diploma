package ALSU_seq_pkg;
import enum_pkg::*;
import ALSU_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_reset_seq extends uvm_sequence #(ALSU_seq_item);
  `uvm_object_utils(ALSU_reset_seq)

  ALSU_seq_item seq_item;

  function new(string name = "ALSU_reset_seq");
    super.new(name);
  endfunction

  task body;
    seq_item = ALSU_seq_item::type_id::create("seq_item");
    
    start_item(seq_item);
    seq_item.rst = 1;      seq_item.cin = 0;
    seq_item.red_op_A = 0; seq_item.red_op_B = 0;
    seq_item.bypass_A = 0; seq_item.bypass_B = 0;
    seq_item.direction = 0; seq_item.serial_in = 0;
    seq_item.opcode = opcode_e'(0);
    seq_item.A = 0; seq_item.B = 0;
    finish_item(seq_item);
  endtask

endclass


class ALSU_Constrained_main_seq extends uvm_sequence #(ALSU_seq_item);
  `uvm_object_utils(ALSU_Constrained_main_seq)

  ALSU_seq_item seq_item;

  function new(string name = "ALSU_main_seq");
    super.new(name);
  endfunction

  task body;
    seq_item = ALSU_seq_item::type_id::create("seq_item");
    
    seq_item.opcode_rand_array.constraint_mode(0); //disable only valid opcodes
    repeat(2000) begin
      start_item(seq_item);
      assert(seq_item.randomize());
      finish_item(seq_item);
    end

  endtask


endclass


class ALSU_Heavy_opcode_verification_seq extends uvm_sequence #(ALSU_seq_item);
  `uvm_object_utils(ALSU_Heavy_opcode_verification_seq)

  ALSU_seq_item base_item, seq_item;

  function new(string name = "ALSU_Heavy_opcode_verification_seq");
    super.new(name);
  endfunction

  task body;    

    repeat(1000) begin

      base_item = ALSU_seq_item::type_id::create("base_item");
      base_item.constraint_mode(0);
      base_item.opcode_rand_array.constraint_mode(1);
      assert(base_item.randomize());


      foreach(base_item.my_opcodes[i]) begin
        seq_item = ALSU_seq_item::type_id::create($sformatf("seq_item_%0d", i));
        start_item(seq_item); //ready and waiting
        seq_item.A         = base_item.A;
        seq_item.B         = base_item.B;
        seq_item.cin       = base_item.cin;
        seq_item.rst       = base_item.rst;
        seq_item.red_op_A  = base_item.red_op_A;
        seq_item.red_op_B  = base_item.red_op_B;
        seq_item.bypass_A  = base_item.bypass_A;
        seq_item.bypass_B  = base_item.bypass_B;
        seq_item.direction = base_item.direction;
        seq_item.serial_in = base_item.serial_in;
        seq_item.opcode    = base_item.my_opcodes[i];
        finish_item(seq_item); //ship for driver
      end
      
    end

    repeat(1000) begin //Directed forced opcode transition

      base_item = ALSU_seq_item::type_id::create("base_item");
      base_item.constraint_mode(0);
      base_item.opcode_rand_array.constraint_mode(1);
      assert(base_item.randomize());


      foreach(base_item.my_opcodes[i]) begin
        seq_item = ALSU_seq_item::type_id::create($sformatf("seq_item_%0d", i));
        start_item(seq_item); //ready and waiting
        seq_item.A         = base_item.A;
        seq_item.B         = base_item.B;
        seq_item.cin       = base_item.cin;
        seq_item.rst       = base_item.rst;
        seq_item.red_op_A  = base_item.red_op_A;
        seq_item.red_op_B  = base_item.red_op_B;
        seq_item.bypass_A  = base_item.bypass_A;
        seq_item.bypass_B  = base_item.bypass_B;
        seq_item.direction = base_item.direction;
        seq_item.serial_in = base_item.serial_in;
        seq_item.opcode    = opcode_e'(i);
        finish_item(seq_item); //ship for driver
      end
      
    end

  endtask


endclass



endpackage
/*
input clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input [2:0] opcode;
input signed [2:0] A, B;

output reg [15:0] leds;
output reg signed [5:0] out;
*/