////////////////////////////////////////////////////////////////////////////////
// FIFO UVM testbench top
////////////////////////////////////////////////////////////////////////////////
module tb_top;

  import uvm_pkg::*;
  import FIFO_test_pkg::*;
  `include "uvm_macros.svh"

  bit clk;

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  FIFO_if F_if(clk);
  FIFO    dut(F_if);

  bind FIFO FIFO_sva sva_instance(F_if);

  initial begin
    // The selected test is supplied with +UVM_TESTNAME=<class_name> in the makefile
    uvm_config_db#(virtual FIFO_if)::set(
      null,
      "uvm_test_top",
      "FIFO_IF",
      F_if
    );

    run_test();
  end

endmodule
