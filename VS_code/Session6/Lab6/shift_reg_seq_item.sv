package shift_reg_seq_item_pkg;
import enum_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class shift_reg_seq_item extends uvm_sequence_item;
  `uvm_object_utils(shift_reg_seq_item)

  rand logic[5:0] datain;
  rand bit reset, serial_in;
  rand direction_e direction;
  rand mode_e mode;
  logic [5:0] dataout; 

  function new(string name = "shift_reg_seq_item");
    super.new(name);
  endfunction


  function string convert2string();
    return $sformatf("%s data_in = 0b%b| reset = 0b%b | serial_in = 0b%b | direction = %s | mode = %s | dataout = 0b%b" ,
    super.convert2string() ,datain, reset, serial_in, direction.name ,mode.name, dataout);

  endfunction

  function string convert2string_stimulus();
    return $sformatf("reset = 0b%b | serial_in = 0b%b | direction = %s | mode = %s",
    reset, serial_in, direction.name ,mode.name);

  endfunction

  //Constraints=====================================================
  constraint Reset { //off for 90% of the time
    reset dist {0:/90 , 1:/10};
  }


endclass
endpackage
/*
input clk, reset, serial_in, direction, mode;
input [5:0] datain;
output reg [5:0] dataout;*/