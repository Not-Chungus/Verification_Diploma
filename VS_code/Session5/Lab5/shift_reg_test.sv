////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package shift_reg_test_pkg;
import shift_reg_env_pkg::*;
import shift_reg_cfg_pkg::*; //
import uvm_pkg::*;
`include "uvm_macros.svh"


class shift_reg_test extends uvm_test;
  // Example 1
  // Do the essentials (factory register & Constructor)
  // Build the enviornment in the build phase
  // Run in the test in the run phase, raise objection, add #100 delay then display a message using `uvm_info, then drop the objection
  shift_reg_env env;
  shift_config shift_cfg; //

  
  function new(string name = "shift_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = shift_env::type_id::create("env", this);
    shift_cfg = shift_config::type_id::create("shift_cfg");

    if(!uvm_config_db #(virtual shift_reg_if)::get(this, "", "SHIFT_IF", shift_cfg.shift_vif))
     
      `uvm_fatal("build_phase", "Can't get Interface from database!!!");
    
    uvm_config_db #(shift_config)::set(this, "*", "CFG", shift_cfg);

  endfunction



  // Example 2
  // Build the config object in the build phase
  // get the virtual interface and assign it to the virtual interface of the config object
  // set the config obj in the config db
endclass: shift_reg_test
endpackage