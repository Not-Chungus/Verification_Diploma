package ALSU_scoreboard_pkg;
import enum_pkg::*;
import uvm_pkg::*;
import ALSU_seq_item_pkg::*;
`include "uvm_macros.svh"


class ALSU_scoreboard extends uvm_component;
  `uvm_component_utils(ALSU_scoreboard)

  uvm_analysis_export #(ALSU_seq_item) sb_export;
  uvm_tlm_analysis_fifo #(ALSU_seq_item) sb_fifo;

  uvm_analysis_export #(ALSU_seq_item) sb_export_golden;
  uvm_tlm_analysis_fifo #(ALSU_seq_item) sb_fifo_golden;

  ALSU_seq_item seq_item_sb;
  ALSU_seq_item golden_seq_item;


  int error_count = 0;
  int correct_count = 0;


  function new(string name = "ALSU_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export", this);
    sb_fifo = new("sb_fifo",this);
    sb_export_golden = new("sb_export_golden", this);
    sb_fifo_golden = new("sb_fifo_golden",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
    sb_export_golden.connect(sb_fifo_golden.analysis_export);
  endfunction


  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
        sb_fifo.get(seq_item_sb);
        sb_fifo_golden.get(golden_seq_item);

        if((seq_item_sb.out !== golden_seq_item.out) || (seq_item_sb.leds !== golden_seq_item.leds)) begin
            `uvm_error("run_phase", $sformatf("Comparison failed, concerning Transaction: %s || out_expected = 0b%b || leds_expected = 0x%h",
            seq_item_sb.convert2string(), golden_seq_item.out, golden_seq_item.leds));
            error_count++;
        end else begin
            `uvm_info("run_phase", $sformatf("Transaction handled correctly: %s" , seq_item_sb.convert2string()), UVM_HIGH)
            correct_count++;
        end
    end
    
  endtask



//Golden Model============================================


  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase", $sformatf("correct_count: %d" , correct_count), UVM_MEDIUM)
    `uvm_info("report_phase", $sformatf("error_count: %d" , error_count), UVM_MEDIUM)
  endfunction


endclass
endpackage

/*
input clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input [2:0] opcode;
input signed [2:0] A, B;

output reg [15:0] leds;
output reg signed [5:0] out;
*/