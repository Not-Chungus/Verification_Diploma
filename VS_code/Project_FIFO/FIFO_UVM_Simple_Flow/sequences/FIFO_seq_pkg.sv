package FIFO_seq_pkg;
  import shared_pkg::*;
  import FIFO_seq_item_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "FIFO_reset_seq.sv"
  `include "FIFO_wr_only_seq.sv"
  `include "FIFO_rd_only_seq.sv"
  `include "FIFO_main_seq_1.sv"
  `include "FIFO_main_seq_2.sv"
endpackage
