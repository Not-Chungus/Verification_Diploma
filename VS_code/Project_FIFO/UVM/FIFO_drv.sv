package FIFO_drv_pkg;
import uvm_pkg::*;
import shared_pkg::*;
import FIFO_cfg_pkg::*;
import FIFO_seq_item_pkg::*;
`include "uvm_macros.svh"


class FIFO_driver extends uvm_driver #(FIFO_seq_item);
  `uvm_component_utils(FIFO_driver)

  FIFO_config FIFO_cfg;
  virtual FIFO_if FIFO_vif;
  FIFO_seq_item seq_item_stimulus;

  function new(string name = "FIFO_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //FIFO_cfg = FIFO_config::type_id::create("FIFO_cfg"); we handle the object implicitly below to achieve that both objects (this one here and one in test)are pointing to the object: sharing the memory and no copies needed made
    if (!uvm_config_db #(FIFO_config)::get(this, "", "CFG", FIFO_cfg)) begin
      `uvm_fatal("build_phase", "Unable to get configuration object")
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    FIFO_vif = FIFO_cfg.FIFO_vif;
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    seq_item_stimulus = FIFO_seq_item::type_id::create("seq_item");

    forever begin
      seq_item_port.get_next_item(seq_item_stimulus); // I want, waiting for finish | seq_item_port is a predefined data member of the uvm_driver parent class

      FIFO_vif.rst_n = seq_item_stimulus.rst_n;
      FIFO_vif.data_in =  seq_item_stimulus.data_in; 
      FIFO_vif.wr_en = seq_item_stimulus.wr_en; 
      FIFO_vif.rd_en = seq_item_stimulus.rd_en; 
  
        @(negedge FIFO_vif.clk);

      seq_item_port.item_done();
    end
  endtask

endclass
endpackage

/*
input clk, reset, serial_in, direction, mode;
input [5:0] datain;
output reg [5:0] dataout;*/