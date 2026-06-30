package shift_reg_scoreboard_pkg;
import enum_pkg::*;
import uvm_pkg::*;
import shift_reg_seq_item_pkg::*;
`include "uvm_macros.svh"


class shift_scoreboard extends uvm_component;
  `uvm_component_utils(shift_scoreboard)

  uvm_analysis_port #(shift_reg_seq_item) sb_export; // should be actually uvm_analysis_export????
  uvm_tlm_analysis_fifo #(shift_reg_seq_item) sb_fifo;
  shift_reg_seq_item seq_item_sb;

  logic [5:0] dataout_golden;

  int error_count = 0;
  int correct_count = 0;


  function new(string name = "shift_coverage", uvm_component parent = null);
    super.new(name, parent);
    //
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export", this);
    sb_fifo = new("sb_fifo",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
  endfunction


  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
        sb_fifo.get(seq_item_sb);
        golden_model_calculate(seq_item_sb); //calculate

        if(seq_item_sb.dataout !== dataout_golden) begin
            `uvm_error("run_phase", $sformatf("Comparison failed, concerning Transaction: %s || dataout_expected = 0b%b",
            seq_item_sb.convert2string(), dataout_golden));
            error_count++;
        end else begin
            `uvm_info("run_phase", $sformatf("Transaction handled correctly: %s" , seq_item_sb.convert2string()), UVM_HIGH)
            correct_count++;
        end
    end
    
  endtask



//Golden Model============================================
  task golden_model_calculate(shift_reg_seq_item seq_item_chk);
    if (seq_item_chk.reset)
      dataout_golden = 0;
   else
      if (seq_item_chk.mode == ROTATE) // rotate
         if (seq_item_chk.direction == LEFT) // left
            dataout_golden = {seq_item_chk.datain[4:0], seq_item_chk.datain[5]};
         else
            dataout_golden = {seq_item_chk.datain[0], seq_item_chk.datain[5:1]};
      else // shift
         if (seq_item_chk.direction == LEFT) // left
            dataout_golden = {seq_item_chk.datain[4:0], seq_item_chk.serial_in};
         else
            dataout_golden = {seq_item_chk.serial_in, seq_item_chk.datain[5:1]};
  endtask


  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase", $sformatf("correct_count: %d" , correct_count), UVM_MEDIUM)
    `uvm_info("report_phase", $sformatf("error_count: %d" , error_count), UVM_MEDIUM)
  endfunction


endclass
endpackage

/*
input clk, reset, serial_in, direction, mode;
input [5:0] datain;
output reg [5:0] dataout;*/