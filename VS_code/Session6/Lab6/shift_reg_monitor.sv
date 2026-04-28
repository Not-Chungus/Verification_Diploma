package shift_reg_monitor_pkg;
import uvm_pkg::*;
import enum_pkg::*;
import shift_reg_seq_item_pkg::*;
`include "uvm_macros.svh"


class shift_monitor extends uvm_monitor;
  `uvm_component_utils(shift_monitor)

  virtual shift_reg_if shift_vif;
  shift_reg_seq_item rsp_seq_item;
  uvm_analysis_port #(shift_reg_seq_item) mon_ap;

  function new(string name = "shift_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap", this);
  endfunction


  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    

    forever begin
      rsp_seq_item = shift_reg_seq_item::type_id::create("rsp_seq_item");
      @(negedge shift_vif.clk); //driver drives interface and the virtual interface now has the corrct output calculated 
      
      rsp_seq_item.reset = shift_vif.reset;
      rsp_seq_item.serial_in = shift_vif.serial_in;
      rsp_seq_item.direction = shift_vif.direction; 
      rsp_seq_item.mode = shift_vif.mode;
      rsp_seq_item.datain = shift_vif.datain;
      rsp_seq_item.dataout = shift_vif.dataout; 
      
      mon_ap.write(rsp_seq_item);
      `uvm_info("run_phase",rsp_seq_item.convert2string(), UVM_LOW)
    end
  endtask

endclass
endpackage

/*
input clk, reset, serial_in, direction, mode;
input [5:0] datain;
output reg [5:0] dataout;*/