////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package ALSU_test_pkg;

import uvm_pkg::*;
import ALSU_env_pkg::*;
import ALSU_cfg_pkg::*;
import ALSU_seq_pkg::*;
`include "uvm_macros.svh"

//1.
class ALSU_test extends uvm_test;
  `uvm_component_utils(ALSU_test)  //2. 
  // Example 1
  // Do the essentials (factory register & Constructor)
  // Build the enviornment in the build phase
  // Run in the test in the run phase, raise objection, add #100 delay then display a message using `uvm_info, then drop the objection
  ALSU_env env;
  ALSU_config ALSU_cfg;

  ALSU_reset_seq reset_seq;
  ALSU_Constrained_main_seq seq_1;
  ALSU_Heavy_opcode_verification_seq seq_2;

  //3.
  function new(string name = "ALSU_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //4.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ALSU_env::type_id::create("env", this);
    ALSU_cfg = ALSU_config::type_id::create("ALSU_cfg");
    
    reset_seq = ALSU_reset_seq::type_id::create("reset_seq", this);
    seq_1 = ALSU_Constrained_main_seq::type_id::create("seq_1" , this);
    seq_2 = ALSU_Heavy_opcode_verification_seq::type_id::create("seq_2" , this);

    if(!uvm_config_db #(virtual ALSU_if)::get(this, "", "ALSU_IF", ALSU_cfg.ALSU_vif))   
      `uvm_fatal("build_phase", "Can't get Interface from database!!!");
    if(!uvm_config_db #(virtual ALSU_if)::get(this, "", "ALSU_IF_Golden", ALSU_cfg.ALSU_if_golden))   
      `uvm_fatal("build_phase", "Can't get Interface from database!!!");
    
    uvm_config_db #(ALSU_config)::set(this, "*", "CFG", ALSU_cfg);

  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info("run_phase", "Reset asserted" , UVM_LOW)
    reset_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Reset deasserted" , UVM_LOW)

    `uvm_info("run_phase", "Full constrained Randomization generation started" , UVM_LOW)
    seq_1.start(env.agt.sqr);
    `uvm_info("run_phase", "Full constrained Randomization generation done" , UVM_LOW)

    `uvm_info("run_phase", "Pure randomization for each valid opcode generation started" , UVM_LOW)
    seq_2.start(env.agt.sqr);
    `uvm_info("run_phase", "Pure randomization for each valid opcode generation done" , UVM_LOW)

    phase.drop_objection(this);
  endtask

  // Example 2
  // Build the config object in the build phase
  // get the virtual interface and assign it to the virtual interface of the config object
  // set the config obj in the config db
endclass: ALSU_test
endpackage