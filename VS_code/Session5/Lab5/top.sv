////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
import shift_reg_test_pkg::*;
`include "uvm_macros.svh"

module top();
  // Example 1
  // Clock generation
  // Instantiate the interface and DUT
  // run test using run_test task

  bit clk;
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  shift_reg_if shift_if (clk);
  shift_reg_wrapper dut (shift_if);
  
  // Example 2
  // Set the virtual interface for the uvm test

  initial begin
    uvm_config_db#(virtual shift_reg_if)::set(null, "uvm_test_top", "SHIFT_IF", shift_if);
    run_test("shift_reg_test");

  end

  
endmodule