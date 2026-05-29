////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_test_pkg;

import uvm_pkg::*;
import FIFO_env_pkg::*;
import FIFO_cfg_pkg::*;
import FIFO_seq_pkg::*;
`include "uvm_macros.svh"

//1.
class FIFO_test extends uvm_test;
  `uvm_component_utils(FIFO_test)  //2. 
  // Example 1
  // Do the essentials (factory register & Constructor)
  // Build the enviornment in the build phase
  // Run in the test in the run phase, raise objection, add #100 delay then display a message using `uvm_info, then drop the objection
  FIFO_env env;
  FIFO_config FIFO_cfg;

  FIFO_reset_seq reset_seq;
  FIFO_wr_only_seq wr_only_seq;
  FIFO_rd_only_seq rd_only_seq;
  FIFO_main_seq_1 main_seq_1;
  FIFO_main_seq_2 main_seq_2;

  //3.
  function new(string name = "FIFO_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //4.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = FIFO_env::type_id::create("env", this);
    FIFO_cfg = FIFO_config::type_id::create("FIFO_cfg");
    reset_seq = FIFO_reset_seq::type_id::create("reset_seq");
    wr_only_seq = FIFO_wr_only_seq::type_id::create("wr_only_seq");
    rd_only_seq = FIFO_rd_only_seq::type_id::create("rd_only_seq");
    main_seq_1 = FIFO_main_seq_1::type_id::create("main_seq_1");
    main_seq_2 = FIFO_main_seq_2::type_id::create("main_seq_2");
    

    if(!uvm_config_db #(virtual FIFO_if)::get(this, "", "FIFO_IF", FIFO_cfg.FIFO_vif))   
      `uvm_fatal("build_phase", "Can't get Interface from database!!!");
    
    uvm_config_db #(FIFO_config)::set(this, "*", "CFG", FIFO_cfg);

  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info("run_phase", "Reset asserted" , UVM_LOW)
    reset_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Reset deasserted" , UVM_LOW)
    
    `uvm_info("run_phase", "Write only sequence started" , UVM_LOW)
    wr_only_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Write only sequence done" , UVM_LOW)

    `uvm_info("run_phase", "Read only sequence started" , UVM_LOW)
    rd_only_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Read only sequence done" , UVM_LOW)

    `uvm_info("run_phase", "Read more probable sequence started" , UVM_LOW)
    main_seq_1.start(env.agt.sqr);
    `uvm_info("run_phase", "Read more probable sequence done" , UVM_LOW)

    `uvm_info("run_phase", "Write more probable sequence started" , UVM_LOW)
    main_seq_2.start(env.agt.sqr);
    `uvm_info("run_phase", "Write more probable sequence done" , UVM_LOW)

    phase.drop_objection(this);
  endtask

  // Example 2
  // Build the config object in the build phase
  // get the virtual interface and assign it to the virtual interface of the config object
  // set the config obj in the config db
endclass: FIFO_test
endpackage