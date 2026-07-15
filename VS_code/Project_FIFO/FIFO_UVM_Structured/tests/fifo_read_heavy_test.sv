class fifo_read_heavy_test extends FIFO_base_test;
  `uvm_component_utils(fifo_read_heavy_test)

  function new(string name = "fifo_read_heavy_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    FIFO_main_seq_1 seq;
    seq = FIFO_main_seq_1::type_id::create("seq");
    run_fifo_sequence(phase, seq, "Read-heavy randomized sequence");
  endtask
endclass
