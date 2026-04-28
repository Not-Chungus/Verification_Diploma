package shift_reg_coverage_pkg;
import enum_pkg::*;
import uvm_pkg::*;
import shift_reg_seq_item_pkg::*;
`include "uvm_macros.svh"


class shift_coverage extends uvm_component;
  `uvm_component_utils(shift_coverage)

  uvm_analysis_port #(shift_reg_seq_item) cov_export;
  uvm_tlm_analysis_fifo #(shift_reg_seq_item) cov_fifo;
  shift_reg_seq_item seq_item_cov;

  
  //CoverGroups========================================
  covergroup CovPort; //@(posedge clk);
    Data_in_cvp: coverpoint seq_item_cov.datain iff(1);
    serial_in_cvp: coverpoint seq_item_cov.serial_in iff(1);
    direction_cvp: coverpoint seq_item_cov.direction iff(1);
    mode_cvp: coverpoint seq_item_cov.mode iff(1);

  endgroup
  //CoverGroups========================================


  function new(string name = "shift_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    CovPort = new;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("sb_export", this);
    cov_fifo = new("sb_fifo",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
  endfunction


  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
        cov_fifo.get(seq_item_cov);
        CovPort.sample;
    end
    
  endtask



endclass
endpackage

/*
input clk, reset, serial_in, direction, mode;
input [5:0] datain;
output reg [5:0] dataout;*/