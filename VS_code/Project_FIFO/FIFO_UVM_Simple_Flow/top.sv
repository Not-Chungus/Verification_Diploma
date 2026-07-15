////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO UVM testbench top
////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
import FIFO_test_pkg::*;
`include "uvm_macros.svh"

module top;

  bit clk;

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  FIFO_if F_if(clk);
  FIFO    dut(F_if);

  bind FIFO FIFO_sva sva_instance(F_if);

  initial begin
    uvm_config_db#(virtual FIFO_if)::set(
      null, "uvm_test_top", "FIFO_IF", F_if);

    // The selected test is supplied using +UVM_TESTNAME=<test_class>.
    run_test();
  end

endmodule
