////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
import ALSU_test_pkg::*;
`include "uvm_macros.svh"

module top();
  // Clock generation
  // Instantiate the interface and DUT
  // run test using run_test task

  bit clk;
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  ALSU_if ALSUif (clk);
  ALSU_wrapper dut (ALSUif);
  
  // Set in db the virtual interface for the uvm test

  initial begin
    uvm_config_db#(virtual ALSU_if)::set(null, "uvm_test_top", "ALSU_IF", ALSUif);
    run_test("ALSU_test");

  end

  
endmodule