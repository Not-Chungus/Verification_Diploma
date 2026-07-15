class fifo_write_heavy_test extends FIFO_base_test;
  `uvm_component_utils(fifo_write_heavy_test)

  function new(string name = "fifo_write_heavy_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    FIFO_main_seq_2 seq;

    phase.raise_objection(this);
    apply_reset();

    seq = FIFO_main_seq_2::type_id::create("seq");
    `uvm_info(get_type_name(), "Starting write-heavy sequence", UVM_LOW)
    seq.start(env.agt.sqr);

    phase.drop_objection(this);
  endtask
endclass
