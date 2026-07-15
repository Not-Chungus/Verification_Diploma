class FIFO_base_test extends uvm_test;
  `uvm_component_utils(FIFO_base_test)

  FIFO_env    env;
  FIFO_config FIFO_cfg;

  function new(string name = "FIFO_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env      = FIFO_env::type_id::create("env", this);
    FIFO_cfg = FIFO_config::type_id::create("FIFO_cfg");

    if (!uvm_config_db#(virtual FIFO_if)::get(this, "", "FIFO_IF", FIFO_cfg.FIFO_vif))
      `uvm_fatal("FIFO_BASE_TEST", "Unable to get FIFO_IF from uvm_config_db")

    // All descendants reuse the same configured environment.
    uvm_config_db#(FIFO_config)::set(this, "env.agt", "CFG", FIFO_cfg);
  endfunction

  task apply_reset();
    FIFO_reset_seq reset_seq;
    reset_seq = FIFO_reset_seq::type_id::create("reset_seq");

    `uvm_info(get_type_name(), "Applying FIFO reset", UVM_LOW)
    reset_seq.start(env.agt.sqr);
    `uvm_info(get_type_name(), "FIFO reset released", UVM_LOW)
  endtask

  task run_fifo_sequence(
    uvm_phase        phase,
    uvm_sequence_base sequence_to_run,
    string           description
  );
    if (sequence_to_run == null)
      `uvm_fatal("FIFO_BASE_TEST", "A null sequence was passed to run_fifo_sequence")

    phase.raise_objection(this, description);
    apply_reset();

    `uvm_info(get_type_name(), {description, " started"}, UVM_LOW)
    sequence_to_run.start(env.agt.sqr);
    `uvm_info(get_type_name(), {description, " completed"}, UVM_LOW)

    phase.drop_objection(this, description);
  endtask

endclass
