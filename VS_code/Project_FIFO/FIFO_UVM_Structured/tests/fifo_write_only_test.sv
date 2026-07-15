class fifo_write_only_test extends FIFO_base_test;
  `uvm_component_utils(fifo_write_only_test)

  function new(string name = "fifo_write_only_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    FIFO_wr_only_seq seq;
    seq = FIFO_wr_only_seq::type_id::create("seq");
    run_fifo_sequence(phase, seq, "Write-only sequence");
  endtask
endclass
