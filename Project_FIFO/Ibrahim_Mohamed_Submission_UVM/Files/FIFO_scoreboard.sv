package FIFO_scoreboard_pkg;
import shared_pkg::*;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;
`include "uvm_macros.svh"


class FIFO_scoreboard extends uvm_component;
  `uvm_component_utils(FIFO_scoreboard)

  uvm_analysis_export #(FIFO_seq_item) sb_export;
  uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;

  FIFO_seq_item seq_item_sb;
  FIFO_seq_item seq_item_sb_golden;

  logic [FIFO_WIDTH-1:0] data_out_ref;
  logic [FIFO_WIDTH-1:0] fifo_mem_q[$];

  int error_count = 0;
  int correct_count = 0;


  function new(string name = "FIFO_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    //
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq_item_sb_golden = FIFO_seq_item::type_id::create("seq_item_sb_golden");
    seq_item_sb = FIFO_seq_item::type_id::create("seq_item_sb");
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
        reference_model(seq_item_sb); //calculate

        if(something_is_wrong(seq_item_sb)) begin
            `uvm_error("run_phase", $sformatf("Comparison failed, concerning Transaction:\n %s \n dataout_expected = 0b%b",
            seq_item_sb.convert2string(), data_out_ref));
            error_count++;
        end else begin
            `uvm_info("run_phase", $sformatf("Transaction handled correctly: %s" , seq_item_sb.convert2string()), UVM_HIGH)
            correct_count++;
        end
    end
    
  endtask



//Golden Model============================================
function automatic void reference_model(input FIFO_seq_item F_si);
  // Default pulse-like sequential outputs every cycle
  seq_item_sb_golden.wr_ack     = 0;
  seq_item_sb_golden.overflow   = 0;
  seq_item_sb_golden.underflow  = 0;  
  if (!F_si.rst_n) begin
      fifo_mem_q.delete();
      data_out_ref         = {FIFO_WIDTH{1'b0}};  
      seq_item_sb_golden.full        = 0;
      seq_item_sb_golden.empty       = 1;
      seq_item_sb_golden.almostfull  = 0;
      seq_item_sb_golden.almostempty = 0;
      seq_item_sb_golden.wr_ack      = 0;
      seq_item_sb_golden.overflow    = 0;
      seq_item_sb_golden.underflow   = 0; 
      seq_item_sb_golden.data_out =  data_out_ref;
  end
  else begin
      // Operation handling
      // -------------------------
      case ({F_si.wr_en, F_si.rd_en}) 
          2'b10: begin
              // Write only
              if (fifo_mem_q.size() < FIFO_DEPTH) begin
                  fifo_mem_q.push_back(F_si.data_in);
                  seq_item_sb_golden.wr_ack = 1;
              end
              else begin
                  seq_item_sb_golden.overflow = 1;
              end
          end 
          2'b01: begin
              // Read only
              if (fifo_mem_q.size() > 0) begin
                  data_out_ref = fifo_mem_q.pop_front();
              end
              else begin
                  seq_item_sb_golden.underflow = 1;
              end
          end 
          2'b11: begin
              // Both write and read enabled
              if (fifo_mem_q.size() == 0) begin
                  // Spec note: when empty, only writing takes place
                  fifo_mem_q.push_back(F_si.data_in);
                  seq_item_sb_golden.wr_ack = 1;
              end
              else if (fifo_mem_q.size() == FIFO_DEPTH) begin
                  // Spec note: when full, only reading takes place
                  data_out_ref = fifo_mem_q.pop_front();
              end
              else begin
                  // Normal simultaneous read + write
                  data_out_ref = fifo_mem_q.pop_front();
                  fifo_mem_q.push_back(F_si.data_in);
                  seq_item_sb_golden.wr_ack = 1;
              end
          end 
          default: begin
              // No operation
          end 
      endcase 
      // -------------------------
      // Combinational flag generation from resulting occupancy
      // -------------------------
      seq_item_sb_golden.full        = (fifo_mem_q.size() == FIFO_DEPTH);
      seq_item_sb_golden.empty       = (fifo_mem_q.size() == 0);
      seq_item_sb_golden.almostfull  = (fifo_mem_q.size() == FIFO_DEPTH-1);
      seq_item_sb_golden.almostempty = (fifo_mem_q.size() == 1);  
      // Optional if your transaction object has data_out
      seq_item_sb_golden.data_out    = data_out_ref;
  end 
endfunction

  function automatic bit something_is_wrong(FIFO_seq_item seq_item_sb);
    return (
    seq_item_sb.wr_ack      !== seq_item_sb_golden.wr_ack     ||
    seq_item_sb.overflow    !== seq_item_sb_golden.overflow   ||
    seq_item_sb.full        !== seq_item_sb_golden.full       ||
    seq_item_sb.empty       !== seq_item_sb_golden.empty      ||
    seq_item_sb.underflow   !== seq_item_sb_golden.underflow  ||
    seq_item_sb.almostfull  !== seq_item_sb_golden.almostfull ||
    seq_item_sb.almostempty !== seq_item_sb_golden.almostempty||
    seq_item_sb.data_out    !== data_out_ref
    );
  endfunction


  


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