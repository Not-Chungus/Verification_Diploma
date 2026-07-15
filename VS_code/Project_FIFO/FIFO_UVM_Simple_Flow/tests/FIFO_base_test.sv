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

    if (!uvm_config_db #(virtual FIFO_if)::get(
          this, "", "FIFO_IF", FIFO_cfg.FIFO_vif))
      `uvm_fatal("BUILD", "Cannot get FIFO_IF from uvm_config_db")

    uvm_config_db #(FIFO_config)::set(this, "*", "CFG", FIFO_cfg);
  endfunction

  task apply_reset();
    FIFO_reset_seq reset_seq;

    reset_seq = FIFO_reset_seq::type_id::create("reset_seq");
    `uvm_info(get_type_name(), "Starting reset sequence", UVM_LOW)
    reset_seq.start(env.agt.sqr);
  endtask
endclass
