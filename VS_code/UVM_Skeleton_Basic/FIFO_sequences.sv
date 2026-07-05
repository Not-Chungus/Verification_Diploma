package FIFO_seq_pkg;
import shared_pkg::*;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"


//Reset sequence===========================================================
class FIFO_reset_seq extends uvm_sequence #(FIFO_seq_item);
  `uvm_object_utils(FIFO_reset_seq)

  FIFO_seq_item seq_item;

  function new(string name = "FIFO_reset_seq");
    super.new(name);
  endfunction

  task body;
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    
    start_item(seq_item);
    seq_item.rst_n = 0;
    seq_item.wr_en = 0;
    seq_item.rd_en = 0;
    seq_item.data_in = '0;
    finish_item(seq_item);
  endtask

endclass


//Write only sequence===========================================================
class FIFO_wr_only_seq extends uvm_sequence #(FIFO_seq_item);
  `uvm_object_utils(FIFO_wr_only_seq)

  FIFO_seq_item seq_item;

  function new(string name = "FIFO_wr_only_seq");
    super.new(name);
  endfunction

  task body;
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    
     
    repeat(100) begin
      start_item(seq_item);
      seq_item.RD_EN_ON_DIST = 0;
      seq_item.WR_EN_ON_DIST = 70;
      assert(seq_item.randomize());
      finish_item(seq_item);
    end

  endtask

endclass

//Read only sequence===========================================================
class FIFO_rd_only_seq extends uvm_sequence #(FIFO_seq_item);
  `uvm_object_utils(FIFO_rd_only_seq)

  FIFO_seq_item seq_item;

  function new(string name = "FIFO_rd_only_seq");
    super.new(name);
  endfunction

  task body;
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    
     
    repeat(100) begin
      start_item(seq_item);
      seq_item.RD_EN_ON_DIST = 70;
      seq_item.WR_EN_ON_DIST = 0;
      assert(seq_item.randomize());
      finish_item(seq_item);
    end

  endtask

endclass

//Main sequence 1 (Read more probable than write)===========================================================
class FIFO_main_seq_1 extends uvm_sequence #(FIFO_seq_item);
  `uvm_object_utils(FIFO_main_seq_1)

  FIFO_seq_item seq_item;

  function new(string name = "FIFO_main_seq_1");
    super.new(name);
  endfunction

  task body;
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    
     
    repeat(100) begin
      start_item(seq_item);
      seq_item.RD_EN_ON_DIST = 70;
      seq_item.WR_EN_ON_DIST = 30;
      assert(seq_item.randomize());
      finish_item(seq_item);
    end

  endtask

endclass

//Main sequence 2 (Write more probable than read)===========================================================
class FIFO_main_seq_2 extends uvm_sequence #(FIFO_seq_item);
  `uvm_object_utils(FIFO_main_seq_2)

  FIFO_seq_item seq_item;

  function new(string name = "FIFO_main_seq_2");
    super.new(name);
  endfunction

  task body;
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    
     
    repeat(100) begin
      start_item(seq_item);
      seq_item.RD_EN_ON_DIST = 30;
      seq_item.WR_EN_ON_DIST = 70;
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