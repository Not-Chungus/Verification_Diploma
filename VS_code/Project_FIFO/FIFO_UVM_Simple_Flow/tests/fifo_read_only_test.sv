class fifo_read_only_test extends FIFO_base_test;
  `uvm_component_utils(fifo_read_only_test)

  function new(string name = "fifo_read_only_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    FIFO_rd_only_seq seq;

    phase.raise_objection(this);
    apply_reset();

    seq = FIFO_rd_only_seq::type_id::create("seq");
    `uvm_info(get_type_name(), "Starting read-only sequence", UVM_LOW)
    seq.start(env.agt.sqr);

    phase.drop_objection(this);
  endtask
endclass
