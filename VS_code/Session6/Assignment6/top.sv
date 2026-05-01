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
  // Example 1
  // Clock generation
  // Instantiate the interface and DUT
  // run test using run_test task

  bit clk;
  initial begin
    clk = 0;
    forever #2 clk = ~clk;
  end

  ALSU_if ALSU_if (clk);
  ALSU_wrapper dut (ALSU_if);

  ALSU_if ALSU_if_golden (clk);
  ALSU_golden_wrapper golden_dut (ALSU_if_golden);

  bind ALSU_wrapper ALSU_sva #(.INPUT_PRIORITY("A"),.FULL_ADDER("ON")) sva_instance (ALSU_if);
  
  // Example 2
  // Set the virtual interface for the uvm test

  initial begin
    uvm_config_db#(virtual ALSU_if)::set(null, "uvm_test_top", "ALSU_IF", ALSU_if);
    uvm_config_db#(virtual ALSU_if)::set(null, "uvm_test_top", "ALSU_IF_Golden", ALSU_if_golden);
    run_test("ALSU_test");

  end

  
endmodule