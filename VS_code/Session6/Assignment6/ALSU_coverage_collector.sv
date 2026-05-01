package ALSU_coverage_pkg;
import enum_pkg::*;
import uvm_pkg::*;
import ALSU_seq_item_pkg::*;
`include "uvm_macros.svh"


class ALSU_coverage extends uvm_component;
  `uvm_component_utils(ALSU_coverage)

  uvm_analysis_export #(ALSU_seq_item) cov_export;
  uvm_tlm_analysis_fifo #(ALSU_seq_item) cov_fifo;
  ALSU_seq_item seq_item_cov;

  
  //CoverGroups====================================================
  covergroup CovPort; //@(posedge clk)
    cin_cp: coverpoint seq_item_cov.cin iff(1){}
    direction_cp: coverpoint seq_item_cov.direction iff(1){}
    serial_in_cp: coverpoint seq_item_cov.serial_in iff(1){}
    red_op_A_cp: coverpoint seq_item_cov.red_op_A iff(1){}
    red_op_B_cp: coverpoint seq_item_cov.red_op_B iff(1){}
    
    
    A_cp: coverpoint seq_item_cov.A iff(1)
    {
      bins A_data_0 = {ZERO};
      bins A_data_max = {MAXPOS};
      bins A_data_min = {MAXNEG};
      bins A_data_default = default;
      bins A_data_walkingones[] = {3'b001,3'b010,3'b100} iff(seq_item_cov.red_op_A);
    }

    B_cp: coverpoint seq_item_cov.B iff(1)
    {
      bins B_data_0 = {ZERO};
      bins B_data_max = {MAXPOS};
      bins B_data_min = {MAXNEG};
      bins B_data_default = default;
      bins B_data_walkingones[] = {3'b001,3'b010,3'b100} iff(!seq_item_cov.red_op_A && seq_item_cov.red_op_B);
    }
    
    ALU_cp: coverpoint seq_item_cov.opcode iff(1) 
    {
      bins Bins_shift[] = {SHIFT,ROTATE};
      bins Bins_arith[] = {ADD, MULT};
      bins Bins_bitwise[] = {OR, XOR};
      illegal_bins Bins_invalid = {INVALID_6, INVALID_7};
      bins Bins_trans = (0 => 1 => 2 => 3 => 4 => 5);
    }
    //================Cross Coverage=====================
    
    //1.
    cross ALU_cp,A_cp{
        
      bins Arith_corners_A_1 = binsof(ALU_cp.Bins_arith) && 
                              binsof(A_cp.A_data_0);
      bins Arith_corners_A_2 = binsof(ALU_cp.Bins_arith) && 
                              binsof(A_cp.A_data_max);
      bins Arith_corners_A_3 = binsof(ALU_cp.Bins_arith) && 
                              binsof(A_cp.A_data_min);
      option.cross_auto_bin_max = 0;
    }

    cross ALU_cp,B_cp{   
      bins Arith_corners_B_1 = binsof(ALU_cp.Bins_arith) && 
                              binsof(B_cp.B_data_0);
      bins Arith_corners_B_2 = binsof(ALU_cp.Bins_arith) && 
                              binsof(B_cp.B_data_max);
      bins Arith_corners_B_3 = binsof(ALU_cp.Bins_arith) && 
                              binsof(B_cp.B_data_min);
      option.cross_auto_bin_max = 0;
    }
    //2.
    cross ALU_cp,cin_cp{
      bins Add_cin = binsof(ALU_cp.Bins_arith[0]) && 
                              binsof(cin_cp);
      option.cross_auto_bin_max = 0;
    }
    //3.
    cross ALU_cp,direction_cp{
      bins Shifts_direction = binsof(ALU_cp.Bins_shift) && 
                              binsof(direction_cp);
      option.cross_auto_bin_max = 0;
    }
    //4.
    cross ALU_cp,serial_in_cp{
      bins Shift_Sin = binsof(ALU_cp.Bins_shift[0]) && 
                              binsof(serial_in_cp);
      option.cross_auto_bin_max = 0;
    }
    //5.
    cross ALU_cp,A_cp,red_op_A_cp,serial_in_cp
    {
      bins bitwise_red_A = binsof(ALU_cp.Bins_bitwise) && 
                              binsof(serial_in_cp) && binsof(red_op_A_cp) intersect{1};
      option.cross_auto_bin_max = 0;
    }
    //6.
    cross ALU_cp,B_cp,red_op_B_cp,serial_in_cp
    {
      bins bitwise_red_B = binsof(ALU_cp.Bins_bitwise) && 
                              binsof(serial_in_cp) && binsof(red_op_B_cp) intersect{1};
      option.cross_auto_bin_max = 0;
    }
    //7.
    cross ALU_cp,red_op_A_cp,red_op_B_cp  //no OR,XOR bins and no transition bin 
    {
      ignore_bins red_at_no_bitwise = binsof(ALU_cp.Bins_bitwise) && 
                                      binsof(red_op_A_cp) intersect{0} && 
                                      binsof(red_op_B_cp) intersect{0};
      ignore_bins red_at_no_bitwise_2 = binsof(ALU_cp.Bins_trans);
      //option.cross_auto_bin_max = 0;
    }
  endgroup


  function new(string name = "ALSU_coverage_collector", uvm_component parent = null);
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
        cov_fifo.get(seq_item_cov);
        CovPort.sample;
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