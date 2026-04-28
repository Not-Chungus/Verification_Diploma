////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package shift_reg_env_pkg;
import uvm_pkg::*;
import shift_reg_agent_pkg::*;
import shift_reg_scoreboard_pkg::*;
import shift_reg_coverage_pkg::*;
`include "uvm_macros.svh"

//1.
class shift_reg_env extends uvm_env;
  // Example 1 (Done for you)
  // Do the essentials (factory register & Constructor)
  `uvm_component_utils(shift_reg_env) //2.

  shift_reg_agent agt;
  shift_scoreboard sb;
  shift_coverage cov;


  //3.
  function new(string name = "shift_reg_env", uvm_component parent = null);    
    super.new(name,parent);
  endfunction

  // Example 2
  // Build the driver in the build phase

  //4.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      
    agt = shift_reg_agent::type_id::create("agt", this);
    sb = shift_scoreboard::type_id::create("sb", this);
    cov = shift_coverage::type_id::create("cov", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agt.agt_ap.connect(cov.cov_export);
    agt.agt_ap.connect(sb.sb_export);


  endfunction




endclass
endpackage




