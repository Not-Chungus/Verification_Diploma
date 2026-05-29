package FIFO_coverage_pkg;
import shared_pkg::*;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;
`include "uvm_macros.svh"


class FIFO_coverage extends uvm_component;
  `uvm_component_utils(FIFO_coverage)

  uvm_analysis_export #(FIFO_seq_item) cov_export;
  uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
  FIFO_seq_item si_cov;

  
  //CoverGroups========================================
  covergroup CovPort; //@(posedge clk)
      rst_cp: coverpoint si_cov.rst_n iff(1){}
      wr_en_cp: coverpoint si_cov.wr_en iff(1){}
      rd_en_cp: coverpoint si_cov.rd_en iff(1){}
      wr_ack_cp: coverpoint si_cov.wr_ack iff(1){}
      OF_cp: coverpoint si_cov.overflow iff(1){}
      UF_cp: coverpoint si_cov.underflow iff(1){}
      Full_cp: coverpoint si_cov.full iff(1){}
      Empty_cp: coverpoint si_cov.empty iff(1){}
      almost_full_cp: coverpoint si_cov.almostfull iff(1){}
      almost_empty_cp: coverpoint si_cov.almostempty iff(1){}

      //================Cross Coverage=====================
      
      //1.
      wr_rd_wr_ack: cross wr_en_cp, rd_en_cp, wr_ack_cp {
      ignore_bins impossible =
          binsof(wr_en_cp) intersect {0} &&
          binsof(wr_ack_cp) intersect {1};}
      //2.
      wr_rd_OF: cross wr_en_cp, rd_en_cp, OF_cp {
      ignore_bins impossible =
          (binsof(wr_en_cp) intersect {0} &&
           binsof(OF_cp)    intersect {1})
          ||
          (binsof(wr_en_cp) intersect {1} &&
           binsof(rd_en_cp) intersect {1} &&
           binsof(OF_cp)    intersect {1});}
      //3.
      wr_rd_UF: cross wr_en_cp, rd_en_cp, UF_cp {
      ignore_bins impossible =
          (binsof(rd_en_cp) intersect {0} &&
           binsof(UF_cp)    intersect {1})
          ||
          (binsof(wr_en_cp) intersect {1} &&
           binsof(rd_en_cp) intersect {1} &&
           binsof(UF_cp)    intersect {1});}
      //4.
      wr_rd_Full: cross wr_en_cp, rd_en_cp, Full_cp {
      ignore_bins impossible =
          binsof(rd_en_cp) intersect {1} &&
          binsof(Full_cp)  intersect {1};}
      //5.
      wr_rd_Empty: cross wr_en_cp, rd_en_cp, Empty_cp{}
      //6.
      wr_rd_almost_full: cross wr_en_cp, rd_en_cp, almost_full_cp{}
      //7.
      wr_rd_almost_empty: cross wr_en_cp, rd_en_cp, almost_empty_cp{}
         
        endgroup
  //CoverGroups========================================


  function new(string name = "FIFO_coverage", uvm_component parent = null);
    super.new(name, parent);
    CovPort = new;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export", this);
    cov_fifo = new("cov_fifo",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
  endfunction


  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
        cov_fifo.get(si_cov);
        CovPort.sample;
    end
    
  endtask



endclass
endpackage

/*
input clk, reset, serial_in, direction, mode;
input [5:0] datain;
output reg [5:0] dataout;*/