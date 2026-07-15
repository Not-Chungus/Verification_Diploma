class fifo_read_only_test extends FIFO_base_test;
  `uvm_component_utils(fifo_read_only_test)

  function new(string name = "fifo_read_only_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    FIFO_rd_only_seq seq;
    seq = FIFO_rd_only_seq::type_id::create("seq");
    run_fifo_sequence(phase, seq, "Read-only sequence");
  endtask
endclass
