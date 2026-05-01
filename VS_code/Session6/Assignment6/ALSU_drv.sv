package ALSU_drv_pkg;
import uvm_pkg::*;
import enum_pkg::*;
import ALSU_cfg_pkg::*;
import ALSU_seq_item_pkg::*;
`include "uvm_macros.svh"


class ALSU_driver extends uvm_driver #(ALSU_seq_item);
  `uvm_component_utils(ALSU_driver)

  ALSU_config ALSU_cfg;
  virtual ALSU_if ALSU_vif;
  virtual ALSU_if ALSU_if_golden;
  ALSU_seq_item seq_item_stimulus;

  function new(string name = "ALSU_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //ALSU_cfg = ALSU_config::type_id::create("ALSU_cfg"); we handle the object implicitly below to achieve that both objects (this one here and one in test)are pointing to the object: sharing the memory and no copies needed made
    if (!uvm_config_db #(ALSU_config)::get(this, "", "CFG", ALSU_cfg)) begin
      `uvm_fatal("build_phase", "Unable to get configuration object")
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ALSU_vif = ALSU_cfg.ALSU_vif;
    ALSU_if_golden = ALSU_cfg.ALSU_if_golden;
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    seq_item_stimulus = ALSU_seq_item::type_id::create("seq_item");

    forever begin
      seq_item_port.get_next_item(seq_item_stimulus); // I want, waiting for finish | seq_item_port is a predefined data member of the uvm_driver parent class

      ALSU_vif.rst = seq_item_stimulus.rst;
      ALSU_vif.cin = seq_item_stimulus.cin; 
      ALSU_vif.red_op_A = seq_item_stimulus.red_op_A; 
      ALSU_vif.red_op_B = seq_item_stimulus.red_op_B;
      ALSU_vif.bypass_A = seq_item_stimulus.bypass_A; 
      ALSU_vif.bypass_B = seq_item_stimulus.bypass_B; 
      ALSU_vif.direction = seq_item_stimulus.direction; 
      ALSU_vif.serial_in = seq_item_stimulus.serial_in; 
      ALSU_vif.opcode = seq_item_stimulus.opcode;
      ALSU_vif.A = seq_item_stimulus.A;
      ALSU_vif.B = seq_item_stimulus.B;

      ALSU_if_golden.rst = seq_item_stimulus.rst;
      ALSU_if_golden.cin = seq_item_stimulus.cin; 
      ALSU_if_golden.red_op_A = seq_item_stimulus.red_op_A; 
      ALSU_if_golden.red_op_B = seq_item_stimulus.red_op_B;
      ALSU_if_golden.bypass_A = seq_item_stimulus.bypass_A; 
      ALSU_if_golden.bypass_B = seq_item_stimulus.bypass_B; 
      ALSU_if_golden.direction = seq_item_stimulus.direction; 
      ALSU_if_golden.serial_in = seq_item_stimulus.serial_in; 
      ALSU_if_golden.opcode = seq_item_stimulus.opcode;
      ALSU_if_golden.A = seq_item_stimulus.A;
      ALSU_if_golden.B = seq_item_stimulus.B;


      @(negedge ALSU_vif.clk);
      @(negedge ALSU_vif.clk);
      seq_item_port.item_done();
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