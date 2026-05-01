package ALSU_monitor_pkg;
import uvm_pkg::*;
import enum_pkg::*;
import ALSU_seq_item_pkg::*;
`include "uvm_macros.svh"


class ALSU_monitor extends uvm_monitor;
  `uvm_component_utils(ALSU_monitor)

  virtual ALSU_if ALSU_vif;
  virtual ALSU_if ALSU_if_golden;
  ALSU_seq_item rsp_seq_item;
  ALSU_seq_item golden_seq_item;
  uvm_analysis_port #(ALSU_seq_item) mon_ap;
  uvm_analysis_port #(ALSU_seq_item) mon_ap_golden;

  function new(string name = "ALSU_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap", this);
    mon_ap_golden = new("mon_ap_golden", this);
  endfunction


  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    

    forever begin
      rsp_seq_item = ALSU_seq_item::type_id::create("rsp_seq_item");
      golden_seq_item = ALSU_seq_item::type_id::create("golden_seq_item");
      @(negedge ALSU_vif.clk); //driver drives interface and the virtual interface now has the corrct output calculated 
      @(negedge ALSU_vif.clk);

      rsp_seq_item.rst = ALSU_vif.rst;
      rsp_seq_item.cin = ALSU_vif.cin;
      rsp_seq_item.red_op_A = ALSU_vif.red_op_A; 
      rsp_seq_item.red_op_B = ALSU_vif.red_op_B;
      rsp_seq_item.bypass_A = ALSU_vif.bypass_A;
      rsp_seq_item.bypass_B = ALSU_vif.bypass_B;
      rsp_seq_item.direction = ALSU_vif.direction; 
      rsp_seq_item.serial_in = ALSU_vif.serial_in; 
      rsp_seq_item.opcode = ALSU_vif.opcode; 
      rsp_seq_item.A = ALSU_vif.A;
      rsp_seq_item.B = ALSU_vif.B;
      rsp_seq_item.leds = ALSU_vif.leds;
      rsp_seq_item.out = ALSU_vif.out;

      golden_seq_item.leds = ALSU_if_golden.leds;
      golden_seq_item.out = ALSU_if_golden.out;
      
      mon_ap.write(rsp_seq_item);
      mon_ap_golden.write(golden_seq_item);
      `uvm_info("run_phase",rsp_seq_item.convert2string(), UVM_HIGH)
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