package FIFO_test_pkg;

  import uvm_pkg::*;
  import FIFO_env_pkg::*;
  import FIFO_cfg_pkg::*;
  import FIFO_seq_pkg::*;
  `include "uvm_macros.svh"

  // Base class must be included before all derived tests.
  `include "FIFO_base_test.sv"
  `include "fifo_write_only_test.sv"
  `include "fifo_read_only_test.sv"
  `include "fifo_read_heavy_test.sv"
  `include "fifo_write_heavy_test.sv"

endpackage
