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
`include "uvm_macros.svh"

//1.
class ALSU_test extends uvm_test;
  `uvm_component_utils(ALSU_test)  //2.

  // Do the essentials (factory register & Constructor)
  // Build the enviornment in the build phase
  // Run in the test in the run phase, raise objection, add #100 delay then display a message using `uvm_info, then drop the objection
  ALSU_env env;
  virtual ALSU_if ALSU_vif;

  //3.
  function new(string name = "ALSU_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //4.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(virtual ALSU_if)::get(this, "", "ALSU_IF", ALSU_vif))   
      `uvm_fatal("build_phase", "Can't get Interface from database!!!");
    
    uvm_config_db #(virtual ALSU_if)::set(this, "*", "FROM_ENV", ALSU_vif);

    env = ALSU_env::type_id::create("env", this);

  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info("run_phase_of_test", "Inside the ALSU test", UVM_MEDIUM)
    #100;

    phase.drop_objection(this);
  endtask

endclass: ALSU_test
endpackage