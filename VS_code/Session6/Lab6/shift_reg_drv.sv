package shift_reg_drv_pkg;
import uvm_pkg::*;
import enum_pkg::*;
import shift_reg_cfg_pkg::*;
import shift_reg_seq_item_pkg::*;
`include "uvm_macros.svh"


class shift_driver extends uvm_driver #(shift_reg_seq_item);
  `uvm_component_utils(shift_driver)

  shift_config shift_cfg;
  virtual shift_reg_if shift_vif;
  shift_reg_seq_item seq_item_stimulus;

  function new(string name = "shift_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

//this part should be redundant, we connected the vif in agent?????////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //shift_cfg = shift_config::type_id::create("shift_cfg"); we handle the object implicitly below to achieve that both objects (this one here and one in test)are pointing to the object: sharing the memory and no copies needed made
    if (!uvm_config_db #(shift_config)::get(this, "", "CFG", shift_cfg)) begin
      `uvm_fatal("build_phase", "Unable to get configuration object")
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    shift_vif = shift_cfg.shift_vif;
  endfunction
/////////////////////////////////////////////////////////////////////////////////

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    seq_item_stimulus = shift_reg_seq_item::type_id::create("seq_item");

    forever begin
      seq_item_port.get_next_item(seq_item_stimulus); // I want, waiting for finish | seq_item_port is a predefined data member of the uvm_driver parent class

      shift_vif.reset = seq_item_stimulus.reset;
      shift_vif.serial_in = seq_item_stimulus.serial_in;
      shift_vif.direction = direction_e'(seq_item_stimulus.direction);
      shift_vif.mode = mode_e'(seq_item_stimulus.mode);
      shift_vif.datain = seq_item_stimulus.datain;
      @(negedge shift_vif.clk);
      seq_item_port.item_done();
    end
  endtask

endclass
endpackage

/*
input clk, reset, serial_in, direction, mode;
input [5:0] datain;
output reg [5:0] dataout;*/