////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package ALSU_env_pkg;
import uvm_pkg::*;
//import shift_reg_drv_pkg::*;
`include "uvm_macros.svh"

//1.
class ALSU_env extends uvm_env;
  `uvm_component_utils(ALSU_env) //2.

  // Do the essentials (factory register & Constructor)
  //shift_driver driver;

  //3.
  function new(string name = "shift_reg_env", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  // Example 2
  // Build the driver in the build phase

  //4.
  /*
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //driver = shift_driver::type_id::create("driver", this);

  endfunction
  */



endclass
endpackage




