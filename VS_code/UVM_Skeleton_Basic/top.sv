////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
import FIFO_test_pkg::*;
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

  FIFO_if F_if (clk);
  FIFO dut (F_if);
  
  bind FIFO FIFO_sva sva_instance (F_if);
  
  // Example 2
  // Set the virtual interface for the uvm test

  initial begin
    uvm_config_db#(virtual FIFO_if)::set(null, "uvm_test_top", "FIFO_IF", F_if);
    run_test("FIFO_test");

  end

  
endmodule